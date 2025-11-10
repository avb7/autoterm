#!/usr/bin/env bash
# AutoTerm - AI-powered terminal command assistant
# BASH integration library
# Version: 1.0.0

# Find the installation directory
if [[ -n "${AUTOTERM_PREFIX}" ]]; then
    AUTOTERM_BIN="${AUTOTERM_PREFIX}/bin"
elif [[ -f "/usr/local/bin/autoterm" ]]; then
    AUTOTERM_BIN="/usr/local/bin"
elif [[ -f "/usr/bin/autoterm" ]]; then
    AUTOTERM_BIN="/usr/bin"
elif [[ -f "${HOME}/.local/bin/autoterm" ]]; then
    AUTOTERM_BIN="${HOME}/.local/bin"
else
    # Development mode - use relative path
    AUTOTERM_BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")/../bin" && pwd)"
fi

AUTOTERM_CMD="${AUTOTERM_BIN}/autoterm"

# Verify command exists
if [[ ! -x "$AUTOTERM_CMD" ]]; then
    echo "Error: autoterm command not found at $AUTOTERM_CMD" >&2
    return 1
fi

# Context storage
AUTOTERM_QUERY=""
AUTOTERM_CONTEXT=()
AUTOTERM_LAST_CMD=""
AUTOTERM_MODE="normal"

# Colors
AUTOTERM_COLOR_PROMPT="\e[1;36m"
AUTOTERM_COLOR_CMD="\e[1;32m"
AUTOTERM_COLOR_HELP="\e[0;33m"
AUTOTERM_COLOR_RESET="\e[0m"

# Function to generate command
autoterm_generate() {
    local query="$1"
    
    # Special commands
    if [[ "$query" == "clear" ]] || [[ "$query" == "reset" ]]; then
        AUTOTERM_CONTEXT=()
        AUTOTERM_QUERY=""
        AUTOTERM_LAST_CMD=""
        echo -e "\n${AUTOTERM_COLOR_PROMPT}🔄 Context cleared! Starting fresh.${AUTOTERM_COLOR_RESET}"
        return
    fi
    
    echo -e "\n${AUTOTERM_COLOR_PROMPT}🤖 Generating command for: ${AUTOTERM_COLOR_RESET}$query"
    
    # Show context indicator if we have previous commands
    if [[ ${#AUTOTERM_CONTEXT[@]} -gt 0 ]] || [[ -n "$AUTOTERM_LAST_CMD" ]]; then
        local ctx_count=${#AUTOTERM_CONTEXT[@]}
        if [[ -n "$AUTOTERM_LAST_CMD" ]]; then
            ((ctx_count++))
        fi
        echo -e "${AUTOTERM_COLOR_HELP}💭 Using context from $ctx_count previous command(s)${AUTOTERM_COLOR_RESET}"
    fi
    
    # Build context argument
    if [[ -n "$AUTOTERM_LAST_CMD" ]] && [[ -n "$AUTOTERM_QUERY" ]]; then
        local already_in_context=false
        for item in "${AUTOTERM_CONTEXT[@]}"; do
            if [[ "$item" == *"\"query\":\"$AUTOTERM_QUERY\""* ]]; then
                already_in_context=true
                break
            fi
        done
        if [[ "$already_in_context" == false ]]; then
            AUTOTERM_CONTEXT+=("{\"query\":\"$AUTOTERM_QUERY\",\"command\":\"$AUTOTERM_LAST_CMD\"}")
        fi
    fi
    
    local context_arg=""
    if [[ ${#AUTOTERM_CONTEXT[@]} -gt 0 ]]; then
        local context_json="["
        local first=true
        for item in "${AUTOTERM_CONTEXT[@]}"; do
            if [[ "$first" == true ]]; then
                first=false
            else
                context_json+=","
            fi
            context_json+="$item"
        done
        context_json+="]"
        context_arg="--context '$context_json'"
    fi
    
    # Call backend
    local cmd_output
    eval "cmd_output=\$(python3 '$AUTOTERM_CMD' '$query' $context_arg 2>&1)"
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]] && [[ -n "$cmd_output" ]]; then
        AUTOTERM_QUERY="$query"
        AUTOTERM_LAST_CMD="$cmd_output"
        
        echo -e "${AUTOTERM_COLOR_CMD}Command: ${AUTOTERM_COLOR_RESET}$cmd_output"
        echo -e "${AUTOTERM_COLOR_HELP}Execute? [y/N] ${AUTOTERM_COLOR_RESET}"
        
        read -n 1 -r reply
        echo
        
        if [[ $reply =~ ^[Yy]$ ]]; then
            eval "$cmd_output"
        else
            echo "Command cancelled"
        fi
    else
        echo -e "\e[1;31m✗ Failed to generate command\e[0m"
        if [[ -n "$cmd_output" ]]; then
            echo "$cmd_output"
        fi
    fi
}

# Main command interface
autoterm() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: autoterm <query>"
        echo "Example: autoterm find all python files"
        echo ""
        echo "Options:"
        echo "  autoterm --setup    Setup API key"
        echo "  autoterm --test     Test connection"
        echo "  autoterm --clear    Clear context history"
        echo "  autoterm --version  Show version"
        return 1
    fi
    
    # Pass through options
    if [[ "$1" == "--setup" ]] || [[ "$1" == "--test" ]] || [[ "$1" == "--version" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "--clear" ]]; then
        python3 "$AUTOTERM_CMD" "$@"
        # If clearing, also clear in-memory context
        if [[ "$1" == "--clear" ]]; then
            AUTOTERM_CONTEXT=()
            AUTOTERM_QUERY=""
            AUTOTERM_LAST_CMD=""
        fi
        return $?
    fi
    
    autoterm_generate "$*"
}

# Alias for convenience
alias at='autoterm'

# Info message
echo -e "${AUTOTERM_COLOR_PROMPT}🚀 AutoTerm loaded for bash!${AUTOTERM_COLOR_RESET}"
echo -e "${AUTOTERM_COLOR_HELP}Usage: autoterm <your query>${AUTOTERM_COLOR_RESET}"
echo -e "${AUTOTERM_COLOR_HELP}Example: autoterm find all python files${AUTOTERM_COLOR_RESET}"

