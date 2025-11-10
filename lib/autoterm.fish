#!/usr/bin/env fish
# AutoTerm - AI-powered terminal command assistant
# Fish shell integration library
# Version: 1.0.0

# Find the installation directory
if set -q AUTOTERM_PREFIX
    set AUTOTERM_BIN "$AUTOTERM_PREFIX/bin"
else if test -f /usr/local/bin/autoterm-backend
    set AUTOTERM_BIN /usr/local/bin
else if test -f /usr/bin/autoterm-backend
    set AUTOTERM_BIN /usr/bin
else if test -f $HOME/.local/bin/autoterm-backend
    set AUTOTERM_BIN $HOME/.local/bin
else
    # Development mode
    set AUTOTERM_BIN (dirname (status -f))/../bin
end

set AUTOTERM_CMD $AUTOTERM_BIN/autoterm

# Verify command exists
if not test -x $AUTOTERM_CMD
    echo "Error: autoterm command not found at $AUTOTERM_CMD" >&2
    exit 1
end

# Context storage (global variables in fish)
set -g AUTOTERM_QUERY ""
set -g AUTOTERM_CONTEXT
set -g AUTOTERM_LAST_CMD ""

# Colors
set -g AUTOTERM_COLOR_PROMPT (set_color cyan --bold)
set -g AUTOTERM_COLOR_CMD (set_color green --bold)
set -g AUTOTERM_COLOR_HELP (set_color yellow)
set -g AUTOTERM_COLOR_RESET (set_color normal)

# Function to generate command
function autoterm_generate
    set query $argv
    
    # Special commands
    if test "$query" = "clear"; or test "$query" = "reset"
        set -e AUTOTERM_CONTEXT
        set -g AUTOTERM_QUERY ""
        set -g AUTOTERM_LAST_CMD ""
        echo
        echo "$AUTOTERM_COLOR_PROMPT🔄 Context cleared! Starting fresh.$AUTOTERM_COLOR_RESET"
        return
    end
    
    echo
    echo "$AUTOTERM_COLOR_PROMPT🤖 Generating command for: $AUTOTERM_COLOR_RESET$query"
    
    # Show context indicator
    if test (count $AUTOTERM_CONTEXT) -gt 0; or test -n "$AUTOTERM_LAST_CMD"
        set ctx_count (count $AUTOTERM_CONTEXT)
        if test -n "$AUTOTERM_LAST_CMD"
            set ctx_count (math $ctx_count + 1)
        end
        echo "$AUTOTERM_COLOR_HELP💭 Using context from $ctx_count previous command(s)$AUTOTERM_COLOR_RESET"
    end
    
    # Build context argument
    if test -n "$AUTOTERM_LAST_CMD"; and test -n "$AUTOTERM_QUERY"
        set already_in_context false
        for item in $AUTOTERM_CONTEXT
            if string match -q "*\"query\":\"$AUTOTERM_QUERY\"*" $item
                set already_in_context true
                break
            end
        end
        if test "$already_in_context" = false
            set -a AUTOTERM_CONTEXT "{\"query\":\"$AUTOTERM_QUERY\",\"command\":\"$AUTOTERM_LAST_CMD\"}"
        end
    end
    
    set context_arg ""
    if test (count $AUTOTERM_CONTEXT) -gt 0
        set context_json "["
        set first true
        for item in $AUTOTERM_CONTEXT
            if test "$first" = true
                set first false
            else
                set context_json "$context_json,"
            end
            set context_json "$context_json$item"
        end
        set context_json "$context_json]"
        set context_arg --context "$context_json"
    end
    
    # Call backend
    set cmd_output (python3 $AUTOTERM_CMD $query $context_arg 2>&1)
    set exit_code $status
    
    if test $exit_code -eq 0; and test -n "$cmd_output"
        set -g AUTOTERM_QUERY $query
        set -g AUTOTERM_LAST_CMD $cmd_output
        
        echo "$AUTOTERM_COLOR_CMD"Command: "$AUTOTERM_COLOR_RESET$cmd_output"
        echo "$AUTOTERM_COLOR_HELP"Execute? [y/N]" $AUTOTERM_COLOR_RESET"
        
        read -n 1 reply
        echo
        
        if string match -qi 'y' $reply
            eval $cmd_output
        else
            echo "Command cancelled"
        end
    else
        echo (set_color red --bold)"✗ Failed to generate command"(set_color normal)
        if test -n "$cmd_output"
            echo $cmd_output
        end
    end
end

# Main command interface
function autoterm
    if test (count $argv) -eq 0
        echo "Usage: autoterm <query>"
        echo "Example: autoterm find all python files"
        echo ""
        echo "Options:"
        echo "  autoterm --setup    Setup API key"
        echo "  autoterm --test     Test connection"
        echo "  autoterm --clear    Clear context history"
        echo "  autoterm --version  Show version"
        return 1
    end
    
    # Pass through options
    if test "$argv[1]" = "--setup"; or test "$argv[1]" = "--test"; or test "$argv[1]" = "--version"; or test "$argv[1]" = "--help"; or test "$argv[1]" = "--clear"
        python3 $AUTOTERM_CMD $argv
        # If clearing, also clear in-memory context
        if test "$argv[1]" = "--clear"
            set -e AUTOTERM_CONTEXT
            set -g AUTOTERM_QUERY ""
            set -g AUTOTERM_LAST_CMD ""
        end
        return $status
    end
    
    autoterm_generate $argv
end

# Alias for convenience
alias at='autoterm'

# Info message
echo "$AUTOTERM_COLOR_PROMPT🚀 AutoTerm loaded for fish!$AUTOTERM_COLOR_RESET"
echo "$AUTOTERM_COLOR_HELP"Usage: autoterm '<your query>'$AUTOTERM_COLOR_RESET
echo "$AUTOTERM_COLOR_HELP"Example: autoterm 'find all python files'$AUTOTERM_COLOR_RESET

