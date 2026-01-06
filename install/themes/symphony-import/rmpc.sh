#!/bin/bash

gen_rmpc() {
    cat > "$dest/.config/rmpc/themes/current.ron" <<EOF
// ╭─ ♪ Symphony ─╮
// │  Generated   │
// ╰──────────────╯
// Theme: Omarchy $name

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
        inactive_style: (fg: "$bblack", modifiers: ""),
    ),
    highlighted_item_style: (fg: "$accent", modifiers: "Bold"),
    current_item_style: (fg: "$bg", bg: "$accent", modifiers: "Bold"),
    borders_style: (fg: "$bblack", modifiers: ""),
    highlight_border_style: (fg: "$accent"),
    symbols: (song: "󰝚 ", dir: " ", marker: "* ", ellipsis: "..."),
    progress_bar: (
        symbols: ["█", "█", "█"],
        track_style: (fg: "$bblack"),
        elapsed_style: (fg: "$accent"),
        thumb_style: (fg: "$accent"),
    ),
    scrollbar: (
        symbols: ["", "", "", ""],
        track_style: (fg: "$bblack"),
        ends_style: (fg: "$bblack"),
        thumb_style: (fg: "$accent"),
    ),
    song_table_format: [
        (prop: (kind: Property(Title), style: (fg: "$fg"), highlighted_item_style: (fg: "$bg", modifiers: "Bold"), default: (kind: Property(Filename), style: (fg: "$bblack"))), width: "70%"),
        (prop: (kind: Property(Album), style: (fg: "$bblack"), default: (kind: Text("Unknown Album"), style: (fg: "$bblack"))), width: "30%"),
    ],
    layout: Split(direction: Vertical, panes: [
        (size: "3", pane: Pane(Tabs)),
        (size: "4", pane: Split(direction: Horizontal, panes: [(size: "100%", pane: Split(direction: Vertical, panes: [(size: "4", borders: "ALL", pane: Pane(Header))]))])),
        (size: "100%", pane: Split(direction: Horizontal, panes: [(size: "100%", borders: "NONE", pane: Pane(TabContent))])),
        (size: "3", borders: "TOP | BOTTOM", pane: Pane(ProgressBar)),
    ]),
    header: (rows: [
        (left: [(kind: Property(Status(StateV2(playing_label: " ", paused_label: "❚❚", stopped_label: "❚❚"))), style: (fg: "$accent", modifiers: "Bold"))], center: [(kind: Property(Song(Title)), style: (fg: "$fg", modifiers: "Bold"), default: (kind: Property(Song(Filename)), style: (fg: "$fg", modifiers: "Bold")))], right: [(kind: Text("Vol: "), style: (fg: "$accent", modifiers: "Bold")), (kind: Property(Status(Volume)), style: (fg: "$accent", modifiers: "Bold")), (kind: Text("% "), style: (fg: "$accent", modifiers: "Bold"))]),
        (left: [(kind: Property(Status(Elapsed)), style: (fg: "$fg")), (kind: Text("/"), style: (fg: "$bblack")), (kind: Property(Status(Duration)), style: (fg: "$fg"))], center: [(kind: Property(Song(Artist)), style: (fg: "$yellow", modifiers: "Bold"), default: (kind: Text("Unknown Artist"), style: (fg: "$bblack", modifiers: "")))], right: [(kind: Property(Widget(States(active_style: (fg: "$accent", modifiers: "Bold"), separator_style: (fg: "$bblack")))), style: (fg: "$bblack"))]),
    ]),
    browser_song_format: [(kind: Group([(kind: Property(Track)), (kind: Text(" "))])), (kind: Group([(kind: Property(Artist)), (kind: Text(" - ")), (kind: Property(Title))]), default: (kind: Property(Filename)))],
)
EOF
}
