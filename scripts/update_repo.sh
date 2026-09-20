#!/bin/bash

# what does this do?
# It signs RPM packages, generates scoped RPM repository metadata per architecture/version, commits the changes to Git, and pushes them to the remote repository.

set -euo pipefail

# Ensure script runs from the repository root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_DIR"

# Ensure standard system paths are in the PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:${PATH:-}"

echo "Locating RPM packages in repository subtrees..."
mapfile -t ALL_RPMS < <(find . -type f -name "*.rpm" -not -path "*/repodata/*" | sort)

if [ "${#ALL_RPMS[@]}" -eq 0 ]; then
    echo "No RPM packages found in repository."
    exit 0
fi

echo "Signing RPM packages (${#ALL_RPMS[@]} total)..."
rpmsign --resign "${ALL_RPMS[@]}"

echo "Generating scoped RPM repository metadata per architecture/version..."
# Find all unique directories containing RPMs (e.g., 10/x86_64, 10/aarch64)
mapfile -t RPM_DIRS < <(for rpm in "${ALL_RPMS[@]}"; do dirname "$rpm"; done | sort -u)

for dir in "${RPM_DIRS[@]}"; do
    # Skip root directory if any bootstrap RPM sits there; metadata belongs in subtrees
    if [ "$dir" == "." ]; then
        continue
    fi
    echo "Creating repodata for subtree: $dir"
    createrepo_c --retain-old-md=3 "$dir"
done

# Check if Git is initialized
if [ -d ".git" ]; then
    # Security audit before staging
    SENSITIVE_FILES=$(git status --porcelain | awk '{print $2}' | grep -E '\.(key|pem|asc|p12|env.*)$' || true)
    if [[ -n "${SENSITIVE_FILES}" ]]; then
        echo "❌ ERROR: Sensitive file(s) detected in repository:"
        echo "${SENSITIVE_FILES}"
        echo "Aborting commit to prevent accidental secret leak."
        exit 1
    fi

    echo "Staging changes in Git..."
    git add -A
    
    # Check if there are changes to commit
    if git diff --cached --quiet; then
        echo "No repository changes to commit."
    else
        echo "Committing updates..."
        git commit -m "Update repository metadata and packages: $(date +'%Y-%m-%d %H:%M:%S')"
        
        # Check if remote exists before trying to push
        if git remote | grep -q "^origin$"; then
            BRANCH=$(git rev-parse --abbrev-ref HEAD)
            echo "Pushing changes to GitHub ($BRANCH)..."
            git push origin "$BRANCH" || echo "Warning: Git push failed. Please ensure the repository 'steve-rock-wheelhouser/wheelhouserllc-repo' exists on GitHub and your SSH keys are set up correctly."
        else
            echo "Warning: No remote named 'origin' configured. Skipping push."
        fi
    fi
fi

echo "Repository update complete!"
