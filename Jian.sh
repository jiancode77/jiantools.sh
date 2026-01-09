#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'
NC='\033[0m'

PASSWORD=$(echo "SmlhbkNvZGUjMzEy" | base64 -d)

check_dependencies() {
    if ! command -v sshpass &> /dev/null; then
        echo -e "${YELLOW}Installing sshpass...${RESET}"
        if command -v apt &> /dev/null; then
            apt update && apt install -y sshpass bc
        elif command -v yum &> /dev/null; then
            yum install -y sshpass bc
        elif command -v brew &> /dev/null; then
            brew install hudochenkov/sshpass/sshpass bc
        else
            echo -e "${RED}Cannot install sshpass automatically${RESET}"
            exit 1
        fi
    fi
}

show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
     _ _                ___           _        _ _           
    | (_) __ _ _ __    |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
 _  | | |/ _` | '_ \    | || '_ \/ __| __/ _` | | |/ _ \ '__|
| |_| | | (_| | | | |   | || | | \__ \ || (_| | | |  __/ |   
 \___/|_|\__,_|_| |_|  |___|_| |_|___/\__\__,_|_|_|\___|_|   
                                                              
EOF
    echo -e "${NC}"
}

loading_bar() {
    local duration=$1
    local message=$2
    local bar_length=50
    
    echo -ne "${YELLOW}${message}${NC} ["
    
    for ((i=0; i<=bar_length; i++)); do
        local percent=$((i * 100 / bar_length))
        local filled=$((i))
        local empty=$((bar_length - i))
        
        printf "\r${YELLOW}${message}${NC} ["
        printf "${GREEN}%${filled}s" | tr ' ' '█'
        printf "${NC}%${empty}s" | tr ' ' '░'
        printf "] ${CYAN}%d%%${NC}" $percent
        
        sleep $(echo "scale=3; $duration / $bar_length" | bc)
    done
    echo ""
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " ${YELLOW}[%c]${NC}  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

run_step() {
    local msg=$1
    local cmd=$2
    
    echo -ne "${YELLOW}→${RESET} $msg "
    eval "$cmd" > /tmp/install.log 2>&1 &
    spinner $!
    wait $!
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${RESET}"
    else
        echo -e "${RED}✗${RESET}"
        cat /tmp/install.log
        exit 1
    fi
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

authenticate() {
    show_banner
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                     AUTHENTICATION                          │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    read -sp "  Password: " INPUT_PASS
    echo ""
    
    if [ "$INPUT_PASS" == "$PASSWORD" ]; then
        echo -e "${GREEN}\n✓ Autentikasi berhasil!${NC}"
        loading_bar 1 "Loading system"
        return 0
    else
        echo -e "${RED}\n✗ Password salah!${NC}\n"
        exit 1
    fi
}

list_domains() {
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                  DAFTAR DOMAIN TERSEDIA                     │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
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

show_menu() {
    show_banner
    echo -e "${MAGENTA}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${MAGENTA}│                       MENU UTAMA                            │${NC}"
    echo -e "${MAGENTA}├─────────────────────────────────────────────────────────────┤${NC}"
    echo -e "│  1. Install Panel + Auto Create Subdomain                   │"
    echo -e "│  2. Start Wings                                             │"
    echo -e "│  3. Fix Node Status (Red/Yellow)                            │"
    echo -e "│  4. Uninstall Panel                                         │"
    echo -e "│  5. Lihat Daftar Domain                                     │"
    echo -e "│  0. Keluar                                                  │"
    echo -e "${MAGENTA}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    read -p "Pilih menu (0-5): " choice
    echo
}

install_panel() {
    show_banner
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│          INSTALL PANEL + AUTO CREATE SUBDOMAIN              │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    read -p "  VPS IP: " vps_ip
    read -sp "  Password: " vps_pass
    echo
    read -p "  Hostname (contoh: jiancode): " HOST
    
    list_domains
    read -p "  Pilih nomor domain: " DOMAIN_CHOICE
    
    get_domain_config $DOMAIN_CHOICE
    if [ $? -ne 0 ]; then
        echo -e "${RED}\n✗ Domain tidak ditemukan!${NC}\n"
        read -p "Tekan Enter untuk kembali..."
        return
    fi
    
    echo ""
    loading_bar 1.5 "⏳ Menyiapkan konfigurasi"
    
    echo -e "${YELLOW}⏳ Membuat subdomain node...${NC}"
    NODE_RESULT=$(create_subdomain "node.$HOST" "$vps_ip" "$ZONE" "$TOKEN" "$DOMAIN")
    
    if echo "$NODE_RESULT" | grep -q "^success"; then
        node_domain=$(echo "$NODE_RESULT" | cut -d'|' -f2)
        echo -e "${GREEN}✓ Subdomain node berhasil: $node_domain${NC}"
        loading_bar 1 "   Processing"
    else
        NODE_ERROR=$(echo "$NODE_RESULT" | cut -d'|' -f2)
        echo -e "${RED}✗ Gagal membuat subdomain node: $NODE_ERROR${NC}\n"
        read -p "Tekan Enter untuk kembali..."
        return
    fi
    
    echo -e "${YELLOW}⏳ Membuat subdomain panel...${NC}"
    PANEL_RESULT=$(create_subdomain "$HOST" "$vps_ip" "$ZONE" "$TOKEN" "$DOMAIN")
    
    if echo "$PANEL_RESULT" | grep -q "^success"; then
        panel_domain=$(echo "$PANEL_RESULT" | cut -d'|' -f2)
        echo -e "${GREEN}✓ Subdomain panel berhasil: $panel_domain${NC}"
        loading_bar 1 "   Processing"
    else
        PANEL_ERROR=$(echo "$PANEL_RESULT" | cut -d'|' -f2)
        echo -e "${RED}✗ Gagal membuat subdomain panel: $PANEL_ERROR${NC}\n"
        read -p "Tekan Enter untuk kembali..."
        return
    fi
    
    echo ""
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│                    PROSES INSTALASI PANEL                   │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    run_step "Connecting to VPS" "sshpass -p '$vps_pass' ssh -o StrictHostKeyChecking=no root@$vps_ip 'echo connected'"
    run_step "Updating system" "sshpass -p '$vps_pass' ssh root@$vps_ip 'apt update && apt upgrade -y'"
    run_step "Installing dependencies" "sshpass -p '$vps_pass' ssh root@$vps_ip 'apt install -y software-properties-common curl'"
    run_step "Adding PHP repo" "sshpass -p '$vps_pass' ssh root@$vps_ip 'LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && apt update'"
    run_step "Installing PHP 8.2" "sshpass -p '$vps_pass' ssh root@$vps_ip 'apt install -y php8.2 php8.2-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip}'"
    run_step "Installing MariaDB" "sshpass -p '$vps_pass' ssh root@$vps_ip 'curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash && apt install -y mariadb-server'"
    run_step "Installing Redis" "sshpass -p '$vps_pass' ssh root@$vps_ip 'apt install -y redis-server'"
    run_step "Starting services" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl start mariadb redis-server && systemctl enable mariadb redis-server'"

    db_pass="Ptero$(shuf -i 1000-9999 -n 1)"

    run_step "Creating database" "sshpass -p '$vps_pass' ssh root@$vps_ip \"mysql -u root <<MYSQL
DROP DATABASE IF EXISTS panel;
DROP USER IF EXISTS 'pterodactyl'@'localhost';
CREATE DATABASE panel;
CREATE USER 'pterodactyl'@'localhost' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'localhost';
FLUSH PRIVILEGES;
MYSQL\""

    run_step "Downloading Panel" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -rf /var/www/pterodactyl && mkdir -p /var/www/pterodactyl && cd /var/www/pterodactyl && curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz && tar -xzvf panel.tar.gz && chmod -R 755 storage/* bootstrap/cache/'"
    run_step "Installing Composer" "sshpass -p '$vps_pass' ssh root@$vps_ip 'curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer'"
    run_step "Installing dependencies" "sshpass -p '$vps_pass' ssh root@$vps_ip 'cd /var/www/pterodactyl && composer install --no-dev --optimize-autoloader'"
    run_step "Configuring environment" "sshpass -p '$vps_pass' ssh root@$vps_ip \"cd /var/www/pterodactyl && cp .env.example .env && php artisan key:generate --force && sed -i 's|APP_URL=.*|APP_URL=https://$panel_domain|' .env && sed -i 's|DB_DATABASE=.*|DB_DATABASE=panel|' .env && sed -i 's|DB_USERNAME=.*|DB_USERNAME=pterodactyl|' .env && sed -i 's|DB_PASSWORD=.*|DB_PASSWORD=$db_pass|' .env && sed -i 's|CACHE_DRIVER=.*|CACHE_DRIVER=redis|' .env && sed -i 's|SESSION_DRIVER=.*|SESSION_DRIVER=redis|' .env && sed -i 's|QUEUE_CONNECTION=.*|QUEUE_CONNECTION=redis|' .env\""
    run_step "Running migrations" "sshpass -p '$vps_pass' ssh root@$vps_ip 'cd /var/www/pterodactyl && php artisan migrate --seed --force'"

    admin_pass="admin$(shuf -i 1000-9999 -n 1)"

    run_step "Creating admin user" "sshpass -p '$vps_pass' ssh root@$vps_ip \"cd /var/www/pterodactyl && php artisan p:user:make --email=admin@panel.com --username=admin --name-first=Admin --name-last=User --password=$admin_pass --admin=1\""
    run_step "Setting permissions" "sshpass -p '$vps_pass' ssh root@$vps_ip 'chown -R www-data:www-data /var/www/pterodactyl/*'"
    run_step "Installing Nginx" "sshpass -p '$vps_pass' ssh root@$vps_ip 'apt install -y nginx'"
    run_step "Freeing port 80" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl stop apache2 2>/dev/null || true && apt remove -y apache2 2>/dev/null || true && fuser -k 80/tcp 2>/dev/null || true'"
    run_step "Configuring Nginx" "sshpass -p '$vps_pass' ssh root@$vps_ip 'cat > /etc/nginx/sites-available/pterodactyl.conf << \"ENDNGINX\"
server {
    listen 80;
    server_name $panel_domain;
    root /var/www/pterodactyl/public;
    index index.php;
    client_max_body_size 100m;
    client_body_timeout 120s;
    location / { try_files \$uri \$uri/ /index.php?\$query_string; }
    location ~ \\.php\$ {
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
    location ~ /\\.ht { deny all; }
}
ENDNGINX
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx'"

    run_step "Setting up queue" "sshpass -p '$vps_pass' ssh root@$vps_ip 'cat > /etc/systemd/system/pteroq.service << \"ENDSERVICE\"
[Unit]
Description=Pterodactyl Queue Worker
[Service]
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
[Install]
WantedBy=multi-user.target
ENDSERVICE
systemctl daemon-reload
systemctl enable --now pteroq'"

    run_step "Setting up cron" "sshpass -p '$vps_pass' ssh root@$vps_ip \"(crontab -l 2>/dev/null; echo '* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1') | crontab -\""
    run_step "Configuring firewall" "sshpass -p '$vps_pass' ssh root@$vps_ip 'ufw allow 22/tcp && ufw allow 80/tcp && ufw allow 443/tcp && ufw allow 8080/tcp && ufw allow 2022/tcp && ufw --force enable'"
    run_step "Installing SSL" "sshpass -p '$vps_pass' ssh root@$vps_ip \"apt install -y certbot python3-certbot-nginx && certbot --nginx -d $panel_domain --non-interactive --agree-tos --email admin@$panel_domain && certbot certonly --nginx -d $node_domain --non-interactive --agree-tos --email admin@$panel_domain\""
    run_step "Installing Docker" "sshpass -p '$vps_pass' ssh root@$vps_ip 'curl -sSL https://get.docker.com/ | CHANNEL=stable bash && systemctl enable --now docker'"
    run_step "Enabling swap" "sshpass -p '$vps_pass' ssh root@$vps_ip \"if [ ! -f /swapfile ]; then fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && echo '/swapfile none swap sw 0 0' >> /etc/fstab; fi\""
    run_step "Downloading Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'mkdir -p /etc/pterodactyl && curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64 && chmod u+x /usr/local/bin/wings'"
    run_step "Creating Wings service" "sshpass -p '$vps_pass' ssh root@$vps_ip 'cat > /etc/systemd/system/wings.service << \"ENDSERVICE\"
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service
[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
PIDFile=/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s
[Install]
WantedBy=multi-user.target
ENDSERVICE
systemctl daemon-reload
systemctl enable wings'"

    loading_bar 2 "⏳ Finalisasi konfigurasi"

    show_banner
    echo -e "${GREEN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GREEN}│              ✅ INSTALASI BERHASIL DISELESAIKAN              │${NC}"
    echo -e "${GREEN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${BLUE}📦 PANEL CREDENTIALS:${NC}"
    echo -e "${WHITE}   🌐 URL      : ${YELLOW}https://$panel_domain${NC}"
    echo -e "${WHITE}   👤 Username : ${YELLOW}admin${NC}"
    echo -e "${WHITE}   🔑 Password : ${YELLOW}$admin_pass${NC}"
    echo ""
    echo -e "${BLUE}📦 SUBDOMAIN NODE:${NC}"
    echo -e "${WHITE}   🌐 Domain   : ${YELLOW}$node_domain${NC}"
    echo -e "${WHITE}   📌 IP VPS   : ${YELLOW}$vps_ip${NC}"
    echo ""
    echo -e "${BLUE}📦 SUBDOMAIN PANEL:${NC}"
    echo -e "${WHITE}   🌐 Domain   : ${YELLOW}$panel_domain${NC}"
    echo -e "${WHITE}   📌 IP VPS   : ${YELLOW}$vps_ip${NC}"
    echo -e "${GREEN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "1. Login to panel"
    echo -e "2. Create Location & Node"
    echo -e "3. Copy configuration command"
    echo -e "4. Use menu [2] Start Wings"
    echo ""
    
    read -p "Tekan Enter untuk kembali..."
}

start_wings() {
    show_banner
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                       START WINGS                           │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    read -p "  VPS IP: " vps_ip
    read -sp "  Password: " vps_pass
    echo
    echo -e "\n${YELLOW}Paste your full configuration command from panel:${NC}"
    echo -e "${YELLOW}(Get from: Admin → Nodes → Configuration tab)${NC}"
    echo -e "${YELLOW}Example: cd /etc/pterodactyl && sudo wings configure --panel-url...${NC}\n"
    read -p "Command: " config_cmd

    echo ""
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│                    STARTING WINGS                           │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    run_step "Connecting to VPS" "sshpass -p '$vps_pass' ssh -o StrictHostKeyChecking=no root@$vps_ip 'echo connected'"
    run_step "Stopping Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl stop wings 2>/dev/null || true'"
    run_step "Killing port 8080" "sshpass -p '$vps_pass' ssh root@$vps_ip 'fuser -k 8080/tcp 2>/dev/null || true && pkill -9 node 2>/dev/null || true && pm2 stop all 2>/dev/null || true && pm2 delete all 2>/dev/null || true'"
    run_step "Backing up old config" "sshpass -p '$vps_pass' ssh root@$vps_ip 'mv /etc/pterodactyl/config.yml /etc/pterodactyl/config.yml.backup 2>/dev/null || true'"
    run_step "Running configuration" "sshpass -p '$vps_pass' ssh root@$vps_ip 'echo y | $config_cmd'"
    run_step "Fixing permissions" "sshpass -p '$vps_pass' ssh root@$vps_ip 'chown -R root:root /etc/pterodactyl && chmod -R 755 /etc/pterodactyl'"
    run_step "Restarting Docker" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart docker && sleep 3'"
    run_step "Starting Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart wings && sleep 15'"
    run_step "Verifying Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl is-active wings'"

    show_banner
    echo -e "${GREEN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GREEN}│              ✅ WINGS BERHASIL DIJALANKAN                    │${NC}"
    echo -e "${GREEN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${BLUE}📦 WINGS STATUS:${NC}"
    echo -e "${WHITE}   ⚡ Status   : ${GREEN}Running${NC}"
    echo -e "${WHITE}   📌 VPS IP   : ${YELLOW}$vps_ip${NC}"
    echo -e "${WHITE}   🔌 Port     : ${YELLOW}8080${NC}"
    echo ""
    echo -e "${YELLOW}Useful commands:${NC}"
    echo -e "  Check status: systemctl status wings"
    echo -e "  View logs   : journalctl -u wings -f"
    echo -e "  Restart     : systemctl restart wings"
    echo ""
    echo -e "${GREEN}Node should now appear online in panel!${NC}"
    echo ""
    
    read -p "Tekan Enter untuk kembali..."
}

fix_node_status() {
    show_banner
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│              FIX NODE STATUS (RED/YELLOW)                   │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    read -p "  VPS IP: " vps_ip
    read -sp "  Password: " vps_pass
    echo
    read -p "  Panel Domain: " panel_domain
    read -p "  Node Domain: " node_domain

    echo ""
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│                    FIXING NODE STATUS                       │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    run_step "Connecting to VPS" "sshpass -p '$vps_pass' ssh -o StrictHostKeyChecking=no root@$vps_ip 'echo connected'"
    run_step "Stopping Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl stop wings'"
    run_step "Killing port 8080" "sshpass -p '$vps_pass' ssh root@$vps_ip 'fuser -k 8080/tcp 2>/dev/null || true && pkill -9 node 2>/dev/null || true && pm2 stop all 2>/dev/null || true && pm2 delete all 2>/dev/null || true'"
    run_step "Clearing cache" "sshpass -p '$vps_pass' ssh root@$vps_ip 'cd /var/www/pterodactyl && php artisan config:clear && php artisan cache:clear && php artisan view:clear'"
    run_step "Fixing SSL certificates" "sshpass -p '$vps_pass' ssh root@$vps_ip 'certbot certonly --nginx -d $node_domain --non-interactive --agree-tos --email admin@$panel_domain --force-renewal'"
    run_step "Updating Wings config SSL" "sshpass -p '$vps_pass' ssh root@$vps_ip \"sed -i 's|enabled: false|enabled: true|g' /etc/pterodactyl/config.yml && sed -i 's|cert: .*|cert: /etc/letsencrypt/live/$node_domain/fullchain.pem|g' /etc/pterodactyl/config.yml && sed -i 's|key: .*|key: /etc/letsencrypt/live/$node_domain/privkey.pem|g' /etc/pterodactyl/config.yml\""
    run_step "Fixing remote URL" "sshpass -p '$vps_pass' ssh root@$vps_ip \"sed -i 's|remote: .*|remote: https://$panel_domain|g' /etc/pterodactyl/config.yml\""
    run_step "Opening firewall ports" "sshpass -p '$vps_pass' ssh root@$vps_ip 'ufw allow 8080/tcp && ufw allow 2022/tcp'"
    run_step "Restarting Docker" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart docker && sleep 3'"
    run_step "Restarting Redis" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart redis-server'"
    run_step "Restarting queue" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart pteroq'"
    run_step "Starting Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart wings && sleep 15'"
    run_step "Testing Wings SSL" "sshpass -p '$vps_pass' ssh root@$vps_ip 'curl -k https://localhost:8080 > /dev/null 2>&1'"
    run_step "Verifying connection" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl is-active wings'"
    run_step "Clearing panel cache" "sshpass -p '$vps_pass' ssh root@$vps_ip 'cd /var/www/pterodactyl && php artisan queue:restart'"

    show_banner
    echo -e "${GREEN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GREEN}│              ✅ NODE STATUS BERHASIL DIPERBAIKI              │${NC}"
    echo -e "${GREEN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${BLUE}📦 FIX RESULT:${NC}"
    echo -e "${WHITE}   🌐 Panel  : ${YELLOW}https://$panel_domain${NC}"
    echo -e "${WHITE}   🌐 Node   : ${YELLOW}https://$node_domain:8080${NC}"
    echo -e "${WHITE}   ⚡ Status : ${GREEN}Online${NC}"
    echo ""
    echo -e "${YELLOW}Please refresh your panel page!${NC}"
    echo -e "${GREEN}Node should now be GREEN in panel${NC}"
    echo ""
    
    read -p "Tekan Enter untuk kembali..."
}

uninstall_panel() {
    show_banner
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                    UNINSTALL PANEL                          │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    read -p "  VPS IP: " vps_ip
    read -sp "  Password: " vps_pass
    echo
    echo ""
    echo -e "${RED}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}│                        ⚠️ WARNING ⚠️                          │${NC}"
    echo -e "${RED}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "This will remove ALL panel data including:"
    echo -e "  • Pterodactyl Panel & Wings"
    echo -e "  • Docker & all containers"
    echo -e "  • All databases"
    echo -e "  • All configurations"
    echo ""
    read -p "Type 'yes' to confirm: " confirm

    if [ "$confirm" != "yes" ]; then
        echo -e "${YELLOW}\nUninstall cancelled${NC}\n"
        read -p "Tekan Enter untuk kembali..."
        return
    fi

    echo ""
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│                    UNINSTALLING PANEL                       │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    run_step "Connecting to VPS" "sshpass -p '$vps_pass' ssh -o StrictHostKeyChecking=no root@$vps_ip 'echo connected'"
    run_step "Stopping services" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl stop wings pteroq nginx php8.2-fpm mariadb redis-server docker 2>/dev/null || true'"
    run_step "Disabling services" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl disable wings pteroq nginx mariadb docker 2>/dev/null || true'"
    run_step "Removing Docker containers" "sshpass -p '$vps_pass' ssh root@$vps_ip 'docker stop \$(docker ps -aq) 2>/dev/null || true && docker rm \$(docker ps -aq) 2>/dev/null || true && docker rmi \$(docker images -q) 2>/dev/null || true && docker volume rm \$(docker volume ls -q) 2>/dev/null || true'"
    run_step "Removing Panel files" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -rf /var/www/pterodactyl /etc/pterodactyl /usr/local/bin/wings /var/lib/pterodactyl /var/log/pterodactyl'"
    run_step "Removing services" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -f /etc/systemd/system/wings.service /etc/systemd/system/pteroq.service && systemctl daemon-reload'"
    run_step "Removing Nginx config" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -f /etc/nginx/sites-enabled/pterodactyl.conf /etc/nginx/sites-available/pterodactyl.conf'"
    run_step "Removing SSL certs" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -rf /etc/letsencrypt'"
    run_step "Dropping databases" "sshpass -p '$vps_pass' ssh root@$vps_ip \"mysql -u root -e 'DROP DATABASE IF EXISTS panel; DROP USER IF EXISTS pterodactyl@localhost; FLUSH PRIVILEGES;' 2>/dev/null || true\""
    run_step "Removing cron jobs" "sshpass -p '$vps_pass' ssh root@$vps_ip \"crontab -l | grep -v pterodactyl | crontab - 2>/dev/null || true\""
    run_step "Purging packages" "sshpass -p '$vps_pass' ssh root@$vps_ip 'apt purge -y docker-ce docker-ce-cli containerd.io nginx php8.2* mariadb-server redis-server certbot 2>/dev/null || true'"
    run_step "Cleaning up" "sshpass -p '$vps_pass' ssh root@$vps_ip 'apt autoremove -y && apt autoclean -y && apt clean'"
    run_step "Removing swap" "sshpass -p '$vps_pass' ssh root@$vps_ip \"swapoff /swapfile 2>/dev/null || true && rm -f /swapfile && sed -i '/\\/swapfile/d' /etc/fstab\""
    run_step "Final cleanup" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -rf /var/lib/docker /var/lib/containerd /etc/docker /root/.composer /root/.cache'"

    show_banner
    echo -e "${GREEN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GREEN}│              ✅ UNINSTALL BERHASIL DISELESAIKAN              │${NC}"
    echo -e "${GREEN}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${BLUE}📦 CLEANUP STATUS:${NC}"
    echo -e "${WHITE}   📌 VPS IP : ${YELLOW}$vps_ip${NC}"
    echo -e "${WHITE}   ⚡ Status : ${GREEN}Clean${NC}"
    echo ""
    echo -e "${GREEN}Your VPS is now clean!${NC}"
    echo ""
    
    read -p "Tekan Enter untuk kembali..."
}

main_menu() {
    while true; do
        show_menu
        case $choice in
            1) install_panel ;;
            2) start_wings ;;
            3) fix_node_status ;;
            4) uninstall_panel ;;
            5) list_domains; echo ""; read -p "Tekan Enter untuk kembali..." ;;
            0) 
                show_banner
                echo -e "${GREEN}┌─────────────────────────────────────────────────────────────┐${NC}"
                echo -e "${GREEN}│                   👋 TERIMA KASIH!                           │${NC}"
                echo -e "${GREEN}│              Sampai jumpa lagi di lain waktu                │${NC}"
                echo -e "${GREEN}└─────────────────────────────────────────────────────────────┘${NC}"
                echo ""
                exit 0 
                ;;
            *) 
                echo -e "${RED}✗ Pilihan tidak valid!${NC}\n"
                read -p "Tekan Enter untuk kembali..." 
                ;;
        esac
    done
}

check_dependencies
authenticate
main_menu

rm -f /tmp/install.log
