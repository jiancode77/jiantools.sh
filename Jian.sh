#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

PASSWORD=$(echo "SmlhbkNvZGUjMzEy" | base64 -d)

PANEL_URL=""
API_KEY=""

show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║   ███████╗██╗   ██╗██████╗ ██████╗  ██████╗                ║"
    echo "║   ██╔════╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗               ║"
    echo "║   ███████╗██║   ██║██████╔╝██║  ██║██║   ██║               ║"
    echo "║   ╚════██║██║   ██║██╔══██╗██║  ██║██║   ██║               ║"
    echo "║   ███████║╚██████╔╝██████╔╝██████╔╝╚██████╔╝               ║"
    echo "║   ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝  ╚═════╝                ║"
    echo "║                                                              ║"
    echo "║           SUBDOMAIN & PTERODACTYL CREATOR V2.0               ║"
    echo "║                  Created By VinnOfficial                     ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

list_domains() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║            DAFTAR DOMAIN TERSEDIA                 ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}  01.${NC} pterodactyl-panel.web.id"
    echo -e "${YELLOW}  02.${NC} storedigital.web.id"
    echo -e "${YELLOW}  03.${NC} storeid.my.id"
    echo -e "${YELLOW}  04.${NC} store-panell.my.id"
    echo -e "${YELLOW}  05.${NC} xyro.web.id"
    echo -e "${YELLOW}  06.${NC} xyroku.my.id"
    echo -e "${YELLOW}  07.${NC} gacorr.biz.id"
    echo -e "${YELLOW}  08.${NC} cafee.my.id"
    echo -e "${YELLOW}  09.${NC} pterodaytl.my.id"
    echo -e "${YELLOW}  10.${NC} googlex.my.id"
    echo -e "${YELLOW}  11.${NC} heavencraft.my.id"
    echo -e "${YELLOW}  12.${NC} hilman-store.web.id"
    echo -e "${YELLOW}  13.${NC} hilmanofficial.tech"
    echo -e "${YELLOW}  14.${NC} hilmanzoffc.web.id"
    echo -e "${YELLOW}  15.${NC} host-panel.web.id"
    echo -e "${YELLOW}  16.${NC} hostingers-vvip.my.id"
    echo ""
}

get_domain_config() {
    case $1 in
        1) DOMAIN="pterodactyl-panel.web.id"; ZONE="d69feb7345d9e4dd5cfd7cce29e7d5b0"; TOKEN="32zZwadzwc7qB4mzuDBJkk1xFyoQ2Grr27mAfJcB" ;;
        2) DOMAIN="storedigital.web.id"; ZONE="2ce8a2f880534806e2f463e3eec68d31"; TOKEN="v5_unJTqruXV_x-5uj0dT5_Q4QAPThJbXzC2MmOQ" ;;
        3) DOMAIN="storeid.my.id"; ZONE="c651c828a01962eb3c530513c7ad7dcf"; TOKEN="N-D6fN6la7jY0AnvbWn9FcU6ZHuDitmFXd-JF04g" ;;
        4) DOMAIN="store-panell.my.id"; ZONE="0189ecfadb9cf2c4a311c0a3ec8f0d5c"; TOKEN="eVI-BXIXNEQtBqLpdvuitAR5nXC2bLj6jw365JPZ" ;;
        5) DOMAIN="xyro.web.id"; ZONE="46d0cd33a7966f0be5afdab04b63e695"; TOKEN="CygwSHXRSfZnsi1qZmyB8s4qHC12jX_RR4mTpm62" ;;
        6) DOMAIN="xyroku.my.id"; ZONE="f6d1a73a272e6e770a232c39979d5139"; TOKEN="0Mae_Rtx1ixGYenzFcNG9bbPd-rWjoRwqN2tvNzo" ;;
        7) DOMAIN="gacorr.biz.id"; ZONE="cff22ce1965394f1992c8dba4c3db539"; TOKEN="v9kYfj5g2lcacvBaJHA_HRgNqBi9UlsVy0cm_EhT" ;;
        8) DOMAIN="cafee.my.id"; ZONE="0d7044fc3e0d66189724952fa3b850ce"; TOKEN="wAOEzAfvb-L3vKYE2Xg8svJpHfNS_u2noWSReSzJ" ;;
        9) DOMAIN="pterodaytl.my.id"; ZONE="828ef14600aaaa0b1ea881dd0e7972b2"; TOKEN="75HrVBzSVObD611RkuNS1ZKsL5A_b8kuiCs26-f9" ;;
        10) DOMAIN="googlex.my.id"; ZONE="dda9e25dac2556c7494470ee6152fc7f"; TOKEN="GuT5rNQSr_V2kxb-QZdJ4YbFlEvzE-upzhey9Ezl" ;;
        11) DOMAIN="heavencraft.my.id"; ZONE="9e7239dcda7cbd6be79d7615257f56f8"; TOKEN="aHvYYKk7YIADVOfpG3i1eaIqTeWCdPS25FAPreDQ" ;;
        12) DOMAIN="hilman-store.web.id"; ZONE="4e214dfe36faa7c942bc68b5aecdd1e9"; TOKEN="wpQCANKLRAtWb0XvTRed3vwSkOMMWKO2C75uwnKE" ;;
        13) DOMAIN="hilmanofficial.tech"; ZONE="c8705bfbfdca9c4e8e61eb2663ee87d6"; TOKEN="hjqWa_eFAfoJNJyBu9WAlg8WO0ICtN5AYpZURgqe" ;;
        14) DOMAIN="hilmanzoffc.web.id"; ZONE="2627badfda28951bfb936fce0febc5b0"; TOKEN="wZ3QAKn7zDx-tyb04HgCvmogqeM6je8jDNmiPZXq" ;;
        15) DOMAIN="host-panel.web.id"; ZONE="74b3192f7c3b0925cdb8606bb7db95c4"; TOKEN="GuT5rNQSr_V2kxb-QZdJ4YbFlEvzE-upzhey9Ezl" ;;
        16) DOMAIN="hostingers-vvip.my.id"; ZONE="2341ae01634b852230b7521af26c261f"; TOKEN="Ztw1ouD8_lJf-QzRecgmijjsDJODFU4b-y697lPw" ;;
        *) return 1 ;;
    esac
    return 0
}

create_subdomain() {
    local HOST=$1
    local IP=$2
    local ZONE=$3
    local TOKEN=$4
    local DOMAIN=$5
    
    RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"$HOST\",\"content\":\"$IP\",\"ttl\":1,\"proxied\":false}")
    
    if echo "$RESPONSE" | grep -q '"success":true'; then
        echo "success|$HOST.$DOMAIN|$IP"
    else
        ERROR=$(echo "$RESPONSE" | grep -o '"message":"[^"]*"' | head -1 | cut -d'"' -f4)
        echo "error|$ERROR"
    fi
}

create_location() {
    local NAME=$1
    local SHORT=$(echo "$NAME" | cut -c1-8 | tr '[:lower:]' '[:upper:]')
    
    RESPONSE=$(curl -s -X POST "$PANEL_URL/api/application/locations" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        --data "{\"short\":\"$SHORT\",\"long\":\"$NAME\"}")
    
    if echo "$RESPONSE" | grep -q '"object":"location"'; then
        LOCATION_ID=$(echo "$RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
        echo "success|$LOCATION_ID"
    else
        ERROR=$(echo "$RESPONSE" | grep -o '"detail":"[^"]*"' | head -1 | cut -d'"' -f4)
        echo "error|$ERROR"
    fi
}

create_node() {
    local NODE_NAME=$1
    local FQDN=$2
    local RAM=$3
    local DISK=$4
    local LOCATION_ID=$5
    
    RESPONSE=$(curl -s -X POST "$PANEL_URL/api/application/nodes" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        --data "{
            \"name\":\"$NODE_NAME\",
            \"description\":\"Auto created node for $NODE_NAME\",
            \"location_id\":$LOCATION_ID,
            \"fqdn\":\"$FQDN\",
            \"scheme\":\"https\",
            \"memory\":$RAM,
            \"memory_overallocate\":0,
            \"disk\":$DISK,
            \"disk_overallocate\":0,
            \"upload_size\":100,
            \"daemon_sftp\":2022,
            \"daemon_listen\":8080
        }")
    
    if echo "$RESPONSE" | grep -q '"object":"node"'; then
        NODE_ID=$(echo "$RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
        echo "success|$NODE_ID"
    else
        ERROR=$(echo "$RESPONSE" | grep -o '"detail":"[^"]*"' | head -1 | cut -d'"' -f4)
        echo "error|$ERROR"
    fi
}

setup_pterodactyl() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║          SETUP PTERODACTYL CONFIGURATION          ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    read -p "  Panel URL (https://panel.example.com): " PANEL_URL
    read -p "  API Key: " API_KEY
    
    PANEL_URL=$(echo "$PANEL_URL" | sed 's:/*$::')
    
    echo -e "${GREEN}\n✓ Konfigurasi Pterodactyl berhasil disimpan!${NC}\n"
    read -p "Tekan Enter untuk kembali..."
}

auto_pterodactyl_mode() {
    if [ -z "$PANEL_URL" ] || [ -z "$API_KEY" ]; then
        echo -e "${RED}\n✗ Konfigurasi Pterodactyl belum diatur!${NC}\n"
        setup_pterodactyl
        return
    fi
    
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║        AUTO CREATE SUBDOMAIN + NODE MODE          ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    read -p "  Node Name: " NODE_NAME
    read -p "  Hostname (untuk subdomain): " HOST
    read -p "  IP VPS: " IP
    read -p "  RAM (MB): " RAM
    read -p "  Disk (MB): " DISK
    
    list_domains
    read -p "  Pilih nomor domain: " DOMAIN_CHOICE
    
    get_domain_config $DOMAIN_CHOICE
    if [ $? -ne 0 ]; then
        echo -e "${RED}\n✗ Domain tidak ditemukan!${NC}\n"
        read -p "Tekan Enter untuk kembali..."
        return
    fi
    
    echo ""
    echo -e "${YELLOW}⏳ Membuat subdomain...${NC}"
    SUBDOMAIN_RESULT=$(create_subdomain "$HOST" "$IP" "$ZONE" "$TOKEN" "$DOMAIN")
    
    if echo "$SUBDOMAIN_RESULT" | grep -q "^success"; then
        FULL_DOMAIN=$(echo "$SUBDOMAIN_RESULT" | cut -d'|' -f2)
        USED_IP=$(echo "$SUBDOMAIN_RESULT" | cut -d'|' -f3)
        echo -e "${GREEN}✓ Subdomain berhasil dibuat!${NC}"
    else
        ERROR=$(echo "$SUBDOMAIN_RESULT" | cut -d'|' -f2)
        echo -e "${RED}✗ Gagal membuat subdomain: $ERROR${NC}\n"
        read -p "Tekan Enter untuk kembali..."
        return
    fi
    
    echo -e "${YELLOW}⏳ Membuat location di Pterodactyl...${NC}"
    LOCATION_RESULT=$(create_location "$NODE_NAME")
    
    if echo "$LOCATION_RESULT" | grep -q "^success"; then
        LOCATION_ID=$(echo "$LOCATION_RESULT" | cut -d'|' -f2)
        echo -e "${GREEN}✓ Location berhasil dibuat!${NC}"
    else
        ERROR=$(echo "$LOCATION_RESULT" | cut -d'|' -f2)
        echo -e "${RED}✗ Gagal membuat location: $ERROR${NC}\n"
        read -p "Tekan Enter untuk kembali..."
        return
    fi
    
    echo -e "${YELLOW}⏳ Membuat node di Pterodactyl...${NC}"
    NODE_RESULT=$(create_node "$NODE_NAME" "$FULL_DOMAIN" "$RAM" "$DISK" "$LOCATION_ID")
    
    if echo "$NODE_RESULT" | grep -q "^success"; then
        NODE_ID=$(echo "$NODE_RESULT" | cut -d'|' -f2)
        echo -e "${GREEN}✓ Node berhasil dibuat!${NC}"
        
        echo -e "${GREEN}"
        echo "╔═══════════════════════════════════════════════════════════╗"
        echo "║           PTERODACTYL NODE BERHASIL DIBUAT                ║"
        echo "╚═══════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo -e "  🏷️  Node Name   : ${YELLOW}$NODE_NAME${NC}"
        echo -e "  🌐 Subdomain   : ${YELLOW}$FULL_DOMAIN${NC}"
        echo -e "  📌 IP VPS      : ${YELLOW}$USED_IP${NC}"
        echo -e "  💾 RAM         : ${YELLOW}$RAM MB${NC}"
        echo -e "  💿 Disk        : ${YELLOW}$DISK MB${NC}"
        echo -e "  🔑 Location ID : ${YELLOW}$LOCATION_ID${NC}"
        echo -e "  🆔 Node ID     : ${YELLOW}$NODE_ID${NC}"
        echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}\n"
    else
        ERROR=$(echo "$NODE_RESULT" | cut -d'|' -f2)
        echo -e "${RED}✗ Gagal membuat node: $ERROR${NC}\n"
    fi
    
    read -p "Tekan Enter untuk kembali..."
}

create_subdomain_only() {
    read -p "Masukkan format (hostname|ip): " INPUT
    
    if [[ ! "$INPUT" =~ \| ]]; then
        echo -e "${RED}\n✗ Format salah! Gunakan: hostname|ip${NC}\n"
        read -p "Tekan Enter untuk kembali..."
        return
    fi
    
    HOST=$(echo "$INPUT" | cut -d'|' -f1 | xargs)
    IP=$(echo "$INPUT" | cut -d'|' -f2 | xargs)
    
    list_domains
    read -p "  Pilih nomor domain: " DOMAIN_CHOICE
    
    get_domain_config $DOMAIN_CHOICE
    if [ $? -ne 0 ]; then
        echo -e "${RED}\n✗ Domain tidak ditemukan!${NC}\n"
        read -p "Tekan Enter untuk kembali..."
        return
    fi
    
    echo ""
    echo -e "${YELLOW}⏳ Membuat subdomain...${NC}"
    RESULT=$(create_subdomain "$HOST" "$IP" "$ZONE" "$TOKEN" "$DOMAIN")
    
    if echo "$RESULT" | grep -q "^success"; then
        FULL_DOMAIN=$(echo "$RESULT" | cut -d'|' -f2)
        USED_IP=$(echo "$RESULT" | cut -d'|' -f3)
        echo -e "${GREEN}✓ Proses selesai!${NC}"
        
        echo -e "${GREEN}"
        echo "╔═══════════════════════════════════════════════════╗"
        echo "║        SUBDOMAIN BERHASIL DIBUAT                  ║"
        echo "╚═══════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo -e "  🌐 Subdomain : ${YELLOW}$FULL_DOMAIN${NC}"
        echo -e "  📌 IP VPS    : ${YELLOW}$USED_IP${NC}"
        echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}\n"
    else
        ERROR=$(echo "$RESULT" | cut -d'|' -f2)
        echo -e "${RED}✗ Proses gagal!${NC}"
        echo -e "${RED}\n✗ Error: $ERROR${NC}\n"
    fi
    
    read -p "Tekan Enter untuk kembali..."
}

authenticate() {
    clear
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║                 AUTHENTICATION                    ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    read -sp "  Password: " INPUT_PASS
    echo ""
    
    if [ "$INPUT_PASS" == "$PASSWORD" ]; then
        echo -e "${GREEN}\n✓ Autentikasi berhasil!${NC}\n"
        sleep 1
        return 0
    else
        echo -e "${RED}\n✗ Password salah!${NC}\n"
        exit 1
    fi
}

main_menu() {
    while true; do
        show_banner
        
        echo -e "${MAGENTA}╔═══════════════════════════════════════════════════╗${NC}"
        echo -e "${MAGENTA}║                   MENU UTAMA                      ║${NC}"
        echo -e "${MAGENTA}╠═══════════════════════════════════════════════════╣${NC}"
        echo -e "║  1. Buat Subdomain                                ║"
        echo -e "║  2. Lihat Daftar Domain                           ║"
        echo -e "║  3. Setup Pterodactyl Config                      ║"
        echo -e "║  4. Auto Create Subdomain + Node (Pterodactyl)    ║"
        echo -e "║  5. Keluar                                        ║"
        echo -e "${MAGENTA}╚═══════════════════════════════════════════════════╝${NC}"
        echo ""
        
        read -p "Pilih menu (1-5): " CHOICE
        
        case $CHOICE in
            1) create_subdomain_only ;;
            2) list_domains; read -p "Tekan Enter untuk kembali..." ;;
            3) setup_pterodactyl ;;
            4) auto_pterodactyl_mode ;;
            5) echo -e "${CYAN}\n👋 Terima kasih telah menggunakan Subdomain Creator!\n${NC}"; exit 0 ;;
            *) echo -e "${RED}\n✗ Pilihan tidak valid!${NC}\n"; read -p "Tekan Enter untuk kembali..." ;;
        esac
    done
}

authenticate
main_menu
