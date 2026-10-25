# LLM Context for 

Generated on: 2026-08-05 22:51:06  
Repository: `.`  
Total files: 14

---

## Table of Contents

1. [README.md](#readmemd)
2. [completions/cb.fish](#completionscbfish)
3. [conf.d/fish-cboard.fish](#confdfish-cboardfish)
4. [functions/__cb_confirm.fish](#functions__cb_confirmfish)
5. [functions/__cb_normalize.fish](#functions__cb_normalizefish)
6. [functions/__cb_shebang.fish](#functions__cb_shebangfish)
7. [functions/__cb_should_exec.fish](#functions__cb_should_execfish)
8. [functions/__cb_write.fish](#functions__cb_writefish)
9. [functions/cb.fish](#functionscbfish)
10. [functions/cbc.fish](#functionscbcfish)
11. [functions/cbcwd.fish](#functionscbcwdfish)
12. [functions/cbp.fish](#functionscbpfish)
13. [functions/cbpath.fish](#functionscbpathfish)
14. [functions/cby.fish](#functionscbyfish)

## README.md

```markdown
# fish-cboard

A small Fish clipboard workflow utility.

Requires:

- Fish >= 3.6
- fish_clipboard_copy
- fish_clipboard_paste

## Commands

### Copy

    cb copy file.txt

or:

    cat file.txt | cb copy


### Paste

stdout:

    cb paste

file:

    cb paste script.fish


## Options

### Executable

    cb paste -x script.sh


### Shebang

    cb paste -s fish script.fish


### Editor

    cb paste -e script.fish


### Force overwrite

    cb paste -f file


## Short aliases

    cby       -> cb yank
    cbp       -> cb paste
    cbc       -> cb copy
    cbcwd     -> cb cwd
    cbpath    -> cb path


## Examples

Create executable Fish script:

    cby -s fish -x install.fish


Copy current directory:

    cbcwd


Copy absolute path:

    cbpath ./file.txt
```

## completions/cb.fish

```fish
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
```

## conf.d/fish-cboard.fish

```fish
# fish-cboard initialization

# Ensure aliases are loaded when installed through Fisher.
# The actual implementation lives in functions/cb.fish.

if not type -q fish_clipboard_copy
    echo "fish-cboard: fish_clipboard_copy not found"
end

if not type -q fish_clipboard_paste
    echo "fish-cboard: fish_clipboard_paste not found"
end
```

## functions/__cb_confirm.fish

```fish
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
```

## functions/__cb_normalize.fish

```fish
function __cb_normalize --description "Normalize clipboard text"

    set -l input $argv

    # Convert CRLF/CR to LF
    set input (string replace -a \r "" "$input")

    # Always ensure one newline at end
    printf "%s\n" "$input"
end
```

## functions/__cb_shebang.fish

```fish
function __cb_shebang --description "Generate shebang"

    switch $argv[1]

        case fish
            echo '#!/usr/bin/env fish'

        case bash sh
            echo '#!/usr/bin/env bash'

        case python py
            echo '#!/usr/bin/env python'

        case node
            echo '#!/usr/bin/env node'

        case '*'
            return 1
    end
end
```

## functions/__cb_should_exec.fish

```fish
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
```

## functions/__cb_write.fish

```fish
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
```

## functions/cb.fish

```fish
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
```

## functions/cbc.fish

```fish
function cbc
    cb copy $argv
end
```

## functions/cbcwd.fish

```fish
function cbcwd
    cb cwd $argv
end
```

## functions/cbp.fish

```fish
function cbp
    cb paste $argv
end
```

## functions/cbpath.fish

```fish
function cbpath
    cb path $argv
end
```

## functions/cby.fish

```fish
function cby
    cb yank $argv
end
```