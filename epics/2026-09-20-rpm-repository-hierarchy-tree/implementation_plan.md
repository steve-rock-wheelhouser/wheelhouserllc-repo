# Implementation Plan: RPM Repository Hierarchy & Dynamic DNF Tree Layout

Refactor `rocky-repo` from a flat monolithic directory layout into an enterprise-grade hierarchical tree structure (`<releasever>/<basearch>/`) adhering to [AGENTS.md Section 7](file:///home/user/Projects/AGENTS.md#7-rpm-repository-hierarchy--architecture-standards). This eliminates package version cross-contamination, enables future Rocky 11 and multi-architecture (`aarch64`) support, and configures dynamic client substitution (`$releasever` and `$basearch`) in repository configuration files.

## User Review Required

> [!IMPORTANT]
> **Client-Facing URL Change**:
> The `baseurl` in [steve-rock-wheelhouser.repo](file:///home/user/Projects/rocky-repo/steve-rock-wheelhouser.repo) will be updated from:
> ```ini
> baseurl=https://raw.githubusercontent.com/steve-rock-wheelhouser/rocky-repo/main/
> ```
> to:
> ```ini
> baseurl=https://raw.githubusercontent.com/steve-rock-wheelhouser/rocky-repo/main/$releasever/$basearch/
> ```
> Existing Rocky 10 machines with the old `.repo` file will need to update their `.repo` configuration or reinstall the updated `steve-rock-wheelhouser-release` RPM. We will retain a bootstrap copy of the release package and repo file at the repository root to ensure direct `curl`/`dnf install <url>` bootstrap commands continue to function seamlessly.

## Open Questions

> [!NOTE]
> 1. **Initial Architectures for Rocky Linux 10**:
>    - We propose initializing `10/x86_64/` immediately.
>    - For `noarch` packages (like `antigravity-ide`), should we also initialize `10/aarch64/` (ARM64) so Raspberry Pi / ARM64 Rocky Linux users can install it?
>    - *Recommendation: Yes, initialize both `10/x86_64/` and `10/aarch64/` and place `noarch` packages into both.*

---

## Proposed Changes

### Component 1: `rocky-repo` Repository Layout & Automation

#### [MODIFY] [steve-rock-wheelhouser.repo](file:///home/user/Projects/rocky-repo/steve-rock-wheelhouser.repo)
- Update `baseurl` to use `$releasever/$basearch/`:
  ```ini
  [steve-rock-wheelhouser]
  name=Wheelhouser LLC Custom Rocky Linux RPM Repository - $releasever - $basearch
  baseurl=https://raw.githubusercontent.com/steve-rock-wheelhouser/rocky-repo/main/$releasever/$basearch/
  enabled=1
  gpgcheck=1
  gpgkey=https://raw.githubusercontent.com/steve-rock-wheelhouser/rocky-repo/main/steve-rock-wheelhouser-gpg.key
  metadata_expire=300
  ```

#### [NEW] Directory Tree in `rocky-repo`
- Create `10/x86_64/` and `10/aarch64/`.
- Move existing `antigravity-ide-*.el10.noarch.rpm` into the tree.
- Remove legacy root-level `repodata/`.
- Generate scoped `repodata/` inside each active `<releasever>/<basearch>/` directory.

#### [MODIFY] [update_repo.sh](file:///home/user/Projects/rocky-repo/update_repo.sh)
- Refactor `update_repo.sh` to:
  1. Recursively find and sign all `.rpm` files in all subdirectories.
  2. Iterate through each `<releasever>/<basearch>` leaf directory and execute `createrepo_c "$dir"`.
  3. Cleanly stage, commit, and push updates.

---

### Component 2: `antigravity-ide` Publishing Pipeline

#### [MODIFY] [publish.sh](file:///home/user/Projects/antigravity-ide/publish.sh)
- Parse target release version from RPM metadata (`%{DIST}`) and architecture (`%{ARCH}`).
  - If `.el10` and `noarch`: route to `$REPO_DIR/10/x86_64/` (and `$REPO_DIR/10/aarch64/`).
  - If `.fc44` and `noarch`: route to `$REPO_DIR/44/x86_64/`.
- Maintain retention policies (keeping the 2 most recent builds) scoped *per sub-directory*.
- Copy the latest bootstrap release package to both the subtrees and root for legacy/bootstrap compatibility.
- Execute `$REPO_DIR/update_repo.sh`.

#### [MODIFY] [build_release_rpm.sh](file:///home/user/Projects/antigravity-ide/build_release_rpm.sh)
- Ensure the updated `steve-rock-wheelhouser.repo` is packaged into the new release bootstrap RPM.

---

### Component 3: Epics & Governance Documentation

#### [NEW] [rocky-repo/epics/2026-09-20-rpm-repository-hierarchy-tree/implementation_plan.md](file:///home/user/Projects/rocky-repo/epics/2026-09-20-rpm-repository-hierarchy-tree/implementation_plan.md)
- Archive this implementation plan in `rocky-repo/epics/` per `AGENTS.md Section 6`.

---

## Verification Plan

### Automated Tests
1. **Directory Tree Validation**: Verify `10/x86_64/repodata/repomd.xml` is successfully created by `createrepo_c`.
2. **GPG Signature Check**: Run `rpmsign --checksig 10/x86_64/*.rpm` to confirm valid signatures.
3. **Repository Metadata Parsing**: Run `dnf --repofrompath` test locally on Rocky Linux 10 to confirm DNF resolves `$releasever` and `$basearch` without errors:
   ```bash
   dnf --disablerepo="*" --repofrompath="test-wheelhouser,$PWD/10/x86_64" repoquery --info antigravity-ide
   ```

### Manual Verification
- Rebuild release package and run `./publish.sh --target rocky`.
- Test `dnf update` and `dnf info antigravity-ide` on Rocky Linux 10 VM.
