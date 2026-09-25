# Wheelhouser LLC Linux Package Repository (RPM & APT)

This is the unified multi-distribution package repository for Wheelhouser LLC's Linux applications and utilities, supporting both **RPM (DNF)** for **Enterprise Linux (Rocky Linux 10, AlmaLinux 10)** and **Fedora 44**, and **DEB (APT)** for **Debian 13 (Trixie)** and **Ubuntu 26.04 LTS** across architectures (`x86_64`, `aarch64`, `all`).

---

## Repository Architecture

Packages and repositories are organized in a clean hierarchical layout:
```text
wheelhouserllc-repo/
├── rocky/
│   └── 10/
│       ├── x86_64/
│       └── aarch64/
├── almalinux/
│   └── 10/
│       ├── x86_64/
│       └── aarch64/
├── fedora/
│   └── 44/
│       ├── x86_64/
│       └── aarch64/
├── debian/
│   └── 13/
│       ├── *.deb
│       ├── Packages (.gz)
│       └── Release (.gpg, InRelease)
├── ubuntu/
│   ├── 26.04/
│   │   ├── *.deb
│   │   ├── Packages (.gz)
│   │   └── Release (.gpg, InRelease)
│   └── 24/
│       ├── *.deb
│       ├── Packages (.gz)
│       └── Release (.gpg, InRelease)
├── steve-rock-wheelhouser-gpg.key
├── rocky.repo
├── almalinux.repo
├── fedora.repo
├── debian.sources
├── ubuntu.sources
├── debian.list
├── ubuntu.list
├── index.html
├── CNAME
├── .nojekyll
└── README.md
```

**Web Endpoint**: [https://repo.wheelhouser.com](https://repo.wheelhouser.com)

---

## 1. Configure the Repository

### Rocky Linux / Enterprise Linux 10

#### Option A: Install via Release Bootstrap RPM (Recommended)
```bash
sudo dnf install https://repo.wheelhouser.com/rocky/10/x86_64/steve-rock-wheelhouser-release-1.0-6.el10.noarch.rpm
```

#### Option B: Manual Setup
```bash
sudo curl -sL https://repo.wheelhouser.com/rocky.repo -o /etc/yum.repos.d/wheelhouser.repo
```

---

### AlmaLinux 10

#### Option A: Install via Release Bootstrap RPM (Recommended)
```bash
sudo dnf install https://repo.wheelhouser.com/almalinux/10/x86_64/steve-rock-wheelhouser-release-1.0-6.el10.noarch.rpm
```

#### Option B: Manual Setup
```bash
sudo curl -sL https://repo.wheelhouser.com/almalinux.repo -o /etc/yum.repos.d/wheelhouser.repo
```

---

### Fedora 44

#### Option A: Install via Release Bootstrap RPM (Recommended)
```bash
sudo dnf install https://repo.wheelhouser.com/fedora/44/x86_64/steve-rock-wheelhouser-release-1.0-6.fc44.noarch.rpm
```

#### Option B: Manual Setup
```bash
sudo curl -sL https://repo.wheelhouser.com/fedora.repo -o /etc/yum.repos.d/wheelhouser.repo
```

---

### Debian 13 (Trixie) & Ubuntu 26.04 LTS

#### APT Repository Setup
```bash
# 1. Install keyring directory and download official Wheelhouser GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://repo.wheelhouser.com/steve-rock-wheelhouser-gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/wheelhouser.gpg
sudo chmod a+r /etc/apt/keyrings/wheelhouser.gpg

# 2. Add repository source
# For Debian 13:
echo "deb [signed-by=/etc/apt/keyrings/wheelhouser.gpg] https://repo.wheelhouser.com/debian/13 ./" | sudo tee /etc/apt/sources.list.d/wheelhouser.list

# For Ubuntu 26.04 LTS:
echo "deb [signed-by=/etc/apt/keyrings/wheelhouser.gpg] https://repo.wheelhouser.com/ubuntu/26.04 ./" | sudo tee /etc/apt/sources.list.d/wheelhouser.list

# 3. Update index and install packages
sudo apt update
sudo apt install antigravity-ide
```

---

## 2. Available Packages

Once the repository is configured on your system:

* **`antigravity-ide`** (`v1.0.0-38`): Open-source packaging and launcher utility for Google Antigravity IDE (Rocky Linux 10, AlmaLinux 10, Fedora 44, Debian 13, Ubuntu 26.04 LTS).
  * **DNF (RPM):** `sudo dnf install antigravity-ide`
  * **APT (DEB):** `sudo apt install antigravity-ide`

* **`text-editor`** (`v0.14.2`): Professional desktop text editor with code folding, multi-cursor editing, and syntax highlighting across 15+ programming languages.
  * **DNF (RPM):** `sudo dnf install text-editor`

* **`rocky-linux-setup`** (`v1.0.0`): Post-install workstation optimization, bootstrap, and system configuration utility (Rocky Linux 10).
  * **DNF (RPM):** `sudo dnf install rocky-linux-setup`

* **`web-browser`** (`v0.14.1`): Fast, lightweight, privacy-focused desktop web browser with PySide6/QtWebEngine desktop integration.
  * **DNF (RPM):** `sudo dnf install web-browser`

---

## 3. Cryptographic Verification

All RPM packages and `repodata/repomd.xml` metadata files, as well as all DEB packages and APT release indexes (`InRelease`, `Release.gpg`), are cryptographically signed with Wheelhouser LLC's official 4096-bit RSA packaging key (`310B962A`).
