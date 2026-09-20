# Wheelhouser LLC Custom Linux RPM Repository

This is the unified multi-distribution RPM repository for Wheelhouser LLC's Linux applications and utilities, supporting both **Enterprise Linux (Rocky Linux)** and **Fedora** across multiple architectures (`x86_64`, `aarch64`).

---

## Repository Architecture

Packages are organized in a clean hierarchical layout adhering to [AGENTS.md Section 7](https://github.com/steve-rock-wheelhouser/wheelhouserllc-repo):
```text
wheelhouserllc-repo/
├── rocky/
│   ├── 10/
│   │   ├── x86_64/
│   │   │   ├── *.rpm
│   │   │   └── repodata/
│   │   └── aarch64/
│   │       ├── *.rpm
│   │       └── repodata/
│   └── ...
├── fedora/
│   ├── 44/
│   │   ├── x86_64/
│   │   │   ├── *.rpm
│   │   │   └── repodata/
│   │   └── aarch64/
│   │       ├── *.rpm
│   │       └── repodata/
│   └── ...
├── steve-rock-wheelhouser-gpg.key
├── rocky.repo
├── fedora.repo
└── update_repo.sh
```

---

## 1. Configure the Repository

### Rocky Linux / Enterprise Linux 10

#### Option A: Install via Release Bootstrap RPM (Recommended)
```bash
sudo dnf install https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/rocky/10/x86_64/steve-rock-wheelhouser-release-1.0-3.el10.noarch.rpm
```

#### Option B: Manual Setup
```bash
sudo curl -sL https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/rocky.repo -o /etc/yum.repos.d/wheelhouser.repo
```

---

### Fedora

#### Option A: Install via Release Bootstrap RPM (Recommended)
```bash
sudo dnf install https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/fedora/44/x86_64/steve-rock-wheelhouser-release-1.0-3.fc44.noarch.rpm
```

#### Option B: Manual Setup
```bash
sudo curl -sL https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/fedora.repo -o /etc/yum.repos.d/wheelhouser.repo
```

---

## 2. Available Packages

Once the repository is configured:

* **`antigravity-ide`**: Open-source packaging and launcher utility for Google Antigravity IDE.
  ```bash
  sudo dnf install antigravity-ide
  ```
