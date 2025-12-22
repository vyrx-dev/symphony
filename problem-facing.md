# Installer Bug: Script exits during themes/install.sh

## FIXED: desktop-entries.sh issue
The `((count++))` when count=0 returned exit code 1 with `set -e`. Fixed by using `count=$((count + 1))` instead.

---

## Current Problem: themes/install.sh exits after "Setting Up Directories"

### Symptoms
1. Script reaches themes section
2. Shows "Setting Up Directories" heading  
3. Exits immediately without completing

### Location
File: `install/themes/install.sh`
Lines 197-202:
```bash
# Setting Up Directories
heading "Setting Up Directories"

spin "Creating config structure" bash -c "mkdir -p '$SYMPHONY_DIR' '$HOME/.config/rmpc/themes' '$HOME/.cache/wal'"
spin "Setting permissions" bash -c "chmod +x '$SCRIPT_DIR'/symphony '$SCRIPT_DIR'/hooks/*.sh 2>/dev/null || true"
info_line "Directories and scripts ready"
```

### Suspect Areas
1. **Line 200**: `spin` function might return non-zero if `gum spin` fails
2. **Line 201**: chmod command - although it has `|| true` inside the bash -c
3. The `spin` function in utils.sh doesn't have `return 0` at the end

### The spin function (install/utils.sh)
```bash
spin() {
    local msg="$1"
    shift
    if [[ $HAS_GUM -eq 1 ]]; then
        gum spin --spinner dot --title "  $msg" -- "$@"
    else
        info "$msg"
        "$@" >/dev/null 2>&1
    fi
}
```
No `return 0` at end - passes through command exit code.

### Debug Commands
```bash
# Run themes script directly with tracing
cd ~/dotfiles && bash --norc -x install/themes/install.sh 2>&1 | grep -A5 "Setting Up"

# Test spin function
cd ~/dotfiles && bash --norc -c '
source install/utils.sh
spin "test" bash -c "mkdir -p /tmp/test123"
echo "exit: $?"
'
```

### Proposed Fix
Add `|| true` or `return 0` to spin function, or wrap the spin calls in the themes script.
