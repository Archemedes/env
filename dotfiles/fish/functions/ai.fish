set -gx OPENAI_API_KEY (pass api/openai)
set -gx ANTHROPIC_API_KEY (pass api/anthropic)

set -g _ai_system_prompt (cat $__fish_config_dir/functions/system_prompt)

function ai --description "Send a prompt to Claude"
    argparse 'm/model=' 's/system=' 'c/chat' 'n/nochat' 'h/history=?' -- $argv; or return
    set -q _flag_model; or set _flag_model claude-4-sonnet-20250514
    set -q _flag_system; or set _flag_system $_ai_system_prompt

    # Handle history flag: if -h is used without parameter, default to 'last_non_empty_output'
    if set -q _flag_history; and test -z "$_flag_history"
        set _flag_history last_non_empty_output
    end

    set prompt (string join " " $argv)
    # if not isatty stdin
    #     while read -l line; set -a prompt $line; end
    #     set prompt (string join \n $prompt)
    # else
    #     set prompt (string join " " $argv)
    # end

    test -n "$prompt"; or begin; echo "Usage: ai [-m/--model MODEL] [-s/--system SYSTEM] [-h/--history] <prompt>"; return 1; end

    if set -q _flag_history
        set shell_history (kitty @ get-text --extent=$_flag_history)
        set prompt "$prompt\n\nFor context, this is the recent output of the terminal session:\n$shell_history"
    end

    set -q _flag_chat || set -q _flag_nochat || set -U _ai_history
    set history_json "[$_ai_history]"
    set jq_args --arg model "$_flag_model" --arg system "$_flag_system" --argjson history $history_json
    set jq_filter '{"model":$model,"max_tokens":4096,"system":$system,"messages":($history + [{"role":"user","content":.}])}'

    set response (echo $prompt | jq -Rs $jq_args $jq_filter \
        | curl -s https://api.anthropic.com/v1/messages \
        -H "x-api-key: $ANTHROPIC_API_KEY" -H "anthropic-version: 2023-06-01" -H "content-type: application/json" \
        -d @- | jq -r '.content[0].text')

    if not set -q _flag_nochat
        set new_exchange (printf '{"role":"user","content":%s},{"role":"assistant","content":%s}' (echo $prompt | jq -Rs .) (echo $response | jq -Rs .))
        set -U _ai_history (test -n "$_ai_history"; and echo "$_ai_history,$new_exchange"; or echo $new_exchange)
    end

    printf '%s\n' $response
end
