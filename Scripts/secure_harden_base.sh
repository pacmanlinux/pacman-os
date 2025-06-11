#! /bin/bash

### PacMan Linux Base Security Hardening Script ###

set -e

clear
echo 
echo "--> Updating System <--"
pacman -Syu --noconfirm
echo 
echo "--> Installing Hardened Kernel and Security Tools <--"
pacman -S --noconfirm linux-hardened apparmor audit fail2ban ufw

echo 
echo "--> Enabling Core Security Services <--"
systemctl enable apparmor
systemctl enable ufw 
systemctl enable fail2ban

echo 
echo "--> Configuring UFW (Uncomplicated Firewall) <--"
ufw default deny incoming
ufw default allow outgoing
ufw --force enable 

echo 
echo "--> Applying SysCtl Hardening <--"
cat <<EOF > /etc/sysctl.d/99-pacman-secure.conf 
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
net.ipv4.conf.all.rp_filter =1
net.ipv4.icmp_echo_ignore_broadcast = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept-redirects = 0
EOF
systemctl --system

echo 
echo "--> Disabling Unnecessary Sevices <--"
systemctl disable cups || true
systemctl disable avahi-daemon || true
systemctl disable bluetooth || true

echo 
echo "--> Ensuring Secure Permissions on Critical Files <--"
chmod 600 /etc/shadow
chmod 644 /etc/passwd

echo 
if [ -f /boot/grub/grub.cfg ]; then
	echo "[+] Detected GRUB. Attempting to set linux-hardened as the default kernel"
	sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT="Advanced Options for PacMan Linux>PacMan Linux, with linux-hardened"/' /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg 
	echo "[✅] GRUB Updated to Boot linux-hardened by default"
else
	echo "[!] GRUB not Detected or Custom Bootloader in use. Please set Kernel Manually if needed."
fi

echo 
echo "[✅] PacMan Linux System Hardening Complete!"