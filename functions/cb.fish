function cb --description "fish-cboard clipboard utility"

    if test (count $argv) -eq 0
        echo "usage: cb <copy|yank|paste|cwd|path>"
        return 1
    end


    set -l cmd $argv[1]
    set -e argv[1]


    switch $cmd

        case copy yank

            if test (count $argv) -gt 0

                if test -f "$argv[1]"
                    cat "$argv[1]" | fish_clipboard_copy
                else
                    string join " " $argv | fish_clipboard_copy
                end

            else

                if isatty stdin
                    echo "nothing to copy"
                    return 1
                end

                cat | fish_clipboard_copy

            end


        case paste

            argparse \
                "x/executable" \
                "f/force" \
                "e/edit" \
                "r/raw" \
                "trim-trailing" \
                "s/shebang=" \
                -- $argv

            or return


            if test (count $argv) -eq 0
                fish_clipboard_paste
                return
            end


            set -l file $argv[1]

            set -l data (fish_clipboard_paste)


            if not set -q _flag_raw

                set data (string replace -a \r "" "$data")


                if set -q _flag_trim_trailing
                    set data (string replace -r '[ \t]+$' '' "$data")
                end

            end


            if set -q _flag_shebang

                set data \
                    (__cb_shebang $_flag_shebang)"\n\n"$data

            end


            __cb_write "$file" "$data"
            or return


            if set -q _flag_executable

                chmod +x "$file"

            else if __cb_should_exec "$file"

                chmod +x "$file"

            end


            if set -q _flag_edit

                if set -q EDITOR
                    $EDITOR "$file"
                else
                    vi "$file"
                end

            end


        case cwd

            if test (count $argv) -eq 0
                pwd | fish_clipboard_copy
            else
                realpath "$argv[1]" | fish_clipboard_copy
            end


        case path

            if test (count $argv) -eq 0
                pwd | fish_clipboard_copy
            else
                realpath "$argv[1]" | fish_clipboard_copy
            end


        case '*'

            echo "unknown command: $cmd"
            return 1

    end
end