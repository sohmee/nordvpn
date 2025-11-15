#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

press_enter() {
    echo ""
    read -p "Press Enter to continue..."
}

show_status_panel() {
    echo -e "${BLUE}───────────── STATUS ─────────────${NC}"
    nordvpn status | sed 's/^/  /'
    echo -e "${YELLOW}Allowlisted ports:${NC}"
    nordvpn settings | awk '/Allowlisted ports:|Whitelisted ports:/,/(^$|Allowlisted subnets:|Whitelisted subnets:)/ {if($0 !~ /Allowlisted subnets:|Whitelisted subnets:/) print "  "$0}' | sed '/^  $/d'
    echo -e "${YELLOW}Allowlisted subnets:${NC}"
    nordvpn settings | awk '/Allowlisted subnets:|Whitelisted subnets:/,/(^$|DNS:)/ {if($0 !~ /DNS:/) print "  "$0}' | sed '/^  $/d'
    echo ""
}
get_lan_discovery_status() {
    nordvpn settings | grep 'LAN Discovery' | awk '{print $3}' | tr -d '.'
}

show_main_menu() {
    echo -e "${GREEN}NordVPN Complete Manager${NC} ${BLUE}(All Options)${NC}"
    echo "----------------------------------------------"
    printf "%-4s %-38s | %-4s %-38s\n" \
        "1."  "Connect to recommended server"             "13." "Threat Protection Lite" \
        "2."  "Connect to specific country"              "14." "Kill Switch" \
        "3."  "Connect to specific city"                 "15." "Auto-connect" \
        "4."  "Disconnect"                              "16." "Custom DNS" \
        "5."  "Set protocol (UDP/TCP)"                  "17." "Meshnet" \
        "6."  "Set technology (OpenVPN/NordLynx)"       "18." "LAN Discovery" \
        "7."  "Login"                                   "19." "Add Allowlist Port" \
        "8."  "Logout"                                  "20." "Remove Allowlist Port" \
        "9."  "View account info"                       "21." "Add Allowlist Subnet" \
        "10." "Register new account"                    "22." "Remove Allowlist Subnet" \
        "11." "Connect to Double VPN"                   "23." "Country list" \
        "12." "Connect to P2P server"                   "24." "City list" \
        ""     ""                                       "25." "Connection status" \
        ""     ""                                       "26." "View current settings" \
        ""     ""                                       "0."  "Exit"
    echo ""
}

while true; do
    clear
    show_main_menu
    show_status_panel
    read -p "Selection: " choice

    case $choice in
        1) nordvpn connect; press_enter ;;
        2)
            echo -e "${GREEN}Available Countries:${NC}"
            nordvpn countries
            echo ""
            read -p "Enter country name (0 to cancel): " country
            [[ "$country" == "0" ]] && continue
            [[ -n "$country" ]] && nordvpn connect "$country"
            press_enter
            ;;
        3)
            echo -e "${GREEN}Available Countries:${NC}"
            nordvpn countries
            echo ""
            read -p "Enter country name (0 to cancel): " country
            [[ "$country" == "0" ]] && continue
            [[ -z "$country" ]] && continue
            echo -e "\n${GREEN}Cities in $country:${NC}"
            nordvpn cities "$country"
            echo ""
            read -p "Enter city name (0 to cancel): " city
            [[ "$city" == "0" ]] && continue
            [[ -n "$city" ]] && nordvpn connect "$country $city"
            press_enter
            ;;
        4) nordvpn disconnect; press_enter ;;
        5)
            current_proto=$(nordvpn settings | grep 'Protocol' | awk '{print $4}')
            echo "Current protocol: $current_proto"
            echo "1. UDP (faster)"
            echo "2. TCP (more reliable)"
            echo "0. Cancel"
            read -p "Select protocol: " proto
            [[ "$proto" == "0" ]] && continue
            nordvpn set protocol $( [ "$proto" == "2" ] && echo "tcp" || echo "udp" )
            press_enter
            ;;
        6)
            current_tech=$(nordvpn settings | grep 'Technology' | awk '{print $4}')
            echo "Current technology: $current_tech"
            echo "1. NordLynx (recommended)"
            echo "2. OpenVPN"
            echo "0. Cancel"
            read -p "Select technology: " tech
            [[ "$tech" == "0" ]] && continue
            nordvpn set technology $( [ "$tech" == "2" ] && echo "OpenVPN" || echo "NordLynx" )
            press_enter
            ;;
        7) nordvpn login; press_enter ;;
        8) nordvpn logout; press_enter ;;
        9) nordvpn account; press_enter ;;
        10) nordvpn register; press_enter ;;
        11) nordvpn connect double_vpn; press_enter ;;
        12) nordvpn connect p2p; press_enter ;;
        13)
            current_tpl=$(nordvpn settings | grep 'Threat Protection Lite' | awk '{print $5}')
            echo "Current status: $current_tpl"
            echo "1. Enable"
            echo "2. Disable"
            echo "0. Cancel"
            read -p "Threat Protection: " tpro
            [[ "$tpro" == "0" ]] && continue
            nordvpn set threatprotectionlite $( [ "$tpro" == "1" ] && echo "on" || echo "off" )
            press_enter
            ;;
        14)
            current_ks=$(nordvpn settings | grep 'Kill Switch' | awk '{print $4}')
            echo "Current status: $current_ks"
            echo "1. Enable"
            echo "2. Disable"
            echo "0. Cancel"
            read -p "Kill Switch: " ks
            [[ "$ks" == "0" ]] && continue
            nordvpn set killswitch $( [ "$ks" == "1" ] && echo "on" || echo "off" )
            press_enter
            ;;
        15)
            current_ac=$(nordvpn settings | grep 'Auto-connect' | awk '{print $3}')
            echo "Current status: $current_ac"
            echo "1. Enable"
            echo "2. Disable"
            echo "0. Cancel"
            read -p "Auto-connect: " ac
            [[ "$ac" == "0" ]] && continue
            nordvpn set autoconnect $( [ "$ac" == "1" ] && echo "on" || echo "off" )
            press_enter
            ;;
        16)
            current_dns=$(nordvpn settings | grep 'DNS' -A1 | tail -n1 | sed 's/^ *//')
            echo "Current DNS: $current_dns"
            read -p "Enter DNS servers (space separated, 0 to cancel): " dns
            [[ "$dns" == "0" ]] && continue
            nordvpn set dns $dns
            press_enter
            ;;
        17)
            current_mesh=$(nordvpn settings | grep 'Meshnet' | awk '{print $3}')
            echo "Current status: $current_mesh"
            echo "1. Enable"
            echo "2. Disable"
            echo "0. Cancel"
            read -p "Meshnet: " mesh
            [[ "$mesh" == "0" ]] && continue
            nordvpn set meshnet $( [ "$mesh" == "1" ] && echo "on" || echo "off" )
            press_enter
            ;;
        18)
            current_status=$(get_lan_discovery_status)
            echo "1. Enable"
            echo "2. Disable"
            echo "0. Cancel"
            read -p "LAN Discovery (Current: $current_status): " option
            [[ "$option" == "0" ]] && continue
            if [ "$option" == "1" ]; then
                nordvpn set lan-discovery enable
            else
                nordvpn set lan-discovery disable
            fi
            press_enter
            ;;
        19)
            read -p "Enter port to allow (0 to cancel): " port
            [[ "$port" == "0" ]] && continue
            nordvpn whitelist add port $port
            press_enter
            ;;
        20)
            read -p "Enter port to remove (0 to cancel): " port
            [[ "$port" == "0" ]] && continue
            nordvpn whitelist remove port $port
            press_enter
            ;;
        21)
            read -p "Enter subnet to allow (e.g. 192.168.0.0/24, 0 to cancel): " subnet
            [[ "$subnet" == "0" ]] && continue
            nordvpn whitelist add subnet $subnet
            press_enter
            ;;
        22)
            read -p "Enter subnet to remove (0 to cancel): " subnet
            [[ "$subnet" == "0" ]] && continue
            nordvpn whitelist remove subnet $subnet
            press_enter
            ;;
        23)
            echo -e "${GREEN}Available Countries:${NC}"
            nordvpn countries
            press_enter
            ;;
        24)
            echo -e "${GREEN}Available Countries:${NC}"
            nordvpn countries
            read -p "Enter country name for cities (0 to cancel): " country
            [[ "$country" == "0" ]] && continue
            [[ -n "$country" ]] && nordvpn cities $country
            press_enter
            ;;
        25) nordvpn status; press_enter ;;
        26) nordvpn settings; press_enter ;;
        0) echo -e "${BLUE}Goodbye!${NC}"; exit 0 ;;
        *)
            echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
done