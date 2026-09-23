# Wheelhouser LLC Custom Linux RPM Repository

This is the unified multi-distribution RPM repository for Wheelhouser LLC's Linux applications and utilities, supporting **Enterprise Linux (Rocky Linux 10, AlmaLinux 10)** and **Fedora 44** across multiple architectures (`x86_64`, `aarch64`).

---

## Repository Architecture

Packages are organized in a clean hierarchical layout adhering to [AGENTS.md Section 7](https://github.com/steve-rock-wheelhouser/wheelhouserllc-repo):
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
├── steve-rock-wheelhouser-gpg.key
├── rocky.repo
├── almalinux.repo
├── fedora.repo
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

### Fedora

#### Option A: Install via Release Bootstrap RPM (Recommended)
```bash
sudo dnf install https://repo.wheelhouser.com/fedora/44/x86_64/steve-rock-wheelhouser-release-1.0-6.fc44.noarch.rpm
```

#### Option B: Manual Setup
```bash
sudo curl -sL https://repo.wheelhouser.com/fedora.repo -o /etc/yum.repos.d/wheelhouser.repo
```

---

### Debian 13 (Trixie) & Ubuntu 24

#### APT Repository Setup
```bash
# 1. Install keyring directory and download official Wheelhouser GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://repo.wheelhouser.com/steve-rock-wheelhouser-gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/wheelhouser.gpg
sudo chmod a+r /etc/apt/keyrings/wheelhouser.gpg

# 2. Add repository source (Debian 13)
echo "deb [signed-by=/etc/apt/keyrings/wheelhouser.gpg] https://repo.wheelhouser.com/debian/13 ./" | sudo tee /etc/apt/sources.list.d/wheelhouser.list

# For Ubuntu 24, use:
# echo "deb [signed-by=/etc/apt/keyrings/wheelhouser.gpg] https://repo.wheelhouser.com/ubuntu/24 ./" | sudo tee /etc/apt/sources.list.d/wheelhouser.list

# 3. Update index and install packages
sudo apt update
sudo apt install antigravity-ide
```

---

## 2. Available Packages

Once the repository is configured:

* **`antigravity-ide`**: Open-source packaging and launcher utility for Google Antigravity IDE (Rocky Linux 10, AlmaLinux 10, Fedora 44).
  ```bash
  sudo dnf install antigravity-ide
  ```

* **`rocky-linux-setup`**: Post-install workstation optimization, bootstrap, and system configuration utility (Rocky Linux 10).
  ```bash
  sudo dnf install rocky-linux-setup
  ```

* **`web-browser`**: Fast, lightweight, privacy-focused desktop web browser (Fedora 44).
  ```bash
  sudo dnf install web-browser
  ```
