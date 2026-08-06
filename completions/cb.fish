complete -c cb -f

complete -c cb \
    -n "not __fish_seen_subcommand_from copy yank paste cwd path" \
    -a "copy yank paste cwd path"

complete -c cb -n "__fish_seen_subcommand_from paste" \
    -l executable -s x \
    -d "make executable"

complete -c cb -n "__fish_seen_subcommand_from paste" \
    -l force -s f \
    -d "overwrite without prompt"

complete -c cb -n "__fish_seen_subcommand_from paste" \
    -l edit -s e \
    -d "open editor after writing"

complete -c cb -n "__fish_seen_subcommand_from paste" \
    -l raw -s r \
    -d "disable normalization"

complete -c cb -n "__fish_seen_subcommand_from paste" \
    -l trim-trailing \
    -d "remove trailing whitespace"

complete -c cb -n "__fish_seen_subcommand_from paste" \
    -l shebang -s s \
    -a "fish bash python node"