set -gx OPENAI_API_KEY (passage api/openai)
set -gx ANTHROPIC_API_KEY (passage api/anthropic)

set -g _ai_system_prompt (cat $__fish_config_dir/prompts/system_prompt)

complete -c ai -s m -l model -xa "claude-3-5-haiku-latest claude-sonnet-4-0 claude-opus-4-0"
complete -c ai -s h -l history -xa "(complete -C'kitty @ get-text --extent=' | sed 's/--extent=//')"

function ai --description "Send a prompt to Claude"
    argparse 'd/debug' 'm/model=' 's/system=' 'c/chat' 'n/nochat' \
             'h/history=?' 'completion=' 'max-tokens=' -- $argv; or return
    set -q _flag_model; or set _flag_model claude-4-sonnet-20250514
    set -q _flag_system; or set _flag_system $_ai_system_prompt
    set -q _flag_max_tokens; or set _flag_max_tokens 4096

    # Handle history flag: if -h is used without parameter, default to 'last_non_empty_output'
    if set -q _flag_history; and test -z "$_flag_history"
        set _flag_history last_non_empty_output
    end

    # Handle piped input as context
    if not isatty stdin
        set piped_input
        while read -l line
            set -a piped_input $line
        end
        set piped_context (string join \n $piped_input)
        set prompt (string join " " $argv)"\n\nHere is some context from piped input:\n\n"$piped_context
    else
        set prompt (string join " " $argv)
    end

    test -n "$prompt"; or begin; echo "Usage: ai [-m/--model MODEL] [-s/--system SYSTEM] [-h/--history] <prompt>"; return 1; end

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
        -H "x-api-key: $ANTHROPIC_API_KEY" -H "anthropic-version: 2023-06-01" -H "content-type: application/json" -d @-)
    set response (echo $raw_response | jq -r '.content[0].text')

    if not set -q _flag_nochat
        set new_exchange (printf '{"role":"user","content":%s},{"role":"assistant","content":%s}' (echo $prompt | jq -Rs .) (echo $response | jq -Rs .))
        set -U _ai_history (test -n "$_ai_history"; and echo "$_ai_history,$new_exchange"; or echo $new_exchange)
    end

    if not set -q response; or test "$response" = null; or set -q _flag_debug
        echo $raw_response | jq
    end
    printf '%s\n' $response
end
