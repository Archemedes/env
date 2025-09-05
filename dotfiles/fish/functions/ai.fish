complete -c ai -s m -l model -xa "claude-3-5-haiku-latest claude-sonnet-4-0 claude-opus-4-1"
complete -c ai -s h -l history -xa "(complete -C'kitty @ get-text --extent=' | sed 's/--extent=//')"
complete -c ai -s H -l allhistory -d "Include all terminal history as context"
complete -c ai -s s -l system -xa "(ls $__fish_config_dir/prompts/ 2>/dev/null)"
complete -c ai -s d -l debug -d "Show raw API response for debugging"
complete -c ai -s c -l chat -d "Continue the conversation from the previous message"
complete -c ai -s n -l nochat -d "Message will not start a new conversation"
complete -c ai -s p -l print-history -d "Display current conversation history and exit"
complete -c ai -l completion -d "Prefill assistant response with specified text"
complete -c ai -l max-tokens -d "Maximum tokens in response (default: 4096)"

function ai --description "Send a prompt to Claude"
    argparse 'd/debug' 'm/model=' 's/system=' 'c/chat' 'n/nochat' \
             'h/history=?' 'H/allhistory' 'completion=' 'max-tokens=' 'p/print-history' -- $argv; or return
    set -q _flag_model; or set _flag_model claude-4-sonnet-20250514
    set -q _flag_system; or set _flag_system system_prompt
    set _flag_system (cat $__fish_config_dir/prompts/$_flag_system)
    set -q _flag_max_tokens; or set _flag_max_tokens 4096

    if set -q _flag_print_history
        _ai_print_history
        return
    end

    # Handle history flag: if -h is used without parameter, default to 'last_non_empty_output'
    if set -q _flag_history; and test -z "$_flag_history"
        set _flag_history last_non_empty_output
    end
 
    # Handle full history flag: -H sets extent to 'all'
    if set -q _flag_allhistory
        set _flag_history all
    end

    set prompt (string join " " $argv)
    if not isatty stdin
        set piped_input; while read -l line; set -a piped_input $line; end
        set prompt "$prompt\n\nHere is some context from piped input:\n\n"(string join \n -- $piped_input)
    end

    test -n "$prompt"; or begin; echo "Usage: ai [-m/--model MODEL] [-s/--system SYSTEM] [-h/--history] [-H/--fullhistory] <prompt>"; return 1; end

    if set -q _flag_history
        set shell_history (kitty @ get-text --extent=$_flag_history)
        set prompt "$prompt\n\nFor context, this is the recent output of the terminal session:\n$shell_history"
    end

    set -q _flag_chat || set -q _flag_nochat || set -U _ai_history
    if set -q _flag_nochat
        set history_json "[]"
    else 
        set history_json "[$_ai_history]"
    end
    set jq_args --arg model "$_flag_model" --arg system "$_flag_system" --arg max_tokens "$_flag_max_tokens" --argjson history $history_json
    if set -q _flag_completion
        set jq_args $jq_args --arg completion "$_flag_completion"
        set jq_filter '{"model":$model,"max_tokens":($max_tokens|tonumber),"system":$system,"messages":($history + [{"role":"user","content":.},{"role":"assistant","content":$completion}])}'
    else
        set jq_filter '{"model":$model,"max_tokens":($max_tokens|tonumber),"system":$system,"messages":($history + [{"role":"user","content":.}])}'
    end

    set raw_response (echo $prompt | jq -Rs $jq_args $jq_filter \
        | curl -s https://api.anthropic.com/v1/messages \
        -H "x-api-key: $(passage api/anthropic)" -H "anthropic-version: 2023-06-01" -H "content-type: application/json" -d @-)
    set response (echo $raw_response | jq -r '.content[0].text')

    if not set -q _flag_nochat
        set new_exchange (printf '{"role":"user","content":%s},{"role":"assistant","content":%s}' (echo $prompt | jq -Rs .) (echo $raw_response | jq -r '.content[0].text' | jq -Rs .))
        set -U _ai_history (test -n "$_ai_history"; and echo "$_ai_history,$new_exchange"; or echo $new_exchange)
    end

    if not set -q response; or test "$response" = null; or set -q _flag_debug
        echo $raw_response | jq
    end
    printf '%s\n' $response
end

function _ai_print_history
    if test -n "$_ai_history"
        echo "[$_ai_history]" | jq -c '.[]' | while read -l entry
            set role (echo $entry | jq -r '.role')
            if test "$role" = "user"
                set_color green
                echo -n "❯ "
            else
                set_color blue
            end
            echo $entry | jq -r '.content'
        end
    else
        echo "No conversation history."
    end
end
