#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

GOLD='\033[38;5;220m'
DARK_BLUE='\033[38;5;33m'
BRIGHT_CYAN='\033[38;5;51m'
ORANGE='\033[38;5;208m'
DARK_PURPLE='\033[38;5;93m'
BRIGHT_WHITE='\033[38;5;231m'

progress_bar() {
    local duration=$1
    printf "${DARK_BLUE}["
    for ((i=0; i<duration; i++)); do
        printf "▰"
        sleep 0.1
    done
    printf "]${NC}\n"
    printf "\033[2K\033[1A\033[2K"
}

display_header() {
    clear
    echo -e "${GOLD}${BOLD}"
    echo "                                             ......                                                 "
    echo "                                        ..#@@@@@@@@@@#...                                           "
    echo "                                     ..*@@@#-.. ...-%@@@#%%%#*-..                                   "
    echo "                                    .:@@@-.    ...-%@@@@%%##%@@@@%:.                                "
    echo "                                 .-#@@@@:.   .:%@@@@*..       ..#@@%.                               "
    echo "                              .=@@@@#@@*  .-@@@@*:.    .++:      :@@@:                              "
    echo "                            .:@@@*. -@@*   +@*.   ..+@@@@@@@@+..  :@@#                              "
    echo "                           ..@@@:. .-@@*   +@*..+@@@*......=@@@@@*.@@%                              "
    echo "                            *@@-.  .-@@*   +@@@@*:.-#@@#-.   ..=%@@@@=                              "
    echo "                           .*@@-.  .-@@*  .+@*..     ..%@@@%-...  :%@@#.                            "
    echo "                           ..@@@:   .%@@*..+@*.       .%@:.-%@@*.  .=@@#.                           "
    echo "                            .:@@@*.   ..+@@@@*.      ..%@:  :@@@.   .#@@-                           "
    echo "                              .@@@@@#:.   ..+@@@+..:%@@@@:  :@@@.   .#@@-                           "
    echo "                              -@@#:#@@@@#:.. ..-@@@%-..%@:  :@@@.  .=@@#.                           "
    echo "                              :@@@.  .-#@@@@%@@%=......@@:  :@@@..:%@@#.                            "
    echo "                              .*@@*..   ..-#-..  ..-@@@@@:  :@@@@@@@%.                              "
    echo "                               .=@@@+.        .=%@@@@+..    +@@@@+:.                                "
    echo "                                 .=@@@@@#*#%@@@@@*:.     ..#@@*.                                    "
    echo "                                    ..=#%@@%@@@@*:......+@@@@:.                                     "
    echo "                                            ..-%@@@@@@@@@@=...                                      "
    echo "                                                 ........                                           "
    echo "                                                                                                    "
    echo "                                                                                                    "
    echo "                      .+@@@@@+..%@.            .##...=@@@@@#:.:@@@@@@+:@@@@@@@@.                    "
    echo "                     .#@-  .:+-.%@%@@@. =@@@@#.%@@@.#@-....::.:@@...%@-...@%.                       "
    echo "                   . .%@:  .. ..%@..=@+.:+*#@@..@@..%@: .@@@@.:@@@@@@-. ..@%.                       "
    echo "                     .-@@=:=@@:.%@. =@+-@#.:%@..@@:.-@@=:-#@@.:@%..     ..@%.                       "
    echo "                       ..:-:.. .... .................  :-.........       ...                        "
    echo "                                               ..."
    echo -e "${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}                    ╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}                    ║  ⚡ AI CHAT TERMINAL v4.0 ULTIMATE ⚡  ║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}                    ╚═══════════════════════════════════════════════╝${NC}"
    echo
    
    echo -e "${DARK_BLUE}${BOLD}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${DARK_BLUE}${BOLD}║${NC} ${GOLD}⚙${NC}  ${GREEN}${BOLD}System:${NC} ${BRIGHT_WHITE}Ubuntu 22.04 LTS x86_64${NC}                             ${DARK_BLUE}${BOLD}║${NC}"
    echo -e "${DARK_BLUE}${BOLD}║${NC} ${GOLD}🔥${NC} ${GREEN}${BOLD}CPU:${NC} ${BRIGHT_WHITE}AMD Ryzen 7 5800X (16) @ 3.800GHz${NC}                    ${DARK_BLUE}${BOLD}║${NC}"
    echo -e "${DARK_BLUE}${BOLD}║${NC} ${GOLD}💎${NC} ${GREEN}${BOLD}Memory:${NC} ${BRIGHT_WHITE}15888MiB / 32061MiB${NC}                                  ${DARK_BLUE}${BOLD}║${NC}"
    echo -e "${DARK_BLUE}${BOLD}║${NC} ${GOLD}⏱${NC}  ${GREEN}${BOLD}Uptime:${NC} ${BRIGHT_WHITE}2 hours, 35 minutes${NC}                                  ${DARK_BLUE}${BOLD}║${NC}"
    echo -e "${DARK_BLUE}${BOLD}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo
}

show_models() {
    echo -e "${BRIGHT_CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║                     🤖 AI MODEL SELECTION 🤖                     ║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}╠═══╦═══════════════════╦═══════════════════════════════════════════╣${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║${NC} ${GOLD}${BOLD}1${NC} ${BRIGHT_CYAN}${BOLD}║${NC} ${BRIGHT_WHITE}${BOLD}🌟 GPT-4o${NC}          ${BRIGHT_CYAN}${BOLD}║${NC} ${YELLOW}⚡ OpenAI Latest Model${NC}                 ${BRIGHT_CYAN}${BOLD}║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║${NC} ${GOLD}${BOLD}2${NC} ${BRIGHT_CYAN}${BOLD}║${NC} ${BRIGHT_WHITE}${BOLD}🚀 GPT-5${NC}           ${BRIGHT_CYAN}${BOLD}║${NC} ${YELLOW}💫 Next Generation GPT${NC}                ${BRIGHT_CYAN}${BOLD}║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║${NC} ${GOLD}${BOLD}3${NC} ${BRIGHT_CYAN}${BOLD}║${NC} ${BRIGHT_WHITE}${BOLD}🌐 Gemini${NC}         ${BRIGHT_CYAN}${BOLD}║${NC} ${YELLOW}🔮 Google AI Assistant${NC}                ${BRIGHT_CYAN}${BOLD}║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║${NC} ${GOLD}${BOLD}4${NC} ${BRIGHT_CYAN}${BOLD}║${NC} ${BRIGHT_WHITE}${BOLD}💻 DeepSeek${NC}       ${BRIGHT_CYAN}${BOLD}║${NC} ${YELLOW}🎯 DeepSeek Coder${NC}                     ${BRIGHT_CYAN}${BOLD}║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║${NC} ${GOLD}${BOLD}5${NC} ${BRIGHT_CYAN}${BOLD}║${NC} ${BRIGHT_WHITE}${BOLD}🧠 Claude${NC}         ${BRIGHT_CYAN}${BOLD}║${NC} ${YELLOW}⚡ Anthropic AI${NC}                       ${BRIGHT_CYAN}${BOLD}║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║${NC} ${GOLD}${BOLD}6${NC} ${BRIGHT_CYAN}${BOLD}║${NC} ${BRIGHT_WHITE}${BOLD}⚡ Groq${NC}           ${BRIGHT_CYAN}${BOLD}║${NC} ${YELLOW}🔥 Groq AI Model${NC}                      ${BRIGHT_CYAN}${BOLD}║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║${NC} ${GOLD}${BOLD}7${NC} ${BRIGHT_CYAN}${BOLD}║${NC} ${BRIGHT_WHITE}${BOLD}🔍 Felo${NC}           ${BRIGHT_CYAN}${BOLD}║${NC} ${YELLOW}🌟 Search Assistant${NC}                   ${BRIGHT_CYAN}${BOLD}║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}╠═══╬═══════════════════╬═══════════════════════════════════════════╣${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║${NC} ${RED}${BOLD}0${NC} ${BRIGHT_CYAN}${BOLD}║${NC} ${RED}${BOLD}❌ Exit${NC}           ${BRIGHT_CYAN}${BOLD}║${NC} ${RED}🚪 Exit Terminal${NC}                      ${BRIGHT_CYAN}${BOLD}║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}║${NC} ${RED}${BOLD}9${NC} ${BRIGHT_CYAN}${BOLD}║${NC} ${RED}${BOLD}🔄 Clear${NC}          ${BRIGHT_CYAN}${BOLD}║${NC} ${RED}🧹 Clear Screen${NC}                       ${BRIGHT_CYAN}${BOLD}║${NC}"
    echo -e "${BRIGHT_CYAN}${BOLD}╚═══╩═══════════════════╩═══════════════════════════════════════════╝${NC}"
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

chat_with_ai() {
    local model=$1
    local model_name=$2
    
    echo -e "${GREEN}${BOLD}✅ Selected: ${BRIGHT_WHITE}$model_name${NC}"
    echo -e "${YELLOW}${BOLD}💡 Type 'back' to return to menu${NC}"
    echo -e "${DARK_BLUE}${BOLD}═══════════════════════════════════════════════════════════════════${NC}"
    
    while true; do
        echo -e "${BRIGHT_CYAN}${BOLD}"
        read -p "👤 You: " question
        echo -e "${NC}"
        
        if [[ "$question" == "back" ]]; then
            echo -e "${YELLOW}${BOLD}🔙 Returning to model selection...${NC}"
            break
        fi
        
        if [[ -z "$question" ]]; then
            echo -e "${RED}${BOLD}⚠️  Question cannot be empty!${NC}"
            continue
        fi
        
        echo -e "${DARK_PURPLE}${BOLD}⏳ Processing request...${NC}"
        progress_bar 12 &
        progress_pid=$!
        
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
        
        kill $progress_pid 2>/dev/null
        wait $progress_pid 2>/dev/null
        
        if [[ -n "$response" ]]; then
            echo -e "${GOLD}${BOLD}🤖 $model_name: ${BRIGHT_WHITE}$response${NC}"
        else
            echo -e "${RED}${BOLD}❌ Failed to get response${NC}"
        fi
        
        echo -e "${DARK_BLUE}${BOLD}═══════════════════════════════════════════════════════════════════${NC}"
    done
}

main() {
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}${BOLD}❌ curl is not installed!${NC}"
        echo -e "${YELLOW}${BOLD}💡 Install with: pkg install curl${NC}"
        exit 1
    fi
    
    while true; do
        display_header
        show_models
        
        echo -e "${BRIGHT_CYAN}${BOLD}"
        read -p "⚡ Select option (0-9): " choice
        echo -e "${NC}"
        
        case $choice in
            1)
                chat_with_ai "gpt4o" "GPT-4o"
                ;;
            2)
                chat_with_ai "groq" "GPT-5 via Groq"
                ;;
            3)
                echo -e "${YELLOW}${BOLD}⏳ Gemini coming soon...${NC}"
                sleep 2
                ;;
            4)
                chat_with_ai "deepseek" "DeepSeek AI"
                ;;
            5)
                echo -e "${YELLOW}${BOLD}⏳ Claude coming soon...${NC}"
                sleep 2
                ;;
            6)
                chat_with_ai "groq" "Groq AI"
                ;;
            7)
                chat_with_ai "felo" "Felo Search"
                ;;
            9)
                display_header
                ;;
            0)
                echo -e "${GREEN}${BOLD}✨ Thank you for using AI Chat Terminal${NC}"
                echo -e "${GOLD}${BOLD}👋 Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}${BOLD}❌ Invalid selection! Choose 0-9${NC}"
                sleep 2
                ;;
        esac
    done
}

main
