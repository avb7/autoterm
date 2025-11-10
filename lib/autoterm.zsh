#!/usr/bin/env zsh
# AutoTerm - AI-powered terminal command assistant
# ZSH integration library
# Version: 1.0.0

# Find the installation directory
# This works whether installed system-wide or locally
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
    AUTOTERM_BIN="${0:A:h}/../bin"
fi

AUTOTERM_CMD="${AUTOTERM_BIN}/autoterm"

# Verify command exists
if [[ ! -x "$AUTOTERM_CMD" ]]; then
    echo "Error: autoterm command not found at $AUTOTERM_CMD" >&2
    return 1
fi

# Context storage
typeset -g AUTOTERM_QUERY=""
typeset -g AUTOTERM_CONTEXT=()
typeset -g AUTOTERM_LAST_CMD=""

# Colors
AUTOTERM_COLOR_PROMPT="\e[1;36m"
AUTOTERM_COLOR_CMD="\e[1;32m"
AUTOTERM_COLOR_HELP="\e[0;33m"
AUTOTERM_COLOR_RESET="\e[0m"

# Widget for AI command generation
autoterm-generate-command() {
    local line="$BUFFER"
    
    # Check if line starts with #
    if [[ "$line" =~ ^#[[:space:]]*.+ ]]; then
        # Extract query (remove # and leading spaces)
        local query="${line#\#}"
        query="${query#"${query%%[![:space:]]*}"}"
        
        # Special commands
        if [[ "$query" == "clear" ]] || [[ "$query" == "reset" ]]; then
            AUTOTERM_CONTEXT=()
            AUTOTERM_QUERY=""
            AUTOTERM_LAST_CMD=""
            echo -e "\n${AUTOTERM_COLOR_PROMPT}🔄 Context cleared! Starting fresh.${AUTOTERM_COLOR_RESET}"
            BUFFER=""
            zle reset-prompt
            return
        fi
        
        if [[ -n "$query" ]]; then
            # Clear the line
            BUFFER=""
            zle redisplay
            
            # Show loading message
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
            # If we have a last query/command, add it to context first
            if [[ -n "$AUTOTERM_LAST_CMD" ]] && [[ -n "$AUTOTERM_QUERY" ]]; then
                # Check if this exact query is already in context (avoid duplicates)
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
            
            # Call backend to generate command
            local cmd_output
            eval "cmd_output=\$(python3 '$AUTOTERM_CMD' '$query' $context_arg 2>&1)"
            local exit_code=$?
            
            if [[ $exit_code -eq 0 ]] && [[ -n "$cmd_output" ]]; then
                AUTOTERM_QUERY="$query"
                AUTOTERM_LAST_CMD="$cmd_output"
                
                # Show the generated command
                echo -e "${AUTOTERM_COLOR_CMD}Command: ${AUTOTERM_COLOR_RESET}$cmd_output"
                echo -e "${AUTOTERM_COLOR_HELP}[Enter: Execute | Esc: Cancel | Tab: Refine with history]${AUTOTERM_COLOR_RESET}"
                
                # Put command in buffer
                BUFFER="$cmd_output"
                CURSOR=${#BUFFER}
                
                # Enter interactive mode
                zle -K autoterm
            else
                echo -e "\e[1;31m✗ Failed to generate command\e[0m"
                if [[ -n "$cmd_output" ]]; then
                    echo "$cmd_output"
                fi
                zle reset-prompt
            fi
        fi
    fi
}

# Widget for refining command
autoterm-refine-command() {
    # Clear buffer
    BUFFER=""
    zle redisplay
    
    # Show conversation history
    echo -e "\n${AUTOTERM_COLOR_PROMPT}━━━ Conversation History ━━━${AUTOTERM_COLOR_RESET}"
    
    # Show all previous exchanges
    local idx=1
    for item in "${AUTOTERM_CONTEXT[@]}"; do
        # Extract query and command from JSON (simple parsing)
        local hist_query=$(echo "$item" | sed -n 's/.*"query":"\([^"]*\)".*/\1/p')
        local hist_cmd=$(echo "$item" | sed -n 's/.*"command":"\([^"]*\)".*/\1/p')
        echo -e "${AUTOTERM_COLOR_HELP}${idx}. Query:${AUTOTERM_COLOR_RESET} $hist_query"
        echo -e "   ${AUTOTERM_COLOR_HELP}Command:${AUTOTERM_COLOR_RESET} $hist_cmd"
        ((idx++))
    done
    
    # Show current query and command
    echo -e "${AUTOTERM_COLOR_HELP}${idx}. Query:${AUTOTERM_COLOR_RESET} $AUTOTERM_QUERY"
    echo -e "   ${AUTOTERM_COLOR_HELP}Command:${AUTOTERM_COLOR_RESET} $AUTOTERM_LAST_CMD"
    echo -e "${AUTOTERM_COLOR_PROMPT}━━━━━━━━━━━━━━━━━━━━━━━━━━${AUTOTERM_COLOR_RESET}"
    
    # Prompt for refinement with # already there
    echo -e "\n${AUTOTERM_COLOR_PROMPT}🔄 Type your refinement and press Tab Tab again:${AUTOTERM_COLOR_RESET}"
    
    # Put # in the buffer and let user edit it naturally
    BUFFER="# "
    CURSOR=2
    
    # Exit autoterm mode and go back to main for editing
    zle -K main
    zle redisplay
    
    # Don't process further - let the user type and press Tab Tab again
    return
}

# Widget for accepting command
autoterm-accept-command() {
    # Keep context for next query (don't reset)
    # This allows building on previous commands
    
    # Return to main keymap and accept line
    zle -K main
    zle accept-line
}

# Widget for canceling
autoterm-cancel() {
    # Clear context
    AUTOTERM_CONTEXT=()
    AUTOTERM_QUERY=""
    AUTOTERM_LAST_CMD=""
    
    # Clear buffer and return to main mode
    BUFFER=""
    zle -K main
    zle reset-prompt
}

# Create custom keymap for autoterm mode
if [[ ! -a autoterm ]]; then
    bindkey -N autoterm
fi

# Bind keys in autoterm mode
bindkey -M autoterm "^M" autoterm-accept-command     # Enter
bindkey -M autoterm "^[" autoterm-cancel              # Escape
bindkey -M autoterm "^I" autoterm-refine-command      # Tab

# Register widgets
zle -N autoterm-generate-command
zle -N autoterm-refine-command
zle -N autoterm-accept-command
zle -N autoterm-cancel

# Create a wrapper widget for double-tab detection
autoterm-tab-handler() {
    # Check if this is a double-tab (within 0.5 seconds)
    local current_time=$EPOCHREALTIME
    local time_diff=0
    
    if [[ -n "$AUTOTERM_LAST_TAB_TIME" ]]; then
        time_diff=$(echo "$current_time - $AUTOTERM_LAST_TAB_TIME" | bc)
    fi
    
    AUTOTERM_LAST_TAB_TIME=$current_time
    
    # If double-tab detected (< 0.5 seconds)
    if [[ -n "$time_diff" ]] && (( $(echo "$time_diff < 0.5" | bc -l) )); then
        # Reset the timer
        AUTOTERM_LAST_TAB_TIME=""
        
        # Check if line starts with #
        if [[ "$BUFFER" =~ ^#[[:space:]]*.+ ]]; then
            autoterm-generate-command
            return
        fi
    fi
    
    # Otherwise, do normal tab completion
    zle expand-or-complete
}

zle -N autoterm-tab-handler

# Bind double-tab to our handler in main mode
bindkey "^I" autoterm-tab-handler

# Show version info
autoterm-version() {
    echo "AutoTerm v1.0.0 - AI-powered terminal assistant"
    python3 "$AUTOTERM_CMD" --version
}

