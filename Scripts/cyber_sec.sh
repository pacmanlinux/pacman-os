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
		nmap|whois|dnsenum|wireshark|tcpdump|hydra|john|binwalk|gdb|radare2|aircrack-ng|nikto|ettercap|logstash|suricata|sleuthkit|hashcat|reaver|ettercap|openvas|iperf3|netcat|htop|strace|lsof|firejail|apparmor|fail2ban|ufw|btop|glances|inxi)
			sudo pacman -S --noconfirm "$TOOL"
			;;

		#--yay / AUR Tools-------------------------------------------->
		theHarvester|recon-ng|wpscan|burpsuite|msfconsole|ghidra|empire|ossec|mobSF|gobuster|bettercap|mitmproxy|drozer|veil|sn0int|kismet|wireshark-qt|cutter|dirsearch|faraday|beef|exploitdb|apktool|wifite|armitage)
			yay -S --noconfirm "$TOOL"
			;;

		#--pip Tools-------------------------------------------->
		shodan|sqlmap|SpiderFoot|GHunt|volatility|cewl|autochrome|cloudscrapper|pywhat|detect-it-easy|impacket|mitm6|fierce|python-nmap)
			pip install "$TOOL"
			;;

		#--Go Tools-------------------------------------------->
		ffuf|amass|subfinder|httpx|nuclei|naabu)
			go install "$TOOL"
			;;

		#--Manual or Download-------------------------------------------->
		maltego|autopsy|ScoutSuite|Pacu|IDA-Free|searchsploit|linPEAS|winPEAS|kube-hunter)
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
		nmap|whois|dnsenum|wireshark|tcpdump|hydra|john|binwalk|gdb|radare2|aircrack-ng|nikto|ettercap|logstash|suricata|sleuthkit|hashcat|reaver|ettercap|openvas|iperf3|netcat|htop|strace|lsof|firejail|apparmor|fail2ban|ufw|btop|glances|inxi)
			sudo pacman -Rns --noconfirm "$TOOL"
			;;

		theHarvester|recon-ng|wpscan|burpsuite|msfconsole|ghidra|empire|ossec|mobSF|gobuster|bettercap|mitmproxy|drozer|veil|sn0int|kismet|wireshark-qt|cutter|dirsearch|faraday|beef|exploitdb|apktool|wifite|armitage|wafw00f)
			yay -Rns --noconfirm "$TOOL"
			;;

		shodan|sqlmap|SpiderFoot|GHunt|volatility|cewl|autochrome|cloudscrapper|pywhat|detect-it-easy|impacket|mitm6|fierce|python-nmap)
			pip uninstall -y "$TOOL"
			;;

		ffuf|amass|subfinder|httpx|nuclei|naabu)
			rm -f "$(go env GOPATH)/bin/$TOOL"
			;;

		maltego|autopsy|ScoutSuite|Pacu|IDA-Free|searchsploit|linPEAS|winPEAS|kube-hunter)
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
		"PassWord Cracking" \
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
			submenu "Recon" nmap whois dnsenum theHarvester recon-ng shodan amass subfinder httpx naabu ffuf
			;;
		"Web Hacking")
			submenu "Web" wpscan burpsuite sqlmap nikto ffuf gobuster dirsearch wafw00f 
			;;
		"Exploitation")
			submenu "Exploitation" msfconsole searchsploit drozer veil armitage exploitdb
			;;
		"Post-Exploitation")
			submenu "Post" empire linPEAS winPEAS sn0int beef
			;;
		"Password Cracking")
			submenu "Passwords" john hashcat hydra cewl crunch
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
			submenu "Forensics" autopsy volatility sleuthkit binwalk
			;;
		"Reverse Engineering")
			submenu "Reverse Engineering" gdb ghidra radare2 cutter IDA-Free
			;;
		"Binary Analysis")
			submenu "Binary" detect-it-easy apktool apktool
			;;
		"Container Security")
			submenu "Containers" trivy dockscan kube-hunter 
			;;
		"MITM / Network Attacks")
			submenu "Network Attacks" mitmproxy bettercap ettercap mitm6 wireshark tcpdump netcat
			;;
		"Blue Team")
			submenu "Blue Team" ossec logstash suricata ufw fail2ban apparmor firejail
			;;
		"System Utilities")
			submenu "System" htop glances inix btop strace lsof iperf3 python-nmap autochrome
			;;
		"Exit" |*)
			exit 0
			;;
		esac
	done
}

main_menu