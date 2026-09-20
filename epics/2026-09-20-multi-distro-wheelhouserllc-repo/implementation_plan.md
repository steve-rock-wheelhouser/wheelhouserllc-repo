# Multi-Distribution Architecture & Migration to `wheelhouserllc-repo`

Migrate and rename `rocky-repo` to `wheelhouserllc-repo`, transitioning to the enterprise multi-distribution RPM repository hierarchy: `<distro>/<releasever>/<basearch>/`. This establishes a unified repository for all Wheelhouser LLC Linux applications across both Rocky Linux (Enterprise Linux) and Fedora, updates the build and release pipelines, synchronizes repository configuration packages, and updates baseline governance standards in [AGENTS.md](file:///home/user/Projects/AGENTS.md).

---

## User Review Required

> [!IMPORTANT]
> **Repository Rename & GitHub Remote**:
> 1. **Local Rename**: The local directory `/home/user/Projects/rocky-repo` will be renamed to `/home/user/Projects/wheelhouserllc-repo`.
> 2. **Git Remote**: The git remote URL will be updated to `git@github.com:steve-rock-wheelhouser/wheelhouserllc-repo.git`.
>    *(Note: You will need to rename the repository on GitHub under **Settings -> Repository name** from `rocky-repo` to `wheelhouserllc-repo` if you haven't already done so).*
> 3. **Base URLs & Paths**:
>    - Rocky Linux baseurl: `https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/rocky/$releasever/$basearch/`
>    - Fedora baseurl: `https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/fedora/$releasever/$basearch/`

---

## Proposed Changes

### Component 1: Repository Directory & Git Remote Migration

#### [MODIFY] [Projects Directory Structure](file:///home/user/Projects)
- Rename `/home/user/Projects/rocky-repo` to `/home/user/Projects/wheelhouserllc-repo`.
- Update git remote `origin` within the renamed repository:
  ```bash
  git remote set-url origin git@github.com:steve-rock-wheelhouser/wheelhouserllc-repo.git
  ```

---

### Component 2: Multi-Distro Tree Reorganization in `wheelhouserllc-repo`

#### [NEW] Directory Hierarchy in `wheelhouserllc-repo`
- Create distribution trees:
  - `rocky/10/x86_64/`
  - `rocky/10/aarch64/`
  - `fedora/44/x86_64/`
  - `fedora/44/aarch64/`
- Move existing Rocky 10 packages (`antigravity-ide-*.el10.noarch.rpm` and `steve-rock-wheelhouser-release-*.el10.noarch.rpm`) from `10/x86_64/` and `10/aarch64/` into `rocky/10/x86_64/` and `rocky/10/aarch64/`.
- Clean up legacy root-level `10/` directory.

#### [MODIFY] [update_repo.sh](file:///home/user/Projects/wheelhouserllc-repo/update_repo.sh) (in `wheelhouserllc-repo`)
- Ensure recursive detection finds all leaf directories across all distributions (e.g. `rocky/10/x86_64`, `fedora/44/x86_64`).
- Generate scoped repository metadata with `createrepo_c --retain-old-md=3 "$dir"`.
- Update remote URL references and status messages to reflect `wheelhouserllc-repo`.

---

### Component 3: Repository Configurations (`.repo`) & Release RPM Spec

#### [NEW] [steve-rock-wheelhouser-rocky.repo](file:///home/user/Projects/wheelhouserllc-repo/steve-rock-wheelhouser-rocky.repo) (in `wheelhouserllc-repo`)
- Configured specifically for Rocky Linux:
  ```ini
  [steve-rock-wheelhouser]
  name=Wheelhouser LLC RPM Repository - Rocky Linux $releasever - $basearch
  baseurl=https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/rocky/$releasever/$basearch/
  enabled=1
  gpgcheck=1
  gpgkey=https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/steve-rock-wheelhouser-gpg.key
  metadata_expire=300
  ```

#### [NEW] [steve-rock-wheelhouser-fedora.repo](file:///home/user/Projects/wheelhouserllc-repo/steve-rock-wheelhouser-fedora.repo) (in `wheelhouserllc-repo`)
- Configured specifically for Fedora:
  ```ini
  [steve-rock-wheelhouser]
  name=Wheelhouser LLC RPM Repository - Fedora $releasever - $basearch
  baseurl=https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/fedora/$releasever/$basearch/
  enabled=1
  gpgcheck=1
  gpgkey=https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/steve-rock-wheelhouser-gpg.key
  metadata_expire=300
  ```

#### [MODIFY] [steve-rock-wheelhouser-release.spec](file:///home/user/Projects/antigravity-ide/steve-rock-wheelhouser-release.spec)
- Update `URL` to `https://github.com/steve-rock-wheelhouser/wheelhouserllc-repo`.
- Bump package release version to `1.0-3%{?dist}` with a changelog entry.
- Dynamically package the appropriate `.repo` file depending on whether building for Fedora or RHEL/Rocky (`%if 0%{?rhel}` vs `%if 0%{?fedora}`).

---

### Component 4: Build & Publishing Pipelines in `antigravity-ide`

#### [MODIFY] [publish.sh](file:///home/user/Projects/antigravity-ide/publish.sh)
- Direct repository root to `../wheelhouserllc-repo`.
- Automatically extract distro prefix (`rocky` for `el*`, `fedora` for `fc*`) and major release version from RPM metadata (`%{RELEASE}`).
- Target path routing:
  - For `noarch` packages: copy to `$REPO_DIR/$DISTRO/$DISTRO_VER/x86_64/` and `$REPO_DIR/$DISTRO/$DISTRO_VER/aarch64/`.
  - For arch packages: copy to `$REPO_DIR/$DISTRO/$DISTRO_VER/$ARCH/`.
- Per-subtree build retention (retain 2 most recent builds).
- Execute `update_repo.sh` in `wheelhouserllc-repo`.

#### [MODIFY] [build_release_rpm.sh](file:///home/user/Projects/antigravity-ide/build_release_rpm.sh)
- Point `REPO_DIR` to `../wheelhouserllc-repo`.
- Support building release RPMs for `--target rocky` or `--target fedora`.
- Package and sign the respective release RPM (`1.0-3.el10.noarch.rpm` / `1.0-3.fc44.noarch.rpm`).

---

### Component 5: Governance & Baseline Standards

#### [MODIFY] [AGENTS.md](file:///home/user/Projects/AGENTS.md)
- Update Section 1: change `rocky-repo` reference to `wheelhouserllc-repo`.
- Update Section 7: change architecture standard from `<repo-root>/<releasever>/<basearch>/` to `<repo-root>/<distro>/<releasever>/<basearch>/`.
- Document distribution tags (`rocky/`, `fedora/`) and DNF client substitution patterns.

---

### Component 6: Documentation & Setup Script Synchronization

#### [MODIFY] [setup.sh](file:///home/user/setup/setup.sh)
- Update repo bootstrap URL to point to `wheelhouserllc-repo` under `rocky/10/x86_64/steve-rock-wheelhouser-release-1.0-3.el10.noarch.rpm`.

#### [MODIFY] [antigravity-ide/README.md](file:///home/user/Projects/antigravity-ide/README.md)
- Update badges, repository URLs, and curl/dnf installation commands for Rocky Linux 10 and Fedora to reference `wheelhouserllc-repo`.

#### [MODIFY] [wheelhouserllc-repo/README.md](file:///home/user/Projects/wheelhouserllc-repo/README.md)
- Update documentation to describe the unified multi-distro repository layout and provide setup instructions for both Rocky Linux and Fedora.

---

## Verification Plan

### Automated Tests
1. **Tree & Hierarchy Validation**:
   - Verify `rocky/10/x86_64/repodata/repomd.xml` and `rocky/10/aarch64/repodata/repomd.xml` are created.
   - Run `update_repo.sh` and ensure exit code 0.
2. **GPG Signatures**:
   - Run `rpmsign --checksig` across all `.rpm` files in the repository.
3. **DNF Compatibility**:
   - Run local `dnf repoquery` test against `rocky/10/x86_64` to verify metadata and package resolution:
     ```bash
     dnf --disablerepo="*" --repofrompath="test-wheelhouser,$PWD/rocky/10/x86_64" repoquery --info antigravity-ide
     ```
4. **Publishing Pipeline Dry Run**:
   - Execute `./build_release_rpm.sh --target rocky` and `./publish.sh --target rocky`.

### Manual Verification
- Verify `git status` across `wheelhouserllc-repo` and `antigravity-ide` to ensure no sensitive files or unwanted artifacts are staged.
