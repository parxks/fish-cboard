function __cb_normalize --description "Normalize clipboard text"

    set -l input $argv

    # Convert CRLF/CR to LF
    set input (string replace -a \r "" "$input")

    # Always ensure one newline at end
    printf "%s\n" "$input"
end