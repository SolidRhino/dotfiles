function __fish_opencode_completions --description "Completions for opencode via yargs"
    set -l args (commandline -opc)

    # Drop command name so only args/subcommands are forwarded.
    set -e args[1]

    command opencode --get-yargs-completions $args 2>/dev/null | string match -v '$0'
end

complete -c opencode -e
complete -c opencode -f -a '(__fish_opencode_completions)'
