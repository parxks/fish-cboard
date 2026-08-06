function __cb_should_exec --description "Detect executable scripts"

    set -l file $argv[1]

    set -l ext (string match -r '\.[^.]+$' "$file")

    if not contains "$ext" ".sh" ".fish" ".py" ".rb" ".pl"
        return 1
    end

    if test -f "$file"
        head -n1 "$file" | string match -q '#!*'
        return $status
    end

    return 1
end