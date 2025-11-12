#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

progress_bar() {
    local duration=$1
    printf "${CYAN}["
    for ((i=0; i<duration; i++)); do
        printf "▇"
        sleep 0.1
    done
    printf "]${NC}\n"
}

display_header() {
    clear
    echo -e "${BLUE}"
    echo "████████████████████████████████████████████████████████████████████"
    echo "██                                                              ██"
    echo "██                   AI CHAT TERMINAL v2.0                      ██"
    echo "██                 Ubuntu NeoFetch Interface                    ██"
    echo "██                                                              ██"
    echo "████████████████████████████████████████████████████████████████████"
    echo -e "${NC}"
    
    echo -e "${YELLOW}┌────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│ ${GREEN}  System: ${WHITE}Ubuntu 22.04 LTS x86_64${NC}"
    echo -e "${YELLOW}│ ${GREEN}  CPU: ${WHITE}AMD Ryzen 7 5800X (16) @ 3.800GHz${NC}"
    echo -e "${YELLOW}│ ${GREEN}  Memory: ${WHITE}15888MiB / 32061MiB${NC}"
    echo -e "${YELLOW}│ ${GREEN}  Uptime: ${WHITE}2 hours, 35 minutes${NC}"
    echo -e "${YELLOW}│ ${GREEN}  Shell: ${WHITE}bash 5.1.16${NC}"
    echo -e "${YELLOW}│ ${GREEN}  DE: ${WHITE}GNOME 42.5${NC}"
    echo -e "${YELLOW}│ ${GREEN}  Theme: ${WHITE}Adwaita [GTK2/3]${NC}"
    echo -e "${YELLOW}└────────────────────────────────────────────────────────────┘${NC}"
    echo
}

show_models() {
    echo -e "${PURPLE}  AI MODEL SELECTION:${NC}"
    echo -e "${CYAN}┌───┬─────────────────┬────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│ ${GREEN}1${CYAN} │ ${WHITE}  gpt-4o-mini${CYAN}   │ ${YELLOW}OpenAI Fast Model${CYAN}                 │${NC}"
    echo -e "${CYAN}│ ${GREEN}2${CYAN} │ ${WHITE}  gpt-5-nano${CYAN}    │ ${YELLOW}Latest GPT Technology${CYAN}            │${NC}"
    echo -e "${CYAN}│ ${GREEN}3${CYAN} │ ${WHITE}  gemini${CYAN}        │ ${YELLOW}Google AI Assistant${CYAN}              │${NC}"
    echo -e "${CYAN}│ ${GREEN}4${CYAN} │ ${WHITE}  deepseek${CYAN}      │ ${YELLOW}DeepSeek Coder${CYAN}                   │${NC}"
    echo -e "${CYAN}│ ${GREEN}5${CYAN} │ ${WHITE}  claude${CYAN}        │ ${YELLOW}Anthropic AI${CYAN}                     │${NC}"
    echo -e "${CYAN}│ ${GREEN}6${CYAN} │ ${WHITE}  grok${CYAN}          │ ${YELLOW}xAI Humorous Model${CYAN}               │${NC}"
    echo -e "${CYAN}│ ${GREEN}7${CYAN} │ ${WHITE}  meta-ai${CYAN}       │ ${YELLOW}Meta AI Assistant${CYAN}                │${NC}"
    echo -e "${CYAN}│ ${GREEN}8${CYAN} │ ${WHITE}  qwen${CYAN}          │ ${YELLOW}Alibaba Qwen${CYAN}                     │${NC}"
    echo -e "${CYAN}├───┼─────────────────┼────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│ ${RED}0${CYAN} │ ${RED}  exit${CYAN}           │ ${RED}Exit Terminal${CYAN}                    │${NC}"
    echo -e "${CYAN}│ ${RED}9${CYAN} │ ${RED}  clear${CYAN}          │ ${RED}Clear Screen${CYAN}                     │${NC}"
    echo -e "${CYAN}└───┴─────────────────┴────────────────────────────────────┘${NC}"
    echo
}

chat_with_ai() {
    local model=$1
    local model_name=$2
    
    echo -e "${GREEN}  Selected: ${WHITE}$model_name${NC}"
    echo -e "${YELLOW}  Type 'back' to return to menu${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
    
    while true; do
        echo -e "${BLUE}"
        read -p "  You: " question
        echo -e "${NC}"
        
        if [[ "$question" == "back" ]]; then
            echo -e "${YELLOW}  Returning to model selection...${NC}"
            break
        fi
        
        if [[ -z "$question" ]]; then
            echo -e "${RED}  Question cannot be empty!${NC}"
            continue
        fi
        
        echo -e "${CYAN}  Processing request...${NC}"
        progress_bar 15
        
        response=$(node -e "
const axios = require('axios');
const { v4: uuidv4 } = require('uuid');

async function aichat() {
    try {
        const modelMap = {
            'gpt-4o-mini': '25865',
            'gpt-5-nano': '25871', 
            'gemini': '25874',
            'deepseek': '25873',
            'claude': '25875',
            'grok': '25872',
            'meta-ai': '25870',
            'qwen': '25869'
        };
        
        const htmlResponse = await axios.post('https://api.nekolabs.web.id/px?url=' + encodeURIComponent('https://chatgptfree.ai/') + '&version=v2');
        const nonceMatch = htmlResponse.result.content.match(/&quot;nonce&quot;\\s*:\\s*&quot;([^&]+)&quot;/);
        if (!nonceMatch) throw new Error('Nonce not found');
        
        const chatResponse = await axios.post('https://api.nekolabs.web.id/px?url=' + encodeURIComponent('https://chatgptfree.ai/wp-admin/admin-ajax.php') + '&version=v2', 
            'action=aipkit_frontend_chat_message&_ajax_nonce=' + nonceMatch[1] + '&bot_id=' + modelMap['$model'] + '&session_id=' + uuidv4() + '&conversation_uuid=' + uuidv4() + '&post_id=6&message=' + encodeURIComponent('$question'),
            {
                headers: {
                    origin: 'https://chatgptfree.ai',
                    referer: 'https://chatgptfree.ai/',
                    'user-agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0'
                }
            }
        );
        
        console.log(chatResponse.result.content.data.reply);
    } catch (error) {
        console.error('Error: ' + error.message);
    }
}

aichat();
" 2>/dev/null)
        
        if [[ -n "$response" ]]; then
            echo -e "${GREEN}  $model_name: ${WHITE}$response${NC}"
        else
            echo -e "${RED}  Failed to get response${NC}"
        fi
        
        echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
    done
}

main() {
    if ! command -v node &> /dev/null; then
        echo -e "${RED}  Node.js is not installed!${NC}"
        echo -e "${YELLOW}  Install with: pkg install nodejs${NC}"
        exit 1
    fi
    
    if ! npm list axios uuid &> /dev/null; then
        echo -e "${YELLOW}  Installing required packages...${NC}"
        npm install axios uuid > /dev/null 2>&1
    fi
    
    while true; do
        display_header
        show_models
        
        echo -e "${BLUE}"
        read -p "  Select option (0-9): " choice
        echo -e "${NC}"
        
        case $choice in
            1)
                chat_with_ai "gpt-4o-mini" "GPT-4o Mini"
                ;;
            2)
                chat_with_ai "gpt-5-nano" "GPT-5 Nano"
                ;;
            3)
                chat_with_ai "gemini" "Google Gemini"
                ;;
            4)
                chat_with_ai "deepseek" "DeepSeek AI"
                ;;
            5)
                chat_with_ai "claude" "Claude AI"
                ;;
            6)
                chat_with_ai "grok" "Grok AI"
                ;;
            7)
                chat_with_ai "meta-ai" "Meta AI"
                ;;
            8)
                chat_with_ai "qwen" "Qwen AI"
                ;;
            9)
                display_header
                ;;
            0)
                echo -e "${GREEN}  Thank you for using AI Chat Terminal${NC}"
                echo -e "${YELLOW}  Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}  Invalid selection! Choose 0-9${NC}"
                sleep 2
                ;;
        esac
    done
}

main
