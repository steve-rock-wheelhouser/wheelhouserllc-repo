#!/usr/bin/env bash
# Wheelhouser LLC (c) 2026 - Universal Debian/Ubuntu APT Repository Setup Script
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (e.g. curl -fsSL https://repo.wheelhouser.com/setup-apt.sh | sudo bash)" >&2
    exit 1
fi

DISTRO="debian"
if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO="${ID:-debian}"
fi

case "$DISTRO" in
    ubuntu)
        TARGET_REPO="ubuntu/26.04"
        DISTRO_LABEL="Ubuntu 26.04 LTS"
        ;;
    debian)
        TARGET_REPO="debian/13"
        DISTRO_LABEL="Debian 13 (Trixie)"
        ;;
    *)
        TARGET_REPO="debian/13"
        DISTRO_LABEL="Debian-compatible"
        ;;
esac

echo "============================================================"
echo " Setting up Wheelhouser APT Repository ($DISTRO_LABEL)"
echo "============================================================"

echo "==> Installing GPG keyring directory..."
install -m 0755 -d /etc/apt/keyrings

echo "==> Fetching and importing Wheelhouser signing key..."
curl -fsSL https://repo.wheelhouser.com/steve-rock-wheelhouser-gpg.key | gpg --dearmor --yes -o /etc/apt/keyrings/wheelhouser.gpg
chmod a+r /etc/apt/keyrings/wheelhouser.gpg

echo "==> Configuring /etc/apt/sources.list.d/wheelhouser.list..."
echo "deb [signed-by=/etc/apt/keyrings/wheelhouser.gpg] https://repo.wheelhouser.com/${TARGET_REPO} ./" > /etc/apt/sources.list.d/wheelhouser.list

echo "==> Updating APT package cache..."
apt update

if [ -n "${1:-}" ]; then
    echo "==> Installing package: $1..."
    apt install -y "$1"
fi

echo "============================================================"
echo " Wheelhouser APT Repository setup successfully completed!"
if [ -n "${1:-}" ]; then
    echo " Package '$1' installed."
else
    echo " You can now install packages with: sudo apt install <package>"
fi
echo "============================================================"
