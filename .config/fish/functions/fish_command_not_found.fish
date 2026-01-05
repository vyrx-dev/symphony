# Custom fish_command_not_found function
# Prevents infinite loop when pkgfile is not installed

function fish_command_not_found
    # Simple error message without pkgfile dependency
    echo "fish: Unknown command: $argv[1]" >&2
    return 127
end

