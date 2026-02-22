#![enable(implicit_some)]
#![enable(unwrap_newtypes)]
#![enable(unwrap_variant_newtypes)]
(
    default_album_art_path: None,
    show_song_table_header: false,
    draw_borders: true,
    browser_column_widths: [20, 38, 42],
    text_color: "{{ text }}",
    tab_bar: (
        enabled: true,
        active_style: (fg: "{{ text }}", bg: "{{ background }}", modifiers: "Bold"),
        inactive_style: (fg: "{{ muted }}", modifiers: ""),
    ),
    // Currently playing song
    highlighted_item_style: (fg: "{{ accent }}", modifiers: "Bold"),
    // Navigation selection
    current_item_style: (fg: "{{ background }}", bg: "{{ accent }}", modifiers: "Bold"),
    borders_style: (fg: "{{ overlay }}", modifiers: ""),
    highlight_border_style: (fg: "{{ subtle }}"),
    symbols: (song: "󰝚 ", dir: " ", marker: "* ", ellipsis: "..."),
    progress_bar: (
        symbols: ["█", "█", "█"],
        track_style: (fg: "{{ overlay }}"),
        elapsed_style: (fg: "{{ accent }}"),
        thumb_style: (fg: "{{ accent }}"),
    ),
    scrollbar: (
        symbols: ["", "", "", ""],
        track_style: (fg: "{{ overlay }}"),
        ends_style: (fg: "{{ overlay }}"),
        thumb_style: (fg: "{{ subtle }}"),
    ),
    song_table_format: [
        (
            prop: (kind: Property(Title), style: (fg: "{{ text }}"),
                highlighted_item_style: (fg: "{{ background }}", modifiers: "Bold"),
                default: (kind: Property(Filename), style: (fg: "{{ muted }}"),)
            ),
            width: "70%",
        ),
        (
            prop: (kind: Property(Album), style: (fg: "{{ subtle }}"),
                default: (kind: Text("Unknown Album"), style: (fg: "{{ muted }}"))
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
                    (kind: Property(Status(StateV2(playing_label: " ", paused_label: "❚❚", stopped_label: "❚❚"))), style: (fg: "{{ accent }}", modifiers: "Bold")),
                ],
                center: [
                    (kind: Property(Song(Title)), style: (fg: "{{ text }}", modifiers: "Bold"),
                        default: (kind: Property(Song(Filename)), style: (fg: "{{ text }}", modifiers: "Bold"))
                    )
                ],
                right: [
                    (kind: Text("Vol: "), style: (fg: "{{ subtle }}", modifiers: "Bold")),
                    (kind: Property(Status(Volume)), style: (fg: "{{ subtle }}", modifiers: "Bold")),
                    (kind: Text("% "), style: (fg: "{{ subtle }}", modifiers: "Bold"))
                ]
            ),
            (
                left: [
                    (kind: Property(Status(Elapsed)), style: (fg: "{{ subtle }}")),
                    (kind: Text("/"), style: (fg: "{{ muted }}")),
                    (kind: Property(Status(Duration)), style: (fg: "{{ subtle }}")),
                ],
                center: [
                    (kind: Property(Song(Artist)), style: (fg: "{{ accent }}", modifiers: "Bold"),
                        default: (kind: Text("Unknown Artist"), style: (fg: "{{ muted }}", modifiers: ""))
                    ),
                ],
                right: [
                    (
                        kind: Property(Widget(States(
                            active_style: (fg: "{{ accent }}", modifiers: "Bold"),
                            separator_style: (fg: "{{ muted }}"))
                        )),
                        style: (fg: "{{ muted }}")
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
