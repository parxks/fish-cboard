function __cb_write --description "Safely write clipboard"

    set -l file $argv[1]
    set -l content $argv[2]

    if test -e "$file"

        if not __cb_confirm "$file"
            echo "aborted"
            return 1
        end
    end


    set -l parent (dirname "$file")

    if test "$parent" != "."
        mkdir -p "$parent"
    end


    printf "%s\n" "$content" > "$file"
end