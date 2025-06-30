#! /usr/bin/env bash

#--> PacMan Linux
#--> BlackArch Installer (arch-based systems)
#--> Version 1.0

if [ "$(id -u)" -ne 0 ]; then
	echo "[!] Run as Root: sudo $0"
	exit 1
fi

#-->

clear

SKIP_ARCH_CHECK=false
if [[ "$1" == "--force" ]]; then
	echo "[!] Skipping Arch Linux Check (--force flag used)"
	SKIP_ARCH_CHECK=true
fi

#--> Verify Arch Linux (unless skipped)
if ! $SKIP_ARCH_CHECK && ! grep -q "ID_LIKE=.*arch" /etc/os-release 2>/dev/null; then
	echo "[!] WARNING: This System Does NOT Report as Arch-based in /etc/os-release [!]"
	echo "If You Have Modified This File, Use --force to continue"
	echo "Otherwise This Installation May FAIL"
	exit 1
fi

#-->

REPO_FILE="/etc/pacman.d/blackarch-mirrorlist"
KEYRING_PKG="blackarch-keyring"
STRAP_URL="https://blackarch.org/strap.sh"

#-->

cleanup() {
	echo "[!] Rolling Back Changes [!]"
	[ -f "$REPO_FILE" ] && { sed -i '/\[blackarch\]/,+3d' /etc/pacman.conf; rm -f "$REPO_FILE"; }
	pacman -Q "$KEYRING_PKG" &>/dev/null && pacman -Rns --noconfirm "$KEYRING_PKG"
	pacman -Syy >/dev/null 2>&1 
	echo "[!] BlackArch Repository Removed [!]"
	exit 1
}
trap cleanup ERR INT TERM 

#-->

echo "[!] Adding BlackArch Repository [!]"
if ! curl -sLO "$STRAP_URL"; then
	echo "[!] Failed to Download strap.sh"
	exit 1
fi

chmod +x strap.sh 
if ! ./strap.sh; then
	rm -f strap.sh
	cleanup
fi
rm -f strap.sh  

if ! grep -q "\[blackarch\]" /etc/pacman.conf; then
	echo "[!] Repository NOT Added to pacman.conf [!]"
	cleanup
fi

echo "[!] BlackArch Repository Added Successfully [!]"
echo "[!] Install Tools With: pacman -S blackarch-<category>"
exit 0