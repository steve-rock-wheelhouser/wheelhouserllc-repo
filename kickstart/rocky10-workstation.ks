# ==============================================================================
# rocky10-workstation.ks
# Automated Unattended Kickstart Configuration for Rocky Linux 10 Workstation
# Wheelhouser LLC (c) 2026
# ==============================================================================
#
# Usage:
#   At Anaconda boot prompt:
#     inst.ks=https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/kickstart/rocky10-workstation.ks
#
# ==============================================================================

# Installation mode
text
reboot --eject

# Localization
lang en_US.UTF-8
keyboard us
timezone America/New_York --utc

# Network configuration
network --bootproto=dhcp --device=link --activate --onboot=on --hostname=rocky10

# Security & Services
firewall --enabled --service=ssh
selinux --enforcing
services --enabled=sshd,NetworkManager

# Storage & Partitioning (Automated single-disk setup)
zerombr
clearpart --all --initlabel
autopart --type=lvm

# Authentication (Default credentials - change immediately post-install!)
rootpw --plaintext rocky
user --name=user --groups=wheel --plaintext --password=rocky --gecos="Rocky Developer"

# ==============================================================================
# Additional Repositories
# ==============================================================================
repo --name="AppStream" --baseurl="https://dl.rockylinux.org/pub/rocky/10/AppStream/x86_64/os/"
repo --name="CRB" --baseurl="https://dl.rockylinux.org/pub/rocky/10/CRB/x86_64/os/"
repo --name="EPEL" --baseurl="https://dl.fedoraproject.org/pub/epel/10/Everything/x86_64/"
repo --name="wheelhouser" --baseurl="https://raw.githubusercontent.com/steve-rock-wheelhouser/wheelhouserllc-repo/main/rocky/10/x86_64/"

# ==============================================================================
# Package Selection
# ==============================================================================
%packages --retries=5
@core
@standard
@development
git
curl
wget

# Wheelhouser LLC Packages (injected during OS install)
steve-rock-wheelhouser-release
rocky-linux-setup

# Recommended desktop tools & libraries
tar
bzip2
unzip
%end

# ==============================================================================
# Post-Installation Scriptlet
# ==============================================================================
%post --log=/root/kickstart-post.log
echo "============================================================"
echo "  Wheelhouser LLC Post-Install Provisioning"
echo "============================================================"

# Ensure CRB and EPEL are active in system configuration
dnf config-manager --set-enabled crb 2>/dev/null || dnf config-manager setopt crb.enabled=1 2>/dev/null || true
dnf config-manager --set-enabled epel 2>/dev/null || dnf config-manager setopt epel.enabled=1 2>/dev/null || true

# Run initial status inspection
if [ -x /usr/bin/rocky-linux-setup ]; then
    /usr/bin/rocky-linux-setup --status || true
fi

echo "✅ Provisioning complete!"
%end
