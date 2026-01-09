#!/bin/bash

BOLD='\033[1m'
RESET='\033[0m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'

check_dependencies() {
    if ! command -v sshpass &> /dev/null; then
        echo -e "${YELLOW}Installing sshpass...${RESET}"
        if command -v apt &> /dev/null; then
            apt update && apt install -y sshpass
        elif command -v yum &> /dev/null; then
            yum install -y sshpass
        elif command -v brew &> /dev/null; then
            brew install hudochenkov/sshpass/sshpass
        else
            echo -e "${RED}Cannot install sshpass automatically${RESET}"
            exit 1
        fi
    fi
}

clear
check_dependencies

echo -e "${CYAN}"
cat << "EOF"
     _ _                ___           _        _ _           
    | (_| __ _ _ __    |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
 _  | | |/ _` | '_ \    | || '_ \/ __| __/ _` | | |/ _ \ '__|
| |_| | | (_| | | | |   | || | | \__ \ || (_| | | |  __/ |   
 \___/|_|\__,_|_| |_|  |___|_| |_|___/\__\__,_|_|_|\___|_|   
                                                              
EOF
echo -e "${RESET}"

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
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

show_menu() {
    echo -e "${BOLD}Select Option:${RESET}\n"
    echo -e "${CYAN}[1]${RESET} Install Panel"
    echo -e "${CYAN}[2]${RESET} Start Wings"
    echo -e "${CYAN}[3]${RESET} Uninstall Panel"
    echo -e "${CYAN}[4]${RESET} Fix Node Status (Red/Yellow)"
    echo -e "${CYAN}[0]${RESET} Exit\n"
    read -p "Choice: " choice
    echo
}

install_panel() {
    echo -e "${BOLD}Panel Installation${RESET}\n"

    read -p "VPS IP: " vps_ip
    read -sp "Password: " vps_pass
    echo
    read -p "Panel Domain: " panel_domain
    read -p "Node Domain: " node_domain
    read -p "RAM (MB): " ram_mb

    echo -e "\n${CYAN}Starting installation...${RESET}\n"
    sleep 1

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
    
    location / { 
        try_files \$uri \$uri/ /index.php?\$query_string; 
    }
    
    location ~ \\.php\$ {
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
    
    location ~ /\\.ht {
        deny all;
    }
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

    echo -e "\n${GREEN}${BOLD}Installation Complete!${RESET}\n"
    echo -e "${CYAN}┌─────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}│${RESET}  ${BOLD}Panel Credentials${RESET}                ${CYAN}│${RESET}"
    echo -e "${CYAN}├─────────────────────────────────────┤${RESET}"
    echo -e "${CYAN}│${RESET}  URL      : https://$panel_domain"
    echo -e "${CYAN}│${RESET}  Username : admin"
    echo -e "${CYAN}│${RESET}  Password : $admin_pass"
    echo -e "${CYAN}├─────────────────────────────────────┤${RESET}"
    echo -e "${CYAN}│${RESET}  Node Domain: $node_domain"
    echo -e "${CYAN}│${RESET}  VPS RAM   : ${ram_mb}MB"
    echo -e "${CYAN}└─────────────────────────────────────┘${RESET}"
    echo -e "\n${YELLOW}Next steps:${RESET}"
    echo -e "1. Login to panel"
    echo -e "2. Create Location & Node"
    echo -e "3. Copy configuration command"
    echo -e "4. Use option [2] Start Wings\n"
}

start_wings() {
    echo -e "${BOLD}Start Wings${RESET}\n"

    read -p "VPS IP: " vps_ip
    read -sp "Password: " vps_pass
    echo
    echo -e "\nPaste your full configuration command from panel:"
    echo -e "${YELLOW}(Get from: Admin → Nodes → Configuration tab)${RESET}"
    echo -e "${YELLOW}Example: cd /etc/pterodactyl && sudo wings configure --panel-url...${RESET}\n"
    read -p "Command: " config_cmd

    echo -e "\n${CYAN}Starting Wings...${RESET}\n"

    run_step "Connecting to VPS" "sshpass -p '$vps_pass' ssh -o StrictHostKeyChecking=no root@$vps_ip 'echo connected'"

    run_step "Stopping Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl stop wings 2>/dev/null || true'"

    run_step "Backing up old config" "sshpass -p '$vps_pass' ssh root@$vps_ip 'mv /etc/pterodactyl/config.yml /etc/pterodactyl/config.yml.backup 2>/dev/null || true'"

    run_step "Running configuration" "sshpass -p '$vps_pass' ssh root@$vps_ip 'echo y | $config_cmd'"

    run_step "Fixing permissions" "sshpass -p '$vps_pass' ssh root@$vps_ip 'chown -R root:root /etc/pterodactyl && chmod -R 755 /etc/pterodactyl'"

    run_step "Restarting Docker" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart docker && sleep 3'"

    run_step "Starting Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart wings && sleep 5'"

    run_step "Verifying Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl is-active wings'"

    echo -e "\n${GREEN}${BOLD}Wings Started Successfully!${RESET}\n"
    echo -e "${CYAN}┌─────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}│${RESET}  ${BOLD}Wings Status${RESET}                     ${CYAN}│${RESET}"
    echo -e "${CYAN}├─────────────────────────────────────┤${RESET}"
    echo -e "${CYAN}│${RESET}  Status: ${GREEN}Running${RESET}"
    echo -e "${CYAN}│${RESET}  VPS IP: $vps_ip"
    echo -e "${CYAN}│${RESET}  Port  : 8080"
    echo -e "${CYAN}└─────────────────────────────────────┘${RESET}"
    echo -e "\n${YELLOW}Useful commands:${RESET}"
    echo -e "Check status: systemctl status wings"
    echo -e "View logs   : journalctl -u wings -f"
    echo -e "Restart     : systemctl restart wings\n"
    echo -e "${GREEN}Node should now appear online in panel!${RESET}\n"
}

fix_node_status() {
    echo -e "${BOLD}Fix Node Status (Red/Yellow)${RESET}\n"

    read -p "VPS IP: " vps_ip
    read -sp "Password: " vps_pass
    echo
    read -p "Panel Domain: " panel_domain
    read -p "Node Domain: " node_domain

    echo -e "\n${CYAN}Fixing node status...${RESET}\n"

    run_step "Connecting to VPS" "sshpass -p '$vps_pass' ssh -o StrictHostKeyChecking=no root@$vps_ip 'echo connected'"

    run_step "Stopping Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl stop wings'"

    run_step "Clearing cache" "sshpass -p '$vps_pass' ssh root@$vps_ip 'cd /var/www/pterodactyl && php artisan config:clear && php artisan cache:clear && php artisan view:clear'"

    run_step "Fixing SSL certificates" "sshpass -p '$vps_pass' ssh root@$vps_ip 'certbot certonly --nginx -d $node_domain --non-interactive --agree-tos --email admin@$panel_domain --force-renewal'"

    run_step "Updating Wings config SSL" "sshpass -p '$vps_pass' ssh root@$vps_ip \"sed -i 's|enabled: false|enabled: true|g' /etc/pterodactyl/config.yml && sed -i 's|cert: .*|cert: /etc/letsencrypt/live/$node_domain/fullchain.pem|g' /etc/pterodactyl/config.yml && sed -i 's|key: .*|key: /etc/letsencrypt/live/$node_domain/privkey.pem|g' /etc/pterodactyl/config.yml\""

    run_step "Fixing remote URL" "sshpass -p '$vps_pass' ssh root@$vps_ip \"sed -i 's|remote: .*|remote: https://$panel_domain|g' /etc/pterodactyl/config.yml\""

    run_step "Opening firewall ports" "sshpass -p '$vps_pass' ssh root@$vps_ip 'ufw allow 8080/tcp && ufw allow 2022/tcp'"

    run_step "Restarting Docker" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart docker && sleep 3'"

    run_step "Restarting Redis" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart redis-server'"

    run_step "Restarting queue" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart pteroq'"

    run_step "Starting Wings" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl restart wings && sleep 8'"

    run_step "Testing Wings SSL" "sshpass -p '$vps_pass' ssh root@$vps_ip 'curl -k https://localhost:8080 > /dev/null 2>&1'"

    run_step "Verifying connection" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl is-active wings && journalctl -u wings --no-pager -n 20 | grep -q \"authenticated\"'"

    run_step "Clearing panel cache" "sshpass -p '$vps_pass' ssh root@$vps_ip 'cd /var/www/pterodactyl && php artisan queue:restart'"

    echo -e "\n${GREEN}${BOLD}Node Status Fixed!${RESET}\n"
    echo -e "${CYAN}┌─────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}│${RESET}  ${BOLD}Fix Status${RESET}                       ${CYAN}│${RESET}"
    echo -e "${CYAN}├─────────────────────────────────────┤${RESET}"
    echo -e "${CYAN}│${RESET}  Panel : https://$panel_domain"
    echo -e "${CYAN}│${RESET}  Node  : https://$node_domain:8080"
    echo -e "${CYAN}│${RESET}  Status: ${GREEN}Online${RESET}"
    echo -e "${CYAN}└─────────────────────────────────────┘${RESET}"
    echo -e "\n${YELLOW}Please refresh your panel page!${RESET}\n"
    echo -e "${GREEN}Node should now be GREEN in panel${RESET}\n"
}

uninstall_panel() {
    echo -e "${BOLD}Uninstall Panel${RESET}\n"

    read -p "VPS IP: " vps_ip
    read -sp "Password: " vps_pass
    echo
    echo -e "\n${RED}${BOLD}WARNING!${RESET}"
    echo -e "This will remove ALL panel data including:"
    echo -e "• Pterodactyl Panel & Wings"
    echo -e "• Docker & all containers"
    echo -e "• All databases"
    echo -e "• All configurations\n"
    read -p "Type 'yes' to confirm: " confirm

    if [ "$confirm" != "yes" ]; then
        echo -e "${YELLOW}Uninstall cancelled${RESET}\n"
        return
    fi

    echo -e "\n${CYAN}Starting uninstallation...${RESET}\n"

    run_step "Connecting to VPS" "sshpass -p '$vps_pass' ssh -o StrictHostKeyChecking=no root@$vps_ip 'echo connected'"

    run_step "Stopping services" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl stop wings pteroq nginx php8.2-fpm mariadb redis-server docker 2>/dev/null || true'"

    run_step "Disabling services" "sshpass -p '$vps_pass' ssh root@$vps_ip 'systemctl disable wings pteroq nginx mariadb docker 2>/dev/null || true'"

    run_step "Removing Docker containers" "sshpass -p '$vps_pass' ssh root@$vps_ip 'docker stop \$(docker ps -aq) 2>/dev/null || true && docker rm \$(docker ps -aq) 2>/dev/null || true && docker rmi \$(docker images -q) 2>/dev/null || true && docker volume rm \$(docker volume ls -q) 2>/dev/null || true'"

    run_step "Removing Panel files" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -rf /var/www/pterodactyl /etc/pterodactyl /usr/local/bin/wings /var/lib/pterodactyl /var/log/pterodactyl'"

    run_step "Removing services" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -f /etc/systemd/system/wings.service /etc/systemd/system/pteroq.service && systemctl daemon-reload'"

    run_step "Removing Nginx config" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -f /etc/nginx/sites-enabled/pterodactyl.conf /etc/nginx/sites-available/pterodactyl.conf'"

    run_step "Removing SSL certs" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -rf /etc/letsencrypt'"

    run_step "Dropping databases" "sshpass -p '$vps_pass' ssh root@$vps_ip \"mysql -u root -e 'DROP DATABASE IF EXISTS panel; DROP USER IF EXISTS pterodactyl@localhost; DROP USER IF EXISTS admin@localhost; FLUSH PRIVILEGES;' 2>/dev/null || true\""

    run_step "Removing cron jobs" "sshpass -p '$vps_pass' ssh root@$vps_ip \"crontab -l | grep -v pterodactyl | crontab - 2>/dev/null || true\""

    run_step "Purging packages" "sshpass -p '$vps_pass' ssh root@$vps_ip 'apt purge -y docker-ce docker-ce-cli containerd.io nginx php8.2* mariadb-server redis-server certbot 2>/dev/null || true'"

    run_step "Cleaning up" "sshpass -p '$vps_pass' ssh root@$vps_ip 'apt autoremove -y && apt autoclean -y && apt clean'"

    run_step "Removing swap" "sshpass -p '$vps_pass' ssh root@$vps_ip \"swapoff /swapfile 2>/dev/null || true && rm -f /swapfile && sed -i '/\\/swapfile/d' /etc/fstab\""

    run_step "Final cleanup" "sshpass -p '$vps_pass' ssh root@$vps_ip 'rm -rf /var/lib/docker /var/lib/containerd /etc/docker /root/.composer /root/.cache'"

    echo -e "\n${GREEN}${BOLD}Uninstall Complete!${RESET}\n"
    echo -e "${CYAN}┌─────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}│${RESET}  ${BOLD}Cleanup Status${RESET}                   ${CYAN}│${RESET}"
    echo -e "${CYAN}├─────────────────────────────────────┤${RESET}"
    echo -e "${CYAN}│${RESET}  VPS IP: $vps_ip"
    echo -e "${CYAN}│${RESET}  Status: ${GREEN}Clean${RESET}"
    echo -e "${CYAN}└─────────────────────────────────────┘${RESET}"
    echo -e "\nYour VPS is now clean!\n"
}

while true; do
    show_menu
    case $choice in
        1)
            install_panel
            ;;
        2)
            start_wings
            ;;
        3)
            uninstall_panel
            ;;
        4)
            fix_node_status
            ;;
        0)
            echo -e "${GREEN}Bye!${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${RESET}\n"
            ;;
    esac
    
    echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
    read
    clear
    echo -e "${CYAN}"
    cat << "EOF"
     _ _                ___           _        _ _           
    | (_| __ _ _ __    |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
 _  | | |/ _` | '_ \    | || '_ \/ __| __/ _` | | |/ _ \ '__|
| |_| | | (_| | | | |   | || | | \__ \ || (_| | | |  __/ |   
 \___/|_|\__,_|_| |_|  |___|_| |_|___/\__\__,_|_|_|\___|_|   
                                                              
EOF
    echo -e "${RESET}"
done

rm -f /tmp/install.log
