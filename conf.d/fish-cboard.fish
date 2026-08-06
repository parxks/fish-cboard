# fish-cboard initialization

# Ensure aliases are loaded when installed through Fisher.
# The actual implementation lives in functions/cb.fish.

if not type -q fish_clipboard_copy
    echo "fish-cboard: fish_clipboard_copy not found"
end

if not type -q fish_clipboard_paste
    echo "fish-cboard: fish_clipboard_paste not found"
end