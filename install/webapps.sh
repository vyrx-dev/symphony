#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Web Apps Installer  |-/ /--|#
#|/ /---+---------------------+/ /---|#
set -e
# Predefined webapps: "Name|URL|Icon"
# Icons from https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/
WEBAPPS=(
	"GitHub|https://github.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/github.png"
	"YouTube|https://youtube.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/youtube.png"
	"Reddit|https://www.reddit.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/reddit.png"
	"WhatsApp|https://web.whatsapp.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/whatsapp.png"
	"ChatGPT|https://chatgpt.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/chatgpt.png"
	"Perplexity|https://perplexity.ai/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/perplexity.png"
	"Gmail|https://mail.google.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png"
	"Google Photos|https://photos.google.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/google-photos.png"
	"Google Meet|https://meet.google.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/google-meet.png"
	"Google Drive|https://drive.google.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-drive.png"
	"Todoist|https://todoist.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/todoist.png"
	"Calendar|https://calendar.google.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-calendar.png"
	"LinkedIn|https://www.linkedin.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/linkedin.png"
	"Pinterest|https://www.pinterest.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/pinterest.png"
	"Figma|https://figma.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/figma.png"
	"Notion|https://notion.so/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/notion.png"
	"Twitter|https://x.com/|https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/twitter.png"
	"DownGit|https://downgit.github.io/#/home|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/synology-download-station.png"
	"Wallhaven|https://wallhaven.cc/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/ward.png"
	"Gemini|https://gemini.google.com/app|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-gemini.png"
	"Qobuz|https://www.qobuz.com/us-en/shop|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/questdb.png"
	"Excalidraw|https://excalidraw.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/excalidraw.png"
	"Discord|https://discord.com/channels/@me|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/discord.png"
	"Spotify|https://open.spotify.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/spotify.png"
	"Hotstar|https://www.hotstar.com/in/home|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/jiohotstar.png"
	"Netflix|https://www.netflix.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/netflix.png"
	"AUR|https://aur.archlinux.org/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/arch-linux.png"
	"YouTube Music|https://music.youtube.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/youtube-music.png"
)

WEBAPP_INSTALL="$HOME/.local/bin/webapp-install"
APPS_DIR="$HOME/.local/share/applications"

is_installed() {
	local name="$1"
	[[ -f "$APPS_DIR/$name.desktop" ]]
}

install_webapps() {
	# Build selection list with install status
	local options=()
	local names=()
	for entry in "${WEBAPPS[@]}"; do
		IFS='|' read -r name url icon <<<"$entry"
		names+=("$name")
		if is_installed "$name"; then
			options+=("$name (installed)")
		else
			options+=("$name")
		fi
	done

	echo -e "\n\033[1mSelect web apps to install:\033[0m\n"

	selected=$(printf '%s\n' "${options[@]}" | gum choose --no-limit \
		--cursor="› " \
		--cursor-prefix="○ " \
		--selected-prefix="● " \
		--unselected-prefix="○ " \
		--header "Space to select, Enter to confirm") || true

	[[ -z "$selected" ]] && {
		echo "No apps selected."
		return
	}

	while IFS= read -r choice; do
		name="${choice% (installed)}"

		for entry in "${WEBAPPS[@]}"; do
			IFS='|' read -r n url icon <<<"$entry"
			if [[ "$n" == "$name" ]]; then
				if is_installed "$name"; then
					echo -e "\033[33m○\033[0m $name (already installed)"
				else
					"$WEBAPP_INSTALL" "$name" "$url" "$icon" &&
						echo -e "\033[32m✓\033[0m $name" ||
						echo -e "\033[31m✗\033[0m $name (failed)"
				fi
				break
			fi
		done
	done <<<"$selected"

	echo -e "\nDone! Apps available in launcher (Super + Space)"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && install_webapps || true
