function __cb_confirm --description "Ask before overwrite"

    set -l file $argv[1]

    read -P "$file exists. overwrite? [y/N] " answer

    switch $answer
        case y Y yes YES
            return 0

        case '*'
            return 1
    end
end