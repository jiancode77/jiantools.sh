#!/bin/bash

CORRECT_PASSWORD=$(echo "SmlhbkNvZGUjMzEy" | base64 -d)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

declare -A SUBDOMAIN_ZONES
declare -A SUBDOMAIN_TOKENS

SUBDOMAIN_ZONES=(
    ["pterodactyl-panel.web.id"]="d69feb7345d9e4dd5cfd7cce29e7d5b0"
    ["storedigital.web.id"]="2ce8a2f880534806e2f463e3eec68d31"
    ["storeid.my.id"]="c651c828a01962eb3c530513c7ad7dcf"
    ["store-panell.my.id"]="0189ecfadb9cf2c4a311c0a3ec8f0d5c"
    ["xyro.web.id"]="46d0cd33a7966f0be5afdab04b63e695"
    ["xyroku.my.id"]="f6d1a73a272e6e770a232c39979d5139"
    ["gacorr.biz.id"]="cff22ce1965394f1992c8dba4c3db539"
    ["cafee.my.id"]="0d7044fc3e0d66189724952fa3b850ce"
    ["pterodaytl.my.id"]="828ef14600aaaa0b1ea881dd0e7972b2"
    ["googlex.my.id"]="dda9e25dac2556c7494470ee6152fc7f"
    ["heavencraft.my.id"]="9e7239dcda7cbd6be79d7615257f56f8"
    ["hilman-store.web.id"]="4e214dfe36faa7c942bc68b5aecdd1e9"
    ["hilmanofficial.tech"]="c8705bfbfdca9c4e8e61eb2663ee87d6"
    ["hilmanzoffc.web.id"]="2627badfda28951bfb936fce0febc5b0"
    ["host-panel.web.id"]="74b3192f7c3b0925cdb8606bb7db95c4"
    ["hostingers-vvip.my.id"]="2341ae01634b852230b7521af26c261f"
)

SUBDOMAIN_TOKENS=(
    ["pterodactyl-panel.web.id"]="32zZwadzwc7qB4mzuDBJkk1xFyoQ2Grr27mAfJcB"
    ["storedigital.web.id"]="v5_unJTqruXV_x-5uj0dT5_Q4QAPThJbXzC2MmOQ"
    ["storeid.my.id"]="N-D6fN6la7jY0AnvbWn9FcU6ZHuDitmFXd-JF04g"
    ["store-panell.my.id"]="eVI-BXIXNEQtBqLpdvuitAR5nXC2bLj6jw365JPZ"
    ["xyro.web.id"]="CygwSHXRSfZnsi1qZmyB8s4qHC12jX_RR4mTpm62"
    ["xyroku.my.id"]="0Mae_Rtx1ixGYenzFcNG9bbPd-rWjoRwqN2tvNzo"
    ["gacorr.biz.id"]="v9kYfj5g2lcacvBaJHA_HRgNqBi9UlsVy0cm_EhT"
    ["cafee.my.id"]="wAOEzAfvb-L3vKYE2Xg8svJpHfNS_u2noWSReSzJ"
    ["pterodaytl.my.id"]="75HrVBzSVObD611RkuNS1ZKsL5A_b8kuiCs26-f9"
    ["googlex.my.id"]="GuT5rNQSr_V2kxb-QZdJ4YbFlEvzE-upzhey9Ezl"
    ["heavencraft.my.id"]="aHvYYKk7YIADVOfpG3i1eaIqTeWCdPS25FAPreDQ"
    ["hilman-store.web.id"]="wpQCANKLRAtWb0XvTRed3vwSkOMMWKO2C75uwnKE"
    ["hilmanofficial.tech"]="hjqWa_eFAfoJNJyBu9WAlg8WO0ICtN5AYpZURgqe"
    ["hilmanzoffc.web.id"]="wZ3QAKn7zDx-tyb04HgCvmogqeM6je8jDNmiPZXq"
    ["host-panel.web.id"]="GuT5rNQSr_V2kxb-QZdJ4YbFlEvzE-upzhey9Ezl"
    ["hostingers-vvip.my.id"]="Ztw1ouD8_lJf-QzRecgmijjsDJODFU4b-y697lPw"
)

show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔═════════════════════════════════════════════════════╗"
    echo "║                                                     ║"
    echo "║   ███████╗██╗   ██╗██████╗ ██████╗  ██████╗       ║"
    echo "║   ██╔════╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗      ║"
    echo "║   ███████╗██║   ██║██████╔╝██║  ██║██║   ██║      ║"
    echo "║   ╚════██║██║   ██║██╔══██╗██║  ██║██║   ██║      ║"
    echo "║   ███████║╚██████╔╝██████╔╝██████╔╝╚██████╔╝      ║"
    echo "║   ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝  ╚═════╝       ║"
    echo "║                                                     ║"
    echo "║        SUBDOMAIN CREATOR TOOL V2.0                  ║"
    echo "║           Created By VinnOfficial                   ║"
    echo "║                                                     ║"
    echo "╚═════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_password() {
    echo -e "${YELLOW}╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║              AUTENTIKASI DIPERLUKAN                 ║${NC}"
    echo -e "${YELLOW}╚═════════════════════════════════════════════════════╝${NC}"
    echo -e -n "${CYAN}Masukkan Password: ${NC}"
    read -s password
    echo ""
    
    if [ "$password" != "$CORRECT_PASSWORD" ]; then
        echo -e "${RED}✗ Password Salah!${NC}\n"
        exit 1
    fi
    echo -e "${GREEN}✓ Autentikasi Berhasil!${NC}\n"
    sleep 1
}

list_domains() {
    echo -e "${CYAN}╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           DAFTAR DOMAIN TERSEDIA                    ║${NC}"
    echo -e "${CYAN}╚═════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    counter=1
    for domain in "${!SUBDOMAIN_ZONES[@]}"; do
        echo -e "${YELLOW}  $counter.${NC} $domain"
        counter=$((counter + 1))
    done
    echo ""
}

create_subdomain() {
    local host=$1
    local ip=$2
    local domain=$3
    local zone=${SUBDOMAIN_ZONES[$domain]}
    local token=${SUBDOMAIN_TOKENS[$domain]}
    
    local clean_host=$(echo "$host" | sed 's/[^a-z0-9.-]//gi')
    local clean_ip=$(echo "$ip" | sed 's/[^0-9.]//g')
    
    local response=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$zone/dns_records" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"$clean_host.$domain\",\"content\":\"$clean_ip\",\"ttl\":1,\"proxied\":false}")
    
    local success=$(echo "$response" | grep -o '"success":[^,]*' | cut -d':' -f2)
    
    if [ "$success" == "true" ]; then
        echo "SUCCESS|$clean_host.$domain|$clean_ip"
    else
        local error=$(echo "$response" | grep -o '"message":"[^"]*"' | cut -d'"' -f4 | head -1)
        echo "FAILED|$error"
    fi
}

main_menu() {
    show_banner
    
    echo -e "${MAGENTA}╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║                   MENU UTAMA                        ║${NC}"
    echo -e "${MAGENTA}╠═════════════════════════════════════════════════════╣${NC}"
    echo -e "║  ${YELLOW}1.${NC} Buat Subdomain                                  ║"
    echo -e "║  ${YELLOW}2.${NC} Buat Subdomain + Node (Pterodactyl)            ║"
    echo -e "║  ${YELLOW}3.${NC} Lihat Daftar Domain                            ║"
    echo -e "║  ${YELLOW}4.${NC} Keluar                                         ║"
    echo -e "${MAGENTA}╚═════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e -n "${CYAN}Pilih menu (1-4): ${NC}"
    read choice
    
    case $choice in
        1)
            create_subdomain_menu
            ;;
        2)
            create_with_node_menu
            ;;
        3)
            list_domains
            echo -e -n "${YELLOW}Tekan Enter untuk kembali...${NC}"
            read
            main_menu
            ;;
        4)
            echo -e "${CYAN}\n👋 Terima kasih telah menggunakan Subdomain Creator!\n${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}\n✗ Pilihan tidak valid!\n${NC}"
            sleep 1
            main_menu
            ;;
    esac
}

create_subdomain_menu() {
    echo ""
    echo -e -n "${CYAN}Masukkan format (hostname|ip): ${NC}"
    read input
    
    if [[ ! "$input" =~ "|" ]]; then
        echo -e "${RED}\n✗ Format salah! Gunakan: hostname|ip\n${NC}"
        sleep 2
        main_menu
        return
    fi
    
    IFS='|' read -r host ip <<< "$input"
    host=$(echo "$host" | xargs)
    ip=$(echo "$ip" | xargs)
    
    list_domains
    
    echo -e -n "${CYAN}Pilih nomor domain: ${NC}"
    read domain_choice
    
    counter=1
    selected_domain=""
    for domain in "${!SUBDOMAIN_ZONES[@]}"; do
        if [ "$counter" == "$domain_choice" ]; then
            selected_domain=$domain
            break
        fi
        counter=$((counter + 1))
    done
    
    if [ -z "$selected_domain" ]; then
        echo -e "${RED}\n✗ Domain tidak ditemukan!\n${NC}"
        sleep 2
        main_menu
        return
    fi
    
    echo ""
    echo -e "${YELLOW}⏳ Membuat subdomain...${NC}"
    
    result=$(create_subdomain "$host" "$ip" "$selected_domain")
    
    if [[ "$result" == SUCCESS* ]]; then
        IFS='|' read -r status subdomain vps_ip <<< "$result"
        echo ""
        echo -e "${GREEN}╔═════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║          SUBDOMAIN BERHASIL DIBUAT                  ║${NC}"
        echo -e "${GREEN}╚═════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "  ${GREEN}✅ Sukses membuat Subdomain!${NC}"
        echo ""
        echo -e "  🌐 sᴜʙᴅᴏᴍᴀɪɴ: ${YELLOW}$subdomain${NC}"
        echo -e "  📌 ɪᴘ ᴠᴘs: ${YELLOW}$vps_ip${NC}"
        echo ""
        echo -e "${GREEN}╚═════════════════════════════════════════════════════╝${NC}"
    else
        IFS='|' read -r status error <<< "$result"
        echo -e "${RED}\n✗ Error: $error\n${NC}"
    fi
    
    echo ""
    echo -e -n "${YELLOW}Tekan Enter untuk kembali...${NC}"
    read
    main_menu
}

create_with_node_menu() {
    echo ""
    echo -e -n "${CYAN}Masukkan format (hostname|ip): ${NC}"
    read input
    
    if [[ ! "$input" =~ "|" ]]; then
        echo -e "${RED}\n✗ Format salah! Gunakan: hostname|ip\n${NC}"
        sleep 2
        main_menu
        return
    fi
    
    IFS='|' read -r host ip <<< "$input"
    host=$(echo "$host" | xargs)
    ip=$(echo "$ip" | xargs)
    
    list_domains
    
    echo -e -n "${CYAN}Pilih nomor domain: ${NC}"
    read domain_choice
    
    counter=1
    selected_domain=""
    for domain in "${!SUBDOMAIN_ZONES[@]}"; do
        if [ "$counter" == "$domain_choice" ]; then
            selected_domain=$domain
            break
        fi
        counter=$((counter + 1))
    done
    
    if [ -z "$selected_domain" ]; then
        echo -e "${RED}\n✗ Domain tidak ditemukan!\n${NC}"
        sleep 2
        main_menu
        return
    fi
    
    echo ""
    echo -e "${YELLOW}⏳ Membuat subdomain node...${NC}"
    
    result_node=$(create_subdomain "node" "$ip" "$selected_domain")
    
    echo -e "${YELLOW}⏳ Membuat subdomain utama...${NC}"
    
    result_main=$(create_subdomain "$host" "$ip" "$selected_domain")
    
    echo ""
    echo -e "${GREEN}╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║       SUBDOMAIN + NODE BERHASIL DIBUAT              ║${NC}"
    echo -e "${GREEN}╚═════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [[ "$result_node" == SUCCESS* ]]; then
        IFS='|' read -r status subdomain vps_ip <<< "$result_node"
        echo -e "  ${GREEN}✅ Sukses membuat Subdomain!${NC}"
        echo ""
        echo -e "  🌐 sᴜʙᴅᴏᴍᴀɪɴ: ${YELLOW}$subdomain${NC}"
        echo -e "  📌 ɪᴘ ᴠᴘs: ${YELLOW}$vps_ip${NC}"
        echo ""
    else
        IFS='|' read -r status error <<< "$result_node"
        echo -e "  ${RED}✗ Error Node: $error${NC}"
        echo ""
    fi
    
    if [[ "$result_main" == SUCCESS* ]]; then
        IFS='|' read -r status subdomain vps_ip <<< "$result_main"
        echo -e "  ${GREEN}✅ Sukses membuat Subdomain!${NC}"
        echo ""
        echo -e "  🌐 sᴜʙᴅᴏᴍᴀɪɴ: ${YELLOW}$subdomain${NC}"
        echo -e "  📌 ɪᴘ ᴠᴘs: ${YELLOW}$vps_ip${NC}"
        echo ""
    else
        IFS='|' read -r status error <<< "$result_main"
        echo -e "  ${RED}✗ Error Main: $error${NC}"
        echo ""
    fi
    
    echo -e "${GREEN}╚═════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e -n "${YELLOW}Tekan Enter untuk kembali...${NC}"
    read
    main_menu
}

check_password
main_menu
