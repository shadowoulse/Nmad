k#!/bin/bash

# ===============================
#  COLORS
# ===============================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

# ===============================
#  ASCII BANNER
# ===============================
clear
echo -e "${CYAN}"
echo " ███╗   ██╗███╗   ███╗ █████╗ ██████╗ "
echo " ████╗  ██║████╗ ████║██╔══██╗██╔══██╗"
echo " ██╔██╗ ██║██╔████╔██║███████║██║  ██║"
echo " ██║╚██╗██║██║╚██╔╝██║██╔══██║██║  ██║"
echo " ██║ ╚████║██║ ╚═╝ ██║██║  ██║██████╔╝"
echo " ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝ "
echo -e "${RESET}"
echo -e "${YELLOW}        Advanced Nmap Toolkit${RESET}"
echo ""

# ===============================
#  TARGET INPUT
# ===============================
echo -e "${CYAN}Enter IP or domain to scan:${RESET}"
read TARGET

if [ -z "$TARGET" ]; then
    echo -e "${RED}[ERROR] No target entered. Exiting.${RESET}"
    exit 1
fi

# ===============================
#  SCAN SPEED MENU
# ===============================
echo ""
echo -e "${YELLOW}Choose scan speed (T0–T5):${RESET}"
echo "1) T0  (Paranoid - Slowest)"
echo "2) T1  (Sneaky)"
echo "3) T2  (Polite)"
echo "4) T3  (Normal)"
echo "5) T4  (Aggressive)"
echo "6) T5  (Insane - Fastest)"

read -p "Select option (1–6): " SPEED_CHOICE

case $SPEED_CHOICE in
    1) SPEED="T0" ;;
    2) SPEED="T1" ;;
    3) SPEED="T2" ;;
    4) SPEED="T3" ;;
    5) SPEED="T4" ;;
    6) SPEED="T5" ;;
    *)
        echo -e "${RED}[ERROR] Invalid selection. Using default T3.${RESET}"
        SPEED="T3"
        ;;
esac

# ===============================
#  OS DETECTION PROMPT
# ===============================
echo ""
read -p "Do you want to detect the OS? (y/n): " OS_CHOICE

if [[ "$OS_CHOICE" == "y" || "$OS_CHOICE" == "Y" ]]; then
    OS_FLAG="-O"
    echo -e "${GREEN}[+] OS detection enabled.${RESET}"
else
    OS_FLAG=""
    echo -e "${YELLOW}[-] OS detection disabled.${RESET}"
fi

# ===============================
#  NSE SCRIPTS MENU LOOP
# ===============================
echo ""
echo -e "${CYAN}Select NSE script categories (choose as many as you want):${RESET}"

declare -a NSE_SCRIPTS=()
while true; do
    echo ""
    echo " 1) auth"
    echo " 2) broadcast"
    echo " 3) brute"
    echo " 4) default"
    echo " 5) discovery"
    echo " 6) dos"
    echo " 7) exploit"
    echo " 8) external"
    echo " 9) fuzzer"
    echo "10) intrusive"
    echo "11) malware"
    echo "12) safe"
    echo "13) version"
    echo "14) vuln"
    echo "15) Done selecting"
    echo ""

    read -p "Choose an option: " NSE_CHOICE

    case $NSE_CHOICE in
        1) NSE_SCRIPTS+=("auth") ;;
        2) NSE_SCRIPTS+=("broadcast") ;;
        3) NSE_SCRIPTS+=("brute") ;;
        4) NSE_SCRIPTS+=("default") ;;
        5) NSE_SCRIPTS+=("discovery") ;;
        6) NSE_SCRIPTS+=("dos") ;;
        7) NSE_SCRIPTS+=("exploit") ;;
        8) NSE_SCRIPTS+=("external") ;;
        9) NSE_SCRIPTS+=("fuzzer") ;;
        10) NSE_SCRIPTS+=("intrusive") ;;
        11) NSE_SCRIPTS+=("malware") ;;
        12) NSE_SCRIPTS+=("safe") ;;
        13) NSE_SCRIPTS+=("version") ;;
        14) NSE_SCRIPTS+=("vuln") ;;
        15) break ;;
        *)
            echo -e "${RED}[ERROR] Invalid choice.${RESET}"
            continue
            ;;
    esac

    echo -e "${GREEN}[Added]${RESET} ${NSE_SCRIPTS[-1]}"
done

if [ ${#NSE_SCRIPTS[@]} -gt 0 ]; then
    NSE_STRING=$(IFS=, ; echo "${NSE_SCRIPTS[*]}")
    NSE_FLAG="--script=$NSE_STRING"
    echo -e "${GREEN}[+] NSE scripts selected:${RESET} $NSE_STRING"
else
    NSE_FLAG=""
    echo -e "${YELLOW}[-] No NSE scripts selected.${RESET}"
fi

# ===============================
#  HOST UP CHECK
# ===============================
echo ""
echo -e "${BLUE}[*] Checking if $TARGET is up...${RESET}"
UP=$(nmap -sn "$TARGET" 2>/dev/null | grep "Host is up")

if [ -n "$UP" ]; then
    echo -e "${GREEN}[+] Host is up! Running scan...${RESET}"
else
    echo -e "${RED}[-] Host appears to be down. Exiting.${RESET}"
    exit 1
fi

# ===============================
#  PRIMARY SCAN
# ===============================
echo ""
echo -e "${CYAN}[*] Starting primary scan...${RESET}"
sudo nmap -sS -$SPEED -F -v $OS_FLAG $NSE_FLAG "$TARGET"

# ===============================
#  OPTIONAL FULL STEALTH SCAN
# ===============================
echo ""
echo "----------------------------------------"
read -p "Do you want to run a sneaky full (-A) scan? (y/n): " FULL_CHOICE
echo "----------------------------------------"

if [[ "$FULL_CHOICE" == "y" || "$FULL_CHOICE" == "Y" ]]; then

    echo ""
    echo -e "${YELLOW}Choose full-scan speed:${RESET}"
    echo "1) T0 (Paranoid - slowest)"
    echo "2) T1 (Sneaky)"
    echo "3) T2 (Polite)"
    echo "4) T3 (Normal)"
    echo "5) T4 (Aggressive)"
    echo "6) T5 (Insane fast)"

    read -p "Select option: " FULL_SPEED_CHOICE

    case $FULL_SPEED_CHOICE in
        1) FULL_SPEED="T0" ;;
        2) FULL_SPEED="T1" ;;
        3) FULL_SPEED="T2" ;;
        4) FULL_SPEED="T3" ;;
        5) FULL_SPEED="T4" ;;
        6) FULL_SPEED="T5" ;;
        *)
            echo -e "${RED}[ERROR] Invalid choice. Defaulting to T0.${RESET}"
            FULL_SPEED="T0"
            ;;
    esac

    echo -e "${CYAN}[*] Running full stealth scan (-A) with $FULL_SPEED...${RESET}"
    sudo nmap -A -sS -$FULL_SPEED -v "$TARGET"
else
    echo -e "${GREEN}[+] Skipping full scan. Done.${RESET}"
fi

echo ""
echo -e "${GREEN}All scans complete.${RESET}"

