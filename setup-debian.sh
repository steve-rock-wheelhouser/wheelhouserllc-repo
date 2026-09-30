#!/usr/bin/env bash
# Wheelhouser LLC (c) 2026 - Debian 13 (Trixie) APT Repository Setup Script
set -euo pipefail

echo "============================================================"
echo " Setting up Wheelhouser APT Repository (Debian 13 Trixie)"
echo "============================================================"

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (e.g. curl -fsSL https://repo.wheelhouser.com/setup-debian.sh | sudo bash)" >&2
    exit 1
fi

echo "==> Installing GPG keyring directory..."
install -m 0755 -d /etc/apt/keyrings

echo "==> Fetching and importing Wheelhouser signing key..."
curl -fsSL https://repo.wheelhouser.com/steve-rock-wheelhouser-gpg.key | gpg --dearmor --yes -o /etc/apt/keyrings/wheelhouser.gpg
chmod a+r /etc/apt/keyrings/wheelhouser.gpg

echo "==> Configuring /etc/apt/sources.list.d/wheelhouser.list..."
echo "deb [signed-by=/etc/apt/keyrings/wheelhouser.gpg] https://repo.wheelhouser.com/debian/13 ./" > /etc/apt/sources.list.d/wheelhouser.list

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
