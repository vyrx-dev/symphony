#!/bin/bash

# Cleanup script for theme system
# Removes unused starship directories and test files

echo "🧹 Theme System Cleanup"
echo ""

# 1. Remove unused starship/ directories (old color system)
echo "Removing unused starship/ color directories..."
for theme in ~/dotfiles/themes/*/; do
    if [ -d "$theme/.config/starship" ]; then
        theme_name=$(basename "$theme")
        echo "  - Removing $theme_name/.config/starship/"
        rm -rf "$theme/.config/starship"
    fi
done

# 2. Remove unused base starship files
echo ""
echo "Removing unused base starship files..."
if [ -f ~/dotfiles/.config/starship.toml ]; then
    echo "  - Removing ~/dotfiles/.config/starship.toml"
    rm ~/dotfiles/.config/starship.toml
fi
if [ -f ~/dotfiles/.config/starship-base.toml ]; then
    echo "  - Removing ~/dotfiles/.config/starship-base.toml"
    rm ~/dotfiles/.config/starship-base.toml
fi

# 3. Remove test file
echo ""
echo "Removing test files..."
if [ -f ~/themes/test-starship-colors.sh ]; then
    echo "  - Removing test-starship-colors.sh"
    rm ~/themes/test-starship-colors.sh
fi

# 4. Remove old migration/setup scripts (keep active ones)
echo ""
echo "Removing old migration/setup scripts..."
OLD_SCRIPTS=(
    "add-new-theme.sh"
    "complete-fix.sh"
    "debug-stow.sh"
    "fix-monochrome.sh"
    "fix-stow-monochrome.sh"
    "properly-stow-monochrome.sh"
    "rename-sacrifice.sh"
    "rename-themes.sh"
    "reorganize-hypr-theme.sh"
    "restore-monochrome-hypr.sh"
    "restow-monochrome.sh"
    "restow-theme.sh"
    "setup-theme-system.sh"
    "migrate-flat-theme.sh"
    "update-theme-structure.sh"
    "matugen-post-hook.sh"
)

for script in "${OLD_SCRIPTS[@]}"; do
    if [ -f ~/themes/"$script" ]; then
        echo "  - Removing $script"
        rm ~/themes/"$script"
    fi
done

# 5. Remove matugen rmpc backup (no longer needed)
echo ""
echo "Removing matugen rmpc backup..."
if [ -f ~/dotfiles/themes/matugen/.config/rmpc/themes/theme.ron ]; then
    echo "  - Removing matugen rmpc backup file"
    rm ~/dotfiles/themes/matugen/.config/rmpc/themes/theme.ron
    rmdir ~/dotfiles/themes/matugen/.config/rmpc/themes 2>/dev/null
    rmdir ~/dotfiles/themes/matugen/.config/rmpc 2>/dev/null
fi

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "📋 What was removed:"
echo "  - Unused starship/ directories (old color system)"
echo "  - Unused base starship config files"
echo "  - Test files"
echo "  - Old migration/setup scripts"
echo "  - Matugen rmpc backup directory"
echo ""
echo "🎯 Active scripts remaining:"
echo "  - switch-theme.sh (main theme switcher)"
echo "  - fix-symlinks.sh (fixes broken symlinks)"
echo "  - update-cava-colors.sh (updates cava)"
echo "  - update-rmpc-theme.sh (updates rmpc)"
echo "  - create-*.sh (generators for configs)"
echo "  - patch-wallpaper-scripts.sh (wallpaper integration)"
echo ""
