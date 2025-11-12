#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
ORANGE='\033[38;5;208m'
MAGENTA='\033[38;5;165m'
TEAL='\033[38;5;51m'
NC='\033[0m'

spinner() {
    local pid=$1
    local delay=0.2
    local spinstr=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        for i in "${spinstr[@]}"; do
            printf " [%s] " "$i"
            sleep $delay
            printf "\b\b\b\b\b"
        done
    done
    printf "    \b\b\b\b"
}

animate_logo() {
    local frames=(
        "          _______  "
        "         /       / "
        "___     /   ____/   "
        ":   :  /   /:       "
        " :   :/___/  :      "
        "  :       :   :     "
        "   :_______:   :    JianTools v4.0"
        "           /   /    Owner:  JianCode"
        "          /   /     Premium: false"
        "          :  /      TELEGRAM @ JianCode"
        "           :/       "
    )
    
    while true; do
        clear
        echo -e "${CYAN}"
        for line in "${frames[@]}"; do
            echo "$line"
        done
        echo -e "${NC}"
        echo -e "${PURPLE}              JIAN TOOLS v4.0${NC}"
        echo
        break
    done
}

display_header() {
    animate_logo
    
    echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
    echo -e "${BLUE}│ ${GREEN}◉ ${WHITE}System: Ubuntu 22.04 LTS x86_64                          ${BLUE}│${NC}"
    echo -e "${BLUE}│ ${GREEN}◉ ${WHITE}CPU: AMD Ryzen 7 5800X (16) @ 3.800GHz                   ${BLUE}│${NC}"
    echo -e "${BLUE}│ ${GREEN}◉ ${WHITE}Memory: 15888MiB / 32061MiB                              ${BLUE}│${NC}"
    echo -e "${BLUE}│ ${GREEN}◉ ${WHITE}Uptime: 2 hours, 35 minutes                              ${BLUE}│${NC}"
    echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
    echo
}

show_tools() {
    echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
    echo -e "${PURPLE}│                    JIAN TOOLS SELECTION                   │${NC}"
    echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
    echo -e "${PURPLE}│ ${GREEN}1${PURPLE} │ ${CYAN}◈ NIK Checker ${PURPLE}    │ ${YELLOW}Check NIK Information              ${PURPLE}│${NC}"
    echo -e "${PURPLE}│ ${GREEN}2${PURPLE} │ ${CYAN}◈ NGL Spammer ${PURPLE}    │ ${YELLOW}Send Anonymous Messages           ${PURPLE}│${NC}"
    echo -e "${PURPLE}│ ${GREEN}3${PURPLE} │ ${CYAN}◈ GPT-4o ${PURPLE}         │ ${YELLOW}OpenAI Latest Model               ${PURPLE}│${NC}"
    echo -e "${PURPLE}│ ${GREEN}4${PURPLE} │ ${CYAN}◈ DeepSeek ${PURPLE}       │ ${YELLOW}DeepSeek Coder                    ${PURPLE}│${NC}"
    echo -e "${PURPLE}│ ${GREEN}5${PURPLE} │ ${CYAN}◈ Groq ${PURPLE}           │ ${YELLOW}Groq AI Model                     ${PURPLE}│${NC}"
    echo -e "${PURPLE}│ ${GREEN}6${PURPLE} │ ${CYAN}◈ Felo ${PURPLE}           │ ${YELLOW}Search Assistant                  ${PURPLE}│${NC}"
    echo -e "${PURPLE}│                                                        │${NC}"
    echo -e "${PURPLE}│ ${RED}0${PURPLE} │ ${RED}◉ Exit ${PURPLE}           │ ${RED}Exit Terminal                       ${PURPLE}│${NC}"
    echo -e "${PURPLE}│ ${RED}9${PURPLE} │ ${RED}◉ Clear ${PURPLE}          │ ${RED}Clear Screen                        ${PURPLE}│${NC}"
    echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
    echo
}

call_gpt4o() {
    local question=$1
    local encoded=$(echo "$question" | sed 's/ /%20/g')
    response=$(curl -s "https://piereeapi.vercel.app/ai/gpt4o?prompt=$encoded")
    echo "$response" | grep -o '"result":"[^"]*' | sed 's/"result":"//'
}

call_groq() {
    local question=$1
    local encoded=$(echo "$question" | sed 's/ /%20/g')
    response=$(curl -s "https://piereeapi.vercel.app/ai/groq?text=$encoded&model=gpt-5")
    echo "$response" | grep -o '"text":"[^"]*' | sed 's/"text":"//'
}

call_deepseek() {
    local question=$1
    local encoded=$(echo "$question" | sed 's/ /%20/g')
    response=$(curl -s "https://piereeapi.vercel.app/ai/deepseek?text=$encoded&model=depsekk-v2")
    echo "$response" | grep -o '"response":"[^"]*' | sed 's/"response":"//'
}

call_felo() {
    local question=$1
    local encoded=$(echo "$question" | sed 's/ /%20/g')
    response=$(curl -s "https://piereeapi.vercel.app/ai/felo?query=$encoded")
    echo "$response" | grep -o '"answer":"[^"]*' | sed 's/"answer":"//' | sed 's/\\n/ /g'
}

check_nik() {
    echo -e "${GREEN}◉ NIK Checker Tool${NC}"
    echo -e "${YELLOW}◉ Enter NIK number:${NC}"
    echo -e "${CYAN}"
    read -p "◉ NIK: " nik
    echo -e "${NC}"
    
    if [[ -z "$nik" ]]; then
        echo -e "${RED}◉ NIK cannot be empty!${NC}"
        return
    fi
    
    echo -e "${BLUE}◉ Checking NIK information...${NC}"
    
    (
        response=$(curl -s "https://api.siputzx.my.id/api/tools/nik-checker?nik=$nik")
        
        printf "\r\033[K"
        
        if echo "$response" | grep -q '"status":true'; then
            nama=$(echo "$response" | grep -o '"nama":"[^"]*' | sed 's/"nama":"//')
            kelamin=$(echo "$response" | grep -o '"kelamin":"[^"]*' | sed 's/"kelamin":"//')
            tempat_lahir=$(echo "$response" | grep -o '"tempat_lahir":"[^"]*' | sed 's/"tempat_lahir":"//')
            usia=$(echo "$response" | grep -o '"usia":"[^"]*' | sed 's/"usia":"//')
            provinsi=$(echo "$response" | grep -o '"provinsi":"[^"]*' | sed 's/"provinsi":"//')
            kabupaten=$(echo "$response" | grep -o '"kabupaten":"[^"]*' | sed 's/"kabupaten":"//')
            kecamatan=$(echo "$response" | grep -o '"kecamatan":"[^"]*' | sed 's/"kecamatan":"//')
            kelurahan=$(echo "$response" | grep -o '"kelurahan":"[^"]*' | sed 's/"kelurahan":"//')
            alamat=$(echo "$response" | grep -o '"alamat":"[^"]*' | sed 's/"alamat":"//')
            
            echo -e "${TEAL}◉ NIK Information:${NC}"
            echo -e "${WHITE}  Nama: $nama${NC}"
            echo -e "${WHITE}  Jenis Kelamin: $kelamin${NC}"
            echo -e "${WHITE}  Tempat/Tgl Lahir: $tempat_lahir${NC}"
            echo -e "${WHITE}  Usia: $usia${NC}"
            echo -e "${WHITE}  Provinsi: $provinsi${NC}"
            echo -e "${WHITE}  Kabupaten: $kabupaten${NC}"
            echo -e "${WHITE}  Kecamatan: $kecamatan${NC}"
            echo -e "${WHITE}  Kelurahan: $kelurahan${NC}"
            echo -e "${WHITE}  Alamat: $alamat${NC}"
        else
            echo -e "${RED}◉ Failed to get NIK information${NC}"
        fi
        
        echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
    ) &
    
    local pid=$!
    spinner $pid
    wait $pid
}

ngl_spammer() {
    echo -e "${GREEN}◉ NGL Spammer Tool${NC}"
    echo -e "${YELLOW}◉ Enter target username/URL:${NC}"
    echo -e "${CYAN}"
    read -p "◉ Target: " target
    echo -e "${NC}"
    
    echo -e "${YELLOW}◉ Enter message:${NC}"
    echo -e "${CYAN}"
    read -p "◉ Message: " message
    echo -e "${NC}"
    
    echo -e "${YELLOW}◉ Enter number of spam:${NC}"
    echo -e "${CYAN}"
    read -p "◉ Count: " count
    echo -e "${NC}"
    
    if [[ -z "$target" || -z "$message" || -z "$count" ]]; then
        echo -e "${RED}◉ All fields are required!${NC}"
        return
    fi
    
    echo -e "${BLUE}◉ Sending $count messages...${NC}"
    
    (
        encoded_target=$(echo "$target" | sed 's/ /%20/g')
        encoded_message=$(echo "$message" | sed 's/ /%20/g')
        
        for ((i=1; i<=count; i++)); do
            response=$(curl -s "https://piereeapi.vercel.app/tools/ngl?user=$encoded_target&msg=$encoded_message")
            echo -e "${GREEN}◉ Message $i sent${NC}"
            sleep 1
        done
        
        echo -e "${TEAL}◉ Successfully sent $count messages to $target${NC}"
        echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
    ) &
    
    local pid=$!
    spinner $pid
    wait $pid
}

chat_with_ai() {
    local model=$1
    local model_name=$2
    
    echo -e "${GREEN}◉ Selected: ${WHITE}$model_name${NC}"
    echo -e "${YELLOW}◉ Type 'back' to return to menu${NC}"
    echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
    
    while true; do
        echo -e "${CYAN}"
        read -p "◉ You: " question
        echo -e "${NC}"
        
        if [[ "$question" == "back" ]]; then
            echo -e "${YELLOW}◉ Returning to tools selection...${NC}"
            break
        fi
        
        if [[ -z "$question" ]]; then
            echo -e "${RED}◉ Question cannot be empty!${NC}"
            continue
        fi
        
        echo -e "${BLUE}◉ Processing request...${NC}"
        
        (
            case $model in
                "gpt4o")
                    response=$(call_gpt4o "$question")
                    ;;
                "groq")
                    response=$(call_groq "$question")
                    ;;
                "deepseek")
                    response=$(call_deepseek "$question")
                    ;;
                "felo")
                    response=$(call_felo "$question")
                    ;;
                *)
                    response="Model not implemented yet"
                    ;;
            esac
            
            printf "\r\033[K"
            if [[ -n "$response" ]]; then
                echo -e "${TEAL}◉ $model_name: ${WHITE}$response${NC}"
            else
                echo -e "${RED}◉ Failed to get response${NC}"
            fi
            
            echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
        ) &
        
        local pid=$!
        spinner $pid
        wait $pid
    done
}

main() {
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}◉ curl is not installed!${NC}"
        echo -e "${YELLOW}◉ Install with: pkg install curl${NC}"
        exit 1
    fi
    
    while true; do
        display_header
        show_tools
        
        echo -e "${CYAN}"
        read -p "◉ Select option (0-9): " choice
        echo -e "${NC}"
        
        case $choice in
            1)
                check_nik
                ;;
            2)
                ngl_spammer
                ;;
            3)
                chat_with_ai "gpt4o" "GPT-4o"
                ;;
            4)
                chat_with_ai "deepseek" "DeepSeek AI"
                ;;
            5)
                chat_with_ai "groq" "Groq AI"
                ;;
            6)
                chat_with_ai "felo" "Felo Search"
                ;;
            9)
                display_header
                ;;
            0)
                echo -e "${GREEN}◉ Thank you for using JianTools${NC}"
                echo -e "${PURPLE}◉ Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}◉ Invalid selection! Choose 0-9${NC}"
                sleep 2
                ;;
        esac
    done
}

main
