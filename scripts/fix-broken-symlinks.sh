#!/usr/bin/env bash

# Script pour réparer les symlinks cassés après la suppression de ~/dotfiles
# Usage: bash ~/Documents/github/dotfiles/scripts/fix-broken-symlinks.sh
# Ou: chmod +x ~/Documents/github/dotfiles/scripts/fix-broken-symlinks.sh && ~/Documents/github/dotfiles/scripts/fix-broken-symlinks.sh

HOME_DIR="$HOME"
REPO_DIR="$HOME/Documents/github/dotfiles"

echo "🔧 Réparation des symlinks cassés..."

# Liste des symlinks à recréer dans le home
SYMLINKS=(
    "themes:Documents/github/dotfiles/themes"
    "theme-scripts:Documents/github/dotfiles/theme-scripts"
    "assets:Documents/github/dotfiles/assets"
    "branding:Documents/github/dotfiles/branding"
    "TODO.md:Documents/github/dotfiles/TODO.md"
)

for symlink_info in "${SYMLINKS[@]}"; do
    IFS=':' read -r name target <<< "$symlink_info"
    symlink_path="$HOME_DIR/$name"
    target_path="$HOME_DIR/$target"
    
    # Vérifier si le symlink existe et est cassé
    if [ -L "$symlink_path" ]; then
        if [ ! -e "$symlink_path" ]; then
            echo "🔗 Suppression du symlink cassé: $name"
            rm "$symlink_path"
        else
            current_target=$(readlink -f "$symlink_path")
            expected_target=$(readlink -f "$target_path")
            if [ "$current_target" != "$expected_target" ]; then
                echo "🔗 Mise à jour du symlink: $name"
                rm "$symlink_path"
            else
                echo "✅ $name est déjà correct"
                continue
            fi
        fi
    fi
    
    # Créer le nouveau symlink
    if [ ! -e "$symlink_path" ] && [ -e "$target_path" ]; then
        echo "✅ Création du symlink: $name -> $target"
        ln -s "$target" "$symlink_path"
    elif [ ! -e "$target_path" ]; then
        echo "⚠️  La cible n'existe pas: $target_path"
    fi
done

# Vérifier les symlinks dans ~/.config qui pourraient être cassés
echo ""
echo "🔍 Vérification des symlinks dans ~/.config..."

find "$HOME/.config" -type l ! -exec test -e {} \; -print 2>/dev/null | while read -r broken_link; do
    echo "⚠️  Symlink cassé trouvé: $broken_link"
    # Essayer de le réparer si c'est un lien vers l'ancien dotfiles
    current_target=$(readlink "$broken_link" 2>/dev/null)
    if [[ "$current_target" == *"dotfiles"* ]] && [[ "$current_target" != *"Documents/github/dotfiles"* ]]; then
        new_target=$(echo "$current_target" | sed 's|dotfiles|Documents/github/dotfiles|g')
        if [ -e "$new_target" ]; then
            echo "   Réparation: $broken_link -> $new_target"
            rm "$broken_link"
            ln -s "$new_target" "$broken_link"
        else
            echo "   ⚠️  La cible n'existe pas: $new_target"
        fi
    fi
done

# Supprimer les fichiers de verrouillage Vesktop qui sont des symlinks cassés
echo ""
echo "🔧 Nettoyage des fichiers de verrouillage Vesktop..."
for lock_file in "$HOME/.config/vesktop/SingletonLock" "$HOME/.config/vesktop/SingletonCookie"; do
    if [ -L "$lock_file" ] && [ ! -e "$lock_file" ]; then
        echo "   Suppression du symlink cassé: $(basename "$lock_file")"
        rm -f "$lock_file"
    fi
done

# Recréer les symlinks du thème actuel
echo ""
echo "🎨 Recréation des symlinks du thème actuel..."
CURRENT_THEME=$(cat ~/.config/symphony/.current-theme 2>/dev/null || cat ~/.current-theme 2>/dev/null || echo "matugen")
echo "   Thème actuel: $CURRENT_THEME"

# Réparer starship.toml si cassé
if [ -L "$HOME/.config/starship.toml" ] && [ ! -e "$HOME/.config/starship.toml" ]; then
    echo "   🔧 Réparation de starship.toml..."
    rm -f "$HOME/.config/starship.toml"
    if [ "$CURRENT_THEME" != "matugen" ] && [ -f "$HOME/Documents/github/dotfiles/themes/$CURRENT_THEME/.config/starship.toml" ]; then
        ln -sf "$HOME/Documents/github/dotfiles/themes/$CURRENT_THEME/.config/starship.toml" "$HOME/.config/starship.toml"
        echo "   ✅ starship.toml réparé"
    elif [ -f "$HOME/.config/symphony/current/.config/starship.toml" ]; then
        ln -sf "$HOME/.config/symphony/current/.config/starship.toml" "$HOME/.config/starship.toml"
        echo "   ✅ starship.toml réparé"
    else
        echo "   ⚠️  Pas de starship.toml pour le thème $CURRENT_THEME"
    fi
fi

# Réparer vesktop midnight-discord.css si cassé
if [ -L "$HOME/.config/vesktop/themes/midnight-discord.css" ] && [ ! -e "$HOME/.config/vesktop/themes/midnight-discord.css" ]; then
    echo "   🔧 Réparation de vesktop midnight-discord.css..."
    mkdir -p "$HOME/.config/vesktop/themes"
    rm -f "$HOME/.config/vesktop/themes/midnight-discord.css"
    if [ "$CURRENT_THEME" = "matugen" ] && [ -f "$HOME/.config/symphony/current/.config/vesktop/themes/midnight-discord.css" ]; then
        ln -sf "$HOME/.config/symphony/current/.config/vesktop/themes/midnight-discord.css" "$HOME/.config/vesktop/themes/midnight-discord.css"
        echo "   ✅ vesktop midnight-discord.css réparé"
    elif [ -f "$HOME/Documents/github/dotfiles/themes/$CURRENT_THEME/.config/vesktop/themes/midnight-discord.css" ]; then
        ln -sf "$HOME/Documents/github/dotfiles/themes/$CURRENT_THEME/.config/vesktop/themes/midnight-discord.css" "$HOME/.config/vesktop/themes/midnight-discord.css"
        echo "   ✅ vesktop midnight-discord.css réparé"
    else
        echo "   ⚠️  Pas de vesktop theme pour le thème $CURRENT_THEME"
    fi
fi

# Exécuter fix-symlinks.sh pour recréer tous les autres symlinks
if [ -f "$HOME/Documents/github/dotfiles/theme-scripts/core/fix-symlinks.sh" ]; then
    bash "$HOME/Documents/github/dotfiles/theme-scripts/core/fix-symlinks.sh" 2>&1 | grep -v "^✅" | grep -v "^Symlinks fixed"
else
    echo "   ⚠️  Script fix-symlinks.sh non trouvé"
fi

echo ""
echo "✅ Réparation terminée!"
echo ""
echo "💡 Si vous avez encore des erreurs:"
echo "   1. Rechargez votre shell: source ~/.config/fish/config.fish"
echo "   2. Redémarrez waybar: killall waybar && waybar &"
echo "   3. Ou redémarrez Hyprland"

