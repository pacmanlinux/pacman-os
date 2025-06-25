#! /usr/bin/env bash

#--> PacMan Linux
#--> Database Lock Remover Script (Arch-based Distros)
#--> Version 1.0

clear
echo ""
echo "PacMan Linux DBLock Remover"
echo ""

if [[ $EUID -ne 0 ]]; then
	echo "ERROR: This Script Must be run as Root [!]" >&2
	echo "Please Try Again with Sudo or as the Root User"
	exit 1
fi

LOCK_FILE="/var/lib/pacman/db.lck"

if [[ ! -f "$LOCK_FILE" ]]; then 
	echo "No Pacman Database Lock Found! Everything is Fine... Chill bro 😎"
	exit 0
fi

echo ""
echo "WARNING: Pacman Database Lock File Has Been Detected [!]"
echo ""
echo "Location: $LOCK_FILE"
echo ""
echo "This Usually Means pacman was Interrupted or is Already Running"
echo "Removing This Without Caution can Cause Database Corruption [!]"

if pgrep -x "pacman" >/dev/null; then
	echo "ERROR: Pacman is Currently Running [!]"
	echo "Please Wait For it to Finish or Terminate it Properly"
	exit 1
fi

read -p "Are You Sure You Want to Remove the pacman Database Lock? [y/N] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "[!] Operation Cancelled - No Changes Were Made [!]"
	exit 0
fi

if rm -f "$LOCK_FILE"; then
	echo "[!] The pacman Database Lock Has Now Been Removed [!]"
else
	echo "ERROR: Failed to Remove Lock File [!]"
	echo "Please Try Manually Removing:"
	echo "	sudo rm -v $LOCK_FILE"
	exit 1
fi

exit 0
