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