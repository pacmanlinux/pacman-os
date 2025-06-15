#! /bin/bash
set -eou pipefail

#====================================================>
# 	PacMan Linux CyberSecurity Toolkit Manager
#---------------------------------------------------->         
# Supports Install/Uninstall  by Category and Toolkit    
# Mode: install | uninstall
# Requries: pacman, yay, pip, go (where applicable)		
#====================================================>

MODE=${1:-}
[[ "$MODE" != "install" && "$MODE" != "uninstall" ]] && {
	echo "Usage: $0 [install|uninstall]"
	exit 1
}

pause() {
	echo 
	read -rp "Press [Enter] to Continue"
}

install_tool() {
	TOOL=$1
	case $TOOL in 
		#--Pacman Tools-------------------------------------------->
		trivy|metasploit|sqlmap|python-shodan|nmap|whois|wireshark|tcpdump|hydra|john|binwalk|gdb|radare2|aircrack-ng|nikto|ettercap|logstash|suricata|sleuthkit|hashcat|reaver|ettercap|openvas|iperf3|netcat|htop|strace|lsof|firejail|apparmor|fail2ban|btop|glances|inxi)
			sudo pacman -S --noconfirm "$TOOL"
			;;

		#--yay / AUR Tools-------------------------------------------->
		python-nmap|kube-hunter-bin|android-apktool|detect-it-easy-bin/ida-free|volatility3|autopsy|spiderfoot|maltego|crunch|cewl-git|wafw00f|ffuf|naabu|httpx|subfinder|amass|recon-ng|wpscan|burpsuite|ghidra|powershell-empire|ossec-hids-local|mobSF|gobuster|bettercap|mitmproxy|veil|sn0int|kismet|wireshark-qt|cutter|dirsearch|faraday|beef|exploitdb|apktool|wifite|armitage|dnsenum2)
		yay -S --noconfirm "$TOOL"
			;;

		#--pip Tools-------------------------------------------->
		shodan|GHunt|autochrome|cloudscrapper|pywhat|impacket)
			pip install "$TOOL"
			;;

		#--Go Tools-------------------------------------------->
		nuclei)
			go install "$TOOL"@latest
			;;

		#--Manual or Download-------------------------------------------->
		fierce|ScoutSuite|Pacu|searchsploit|linPEAS|winPEAS|drozer|mitm6)
			echo "[!] Please Download and install $TOOL Manually"
			;;
		*)	
			echo "[X] Unknown Tool: $TOOL"
			;;
		esac
}

uninstall_tool() {
	TOOL=$1
	case "$TOOL" in 
		trivy|metasploit|sqlmap|python-shodan|nmap|whois|wireshark|tcpdump|hydra|john|binwalk|gdb|radare2|aircrack-ng|nikto|ettercap|logstash|suricata|sleuthkit|hashcat|reaver|ettercap|openvas|iperf3|netcat|htop|strace|lsof|firejail|apparmor|fail2ban|btop|glances|inxi)
			sudo pacman -Rns --noconfirm "$TOOL"
			;;

		python-nmap|kube-hunter-bin|android-apktool|detect-it-easy-bin|ida-free|volatility3|autopsy|spiderfoot|maltego|crunch|cewl-git|ffuf|naabu|httpx|subfinder|amass|recon-ng|wpscan|burpsuite|ghidra|powershell-empire|ossec-hids-local|mobSF|gobuster|bettercap|mitmproxy|veil|sn0int|kismet|wireshark-qt|cutter|dirsearch|faraday|beef|exploitdb|apktool|wifite|armitage|wafw00f|dnsenum2)
			yay -Rns --noconfirm "$TOOL"
			;;

		shodan|GHunt|cewl|autochrome|cloudscrapper|pywhat|impacket)
			pip uninstall -y "$TOOL"
			;;

		nuclei)
			rm -f "$(go env GOPATH)/bin/$TOOL"
			;;

		fierce|ScoutSuite|Pacu|searchsploit|linPEAS|winPEAS|drozer|mitm6)
			echo "[!] Please Uninstall $TOOL Manually"
			;;
		*)	
			echo "[X] Unknown Tool: $TOOL"
			;;
		esac
}

submenu() {
	local CATEGORY_NAME="S1"
	shift
	local TOOLS=("$@")

	while true; do
		TOOL=$(printf "%s\n" "${TOOLS[@]}" "Return to Main Menu" | fzf --height=20 --border --prompt="${MODE} :: ${CATEGORY_NAME} > ")
		[[ "$TOOL" == "Return to Main Menu" || -z "$TOOL" ]] && return
		if [[ "$MODE" == "install" ]]; then
			install_tool "$TOOL"
		else
			uninstall_tool "$TOOL"
		fi
		pause
	done
}

main_menu() {
	while true; do
		CATEGORY=$(printf "%s\n" \
		"Recon" \
		"Web Hacking" \
		"Exploitation" \
		"Post-Exploitation" \
		"Password Cracking" \
		"Wireless Attacks" \
		"OSINT" \
		"Cloud Security" \
		"Forensics" \
		"Reverse Engineering" \
		"Binary Analysis" \
		"Container Security" \
		"MITM / Network Attacks" \
		"Blue Team" \
		"System Utilities" \
		"Exit" | fzf --height=20 --border --prompt="$MODE :: Categories > ")

		case $CATEGORY in 
		"Recon")
			submenu "Recon" nmap whois dnsenum2 recon-ng shodan amass subfinder httpx naabu ffuf
			;;
		"Web Hacking")
			submenu "Web" wpscan burpsuite sqlmap nikto ffuf gobuster dirsearch wafw00f 
			;;
		"Exploitation")
			submenu "Exploitation" metasploit searchsploit drozer veil armitage exploitdb
			;;
		"Post-Exploitation")
			submenu "Post" powershell-empire linPEAS winPEAS sn0int beef
			;;
		"Password Cracking")
			submenu "Passwords" john hashcat hydra cewl-git crunch
			;;
		"Wireless Attacks")
			submenu "Wireless" aircrack-ng kismet reaver wifite
			;;
		"OSINT")
			submenu "OSINT" maltego SpiderFoot GHunt fierce
			;;
		"Cloud Security")
			submenu "Cloud" ScoutSuite Pacu cloudscrapper
			;;
		"Forensics")
			submenu "Forensics" autopsy volatility3 sleuthkit binwalk
			;;
		"Reverse Engineering")
			submenu "Reverse Engineering" gdb ghidra radare2 cutter ida-free
			;;
		"Binary Analysis")
			submenu "Binary" detect-it-easy-bin android-apktool
			;;
		"Container Security")
			submenu "Containers" trivy kube-hunter-bin
			;;
		"MITM / Network Attacks")
			submenu "Network Attacks" mitmproxy bettercap ettercap mitm6 wireshark tcpdump netcat
			;;
		"Blue Team")
			submenu "Blue Team" ossec-hids-local logstash suricata fail2ban apparmor firejail
			;;
		"System Utilities")
			submenu "System" glances inxi strace lsof iperf3 python-nmap python-shodan autochrome
			;;
		"Exit" |*)
			exit 0
			;;
		esac
	done
}

main_menu
