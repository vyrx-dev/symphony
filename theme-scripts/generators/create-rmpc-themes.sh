#!/bin/bash

# Script to create rmpc theme files for all themes based on their kitty colors.conf
# Uses simple, harmonious colors - mostly bg/fg with one accent color

THEMES_DIR="$HOME/dotfiles/themes"
THEMES=(
    "zen"
    "carnage"
    "aamis"
    "gruvbox-material"
    "osaka-jade"
    "rose-pine"
    "sakura"
    "tokyo-night"
    "void"
)

extract_kitty_color() {
    local file=$1
    local color_name=$2
    grep "^${color_name}" "$file" | awk '{print $2}' | head -1
}

create_rmpc_theme() {
    local theme=$1
    local colors_file="$THEMES_DIR/$theme/.config/kitty/colors.conf"
    
    if [ ! -f "$colors_file" ]; then
        echo "⚠️  No colors.conf found for $theme"
        return
    fi
    
    # Extract colors - using simple palette
    local bg=$(extract_kitty_color "$colors_file" "background")
    local fg=$(extract_kitty_color "$colors_file" "foreground")
    
    # Get one nice accent color (color4 = blue, usually a good accent)
    local accent=$(extract_kitty_color "$colors_file" "color4")
    
    # Get muted colors for borders and secondary elements
    local dim=$(extract_kitty_color "$colors_file" "color8")  # dim/gray
    local secondary=$(extract_kitty_color "$colors_file" "color3")  # yellow, good for secondary
    
    # Fallbacks in case colors are missing
    [ -z "$bg" ] && bg="#000000"
    [ -z "$fg" ] && fg="#ffffff"
    [ -z "$accent" ] && accent="$fg"
    [ -z "$dim" ] && dim="$fg"
    [ -z "$secondary" ] && secondary="$accent"
    
    # Create the theme directory if it doesn't exist
    mkdir -p "$THEMES_DIR/$theme/.config/rmpc/themes"
    
    # Create the theme file with harmonious, simple colors
    cat > "$THEMES_DIR/$theme/.config/rmpc/themes/theme.ron" << EOF
#![enable(implicit_some)]
#![enable(unwrap_newtypes)]
#![enable(unwrap_variant_newtypes)]
(
    default_album_art_path: None,
    show_song_table_header: false,
    draw_borders: true,
    browser_column_widths: [20, 38, 42],
    text_color: "$fg",
    tab_bar: (
        enabled: true,
        active_style: (fg: "$fg", bg: "$bg", modifiers: "Bold"),
        inactive_style: (fg: "$dim", modifiers: ""),
    ),
    highlighted_item_style: (fg: "$accent", modifiers: "Bold"),
    current_item_style: (fg: "$bg", bg: "$accent", modifiers: "Bold"),
    borders_style: (fg: "$dim", modifiers: ""),
    highlight_border_style: (fg: "$accent"),
    symbols: (song: "󰝚 ", dir: " ", marker: "* ", ellipsis: "..."),
    progress_bar: (
        symbols: ["█", "█", "█"],
        track_style: (fg: "$dim"),
        elapsed_style: (fg: "$accent"),
        thumb_style: (fg: "$accent"),
    ),
    scrollbar: (
        symbols: ["", "", "", ""],
        track_style: (fg: "$dim"),
        ends_style: (fg: "$dim"),
        thumb_style: (fg: "$accent"),
    ),
    song_table_format: [
        (
            prop: (kind: Property(Title), style: (fg: "$fg"),
                highlighted_item_style: (fg: "$bg", modifiers: "Bold"),
                default: (kind: Property(Filename), style: (fg: "$dim"),)
            ),
            width: "70%",
        ),
        (
            prop: (kind: Property(Album), style: (fg: "$dim"),
                default: (kind: Text("Unknown Album"), style: (fg: "$dim"))
            ),
            width: "30%",
        ),
    ],
    layout: Split(
        direction: Vertical,
        panes: [
            (
                size: "3",
                pane: Pane(Tabs),
            ),
            (
                size: "4",
                pane: Split(
                    direction: Horizontal,
                    panes: [
                        (
                            size: "100%",
                            pane: Split(
                                direction: Vertical,
                                panes: [
                                    (
                                        size: "4",
                                        borders: "ALL",
                                        pane: Pane(Header),
                                    ),
                                ]
                            )
                        ),
                    ]
                ),
            ),
            (
                size: "100%",
                pane: Split(
                    direction: Horizontal,
                    panes: [
                        (
                            size: "100%",
                            borders: "NONE",
                            pane: Pane(TabContent),
                        ),
                    ]
                ),
            ),
            (
                size: "3",
                borders: "TOP | BOTTOM",
                pane: Pane(ProgressBar),
            ),
        ],
    ),
    header: (
        rows: [
            (
                left: [
                    (kind: Property(Status(StateV2(playing_label: " ", paused_label: "❚❚", stopped_label: "❚❚"))), style: (fg: "$accent", modifiers: "Bold")),
                ],
                center: [
                    (kind: Property(Song(Title)), style: (fg: "$fg", modifiers: "Bold"),
                        default: (kind: Property(Song(Filename)), style: (fg: "$fg", modifiers: "Bold"))
                    )
                ],
                right: [
                    (kind: Text("Vol: "), style: (fg: "$accent", modifiers: "Bold")),
                    (kind: Property(Status(Volume)), style: (fg: "$accent", modifiers: "Bold")),
                    (kind: Text("% "), style: (fg: "$accent", modifiers: "Bold"))
                ]
            ),
            (
                left: [
                    (kind: Property(Status(Elapsed)), style: (fg: "$fg")),
                    (kind: Text("/"), style: (fg: "$dim")),
                    (kind: Property(Status(Duration)), style: (fg: "$fg")),
                ],
                center: [
                    (kind: Property(Song(Artist)), style: (fg: "$secondary", modifiers: "Bold"),
                        default: (kind: Text("Unknown Artist"), style: (fg: "$dim", modifiers: ""))
                    ),
                ],
                right: [
                    (
                        kind: Property(Widget(States(
                            active_style: (fg: "$accent", modifiers: "Bold"),
                            separator_style: (fg: "$dim")))
                        ),
                        style: (fg: "$dim")
                    ),
                ]
            ),
        ],
    ),
    browser_song_format: [
        (
            kind: Group([
                (kind: Property(Track)),
                (kind: Text(" ")),
            ])
        ),
        (
            kind: Group([
                (kind: Property(Artist)),
                (kind: Text(" - ")),
                (kind: Property(Title)),
            ]),
            default: (kind: Property(Filename))
        ),
    ],
)
EOF
    
    echo "✅ Created rmpc theme for $theme"
}

# Process all themes
for theme in "${THEMES[@]}"; do
    create_rmpc_theme "$theme"
done

echo ""
echo "🎨 All rmpc themes created with harmonious colors!"
echo "Color scheme: Background + Foreground + Accent (simple and clean)"
