#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
ORANGE='\033[38;5;208m'
BLOOD_RED='\033[38;5;88m'
DARK_BLUE='\033[38;5;19m'
GOLD='\033[38;5;220m'
SILVER='\033[38;5;250m'
NC='\033[0m'

progress_bar() {
    local duration=$1
    printf "${BLOOD_RED}["
    for ((i=0; i<duration; i++)); do
        printf "█"
        sleep 0.1
    done
    printf "]${NC}\n"
    printf "\033[2K\033[1A\033[2K"
}

display_header() {
    clear
    echo -e "${BLOOD_RED}"
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
    echo -e "${BLOOD_RED}                    ═════ AI CHAT TERMINAL v4.0 ═════${NC}"
    echo
    
    echo -e "${DARK_BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${DARK_BLUE}║ ${GOLD}♛ ${WHITE}System: Ubuntu 22.04 LTS x86_64                          ${DARK_BLUE}║${NC}"
    echo -e "${DARK_BLUE}║ ${GOLD}♛ ${WHITE}CPU: AMD Ryzen 7 5800X (16) @ 3.800GHz                   ${DARK_BLUE}║${NC}"
    echo -e "${DARK_BLUE}║ ${GOLD}♛ ${WHITE}Memory: 15888MiB / 32061MiB                              ${DARK_BLUE}║${NC}"
    echo -e "${DARK_BLUE}║ ${GOLD}♛ ${WHITE}Uptime: 2 hours, 35 minutes                              ${DARK_BLUE}║${NC}"
    echo -e "${DARK_BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
}

show_models() {
    echo -e "${BLOOD_RED}▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄${NC}"
    echo -e "${BLOOD_RED}█                       AI MODEL SELECTION                       █${NC}"
    echo -e "${BLOOD_RED}█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█${NC}"
    echo -e "${BLOOD_RED}█ ${GOLD}1${BLOOD_RED} │ ${SILVER}▓▓▓ GPT-4o ${BLOOD_RED}       │ ${GREEN}OpenAI Latest Model                  ${BLOOD_RED}█${NC}"
    echo -e "${BLOOD_RED}█ ${GOLD}2${BLOOD_RED} │ ${SILVER}▓▓▓ GPT-5 ${BLOOD_RED}        │ ${GREEN}Next Generation GPT                 ${BLOOD_RED}█${NC}"
    echo -e "${BLOOD_RED}█ ${GOLD}3${BLOOD_RED} │ ${SILVER}▓▓▓ Gemini ${BLOOD_RED}       │ ${GREEN}Google AI Assistant                 ${BLOOD_RED}█${NC}"
    echo -e "${BLOOD_RED}█ ${GOLD}4${BLOOD_RED} │ ${SILVER}▓▓▓ DeepSeek ${BLOOD_RED}     │ ${GREEN}DeepSeek Coder                      ${BLOOD_RED}█${NC}"
    echo -e "${BLOOD_RED}█ ${GOLD}5${BLOOD_RED} │ ${SILVER}▓▓▓ Claude ${BLOOD_RED}       │ ${GREEN}Anthropic AI                        ${BLOOD_RED}█${NC}"
    echo -e "${BLOOD_RED}█ ${GOLD}6${BLOOD_RED} │ ${SILVER}▓▓▓ Groq ${BLOOD_RED}         │ ${GREEN}Groq AI Model                       ${BLOOD_RED}█${NC}"
    echo -e "${BLOOD_RED}█ ${GOLD}7${BLOOD_RED} │ ${SILVER}▓▓▓ Felo ${BLOOD_RED}         │ ${GREEN}Search Assistant                    ${BLOOD_RED}█${NC}"
    echo -e "${BLOOD_RED}█──────────────────────────────────────────────────────────────█${NC}"
    echo -e "${BLOOD_RED}█ ${RED}0${BLOOD_RED} │ ${RED}▓▓▓ Exit ${BLOOD_RED}          │ ${RED}Exit Terminal                       ${BLOOD_RED}█${NC}"
    echo -e "${BLOOD_RED}█ ${RED}9${BLOOD_RED} │ ${RED}▓▓▓ Clear ${BLOOD_RED}         │ ${RED}Clear Screen                        ${BLOOD_RED}█${NC}"
    echo -e "${BLOOD_RED}█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█${NC}"
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
    
    echo -e "${GOLD}▓ Selected: ${SILVER}$model_name${NC}"
    echo -e "${GREEN}▓ Type 'back' to return to menu${NC}"
    echo -e "${BLOOD_RED}════════════════════════════════════════════════════════════════${NC}"
    
    while true; do
        echo -e "${GOLD}"
        read -p "▓ You: " question
        echo -e "${NC}"
        
        if [[ "$question" == "back" ]]; then
            echo -e "${YELLOW}▓ Returning to model selection...${NC}"
            break
        fi
        
        if [[ -z "$question" ]]; then
            echo -e "${RED}▓ Question cannot be empty!${NC}"
            continue
        fi
        
        echo -e "${BLOOD_RED}▓ Processing request...${NC}"
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
            echo -e "${SILVER}▓ $model_name: ${WHITE}$response${NC}"
        else
            echo -e "${RED}▓ Failed to get response${NC}"
        fi
        
        echo -e "${BLOOD_RED}════════════════════════════════════════════════════════════════${NC}"
    done
}

main() {
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}▓ curl is not installed!${NC}"
        echo -e "${YELLOW}▓ Install with: pkg install curl${NC}"
        exit 1
    fi
    
    while true; do
        display_header
        show_models
        
        echo -e "${GOLD}"
        read -p "▓ Select option (0-9): " choice
        echo -e "${NC}"
        
        case $choice in
            1)
                chat_with_ai "gpt4o" "GPT-4o"
                ;;
            2)
                chat_with_ai "groq" "GPT-5 via Groq"
                ;;
            3)
                echo -e "${YELLOW}▓ Gemini coming soon...${NC}"
                sleep 2
                ;;
            4)
                chat_with_ai "deepseek" "DeepSeek AI"
                ;;
            5)
                echo -e "${YELLOW}▓ Claude coming soon...${NC}"
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
                echo -e "${GOLD}▓ Thank you for using AI Chat Terminal${NC}"
                echo -e "${BLOOD_RED}▓ Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}▓ Invalid selection! Choose 0-9${NC}"
                sleep 2
                ;;
        esac
    done
}

main
