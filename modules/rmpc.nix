{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = [ pkgs-unstable.rmpc ];

  xdg.configFile."rmpc/config.ron".text = ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
        address: "${config.home.homeDirectory}/.mpd/socket",
        theme: Some("theme"),
        cache_dir: Some("/tmp/rmpc/cache"),
        lyrics_dir: Some("${config.home.homeDirectory}/Music/mpd/lyrics"),
        password: None,
        volume_step: 5,
        max_fps: 30,
        scrolloff: 0,
        wrap_navigation: false,
        enable_mouse: true,
        status_update_interval_ms: 1000,
        select_current_song_on_change: false,
        browser_column_widths: [20, 38, 42],
        album_art: (
            method: Auto,
            max_size_px: (width: 900, height: 900),
            disabled_protocols: ["http://", "https://"],
            vertical_align: Top,
            horizontal_align: Center,
        ),
        keybinds: (
            global: {
                ":":       CommandMode,
                ",":       VolumeDown,
                "s":       Stop,
                ".":       VolumeUp,
                "<Tab>":   NextTab,
                "<S-Tab>": PreviousTab,
                "1":       SwitchToTab("Queue"),
                "2":       SwitchToTab("Playlists"),
                "3":       SwitchToTab("Artists"),
                "4":       SwitchToTab("Albums"),
                "5":       SwitchToTab("Search"),
                "6":       SwitchToTab("Directories"),
                "7":       SwitchToTab("Lyrics"),
                "q":       Quit,
                ">":       NextTrack,
                "p":       TogglePause,
                "<":       PreviousTrack,
                "f":       SeekForward,
                "b":       SeekBack,
                "0":       SeekToStart,
                "z":       ToggleRepeat,
                "x":       ToggleRandom,
                "c":       ToggleConsume,
                "v":       ToggleSingle,
                "?":       ShowHelp,
                "I":       ShowCurrentSongInfo,
                "O":       ShowOutputs,
                "P":       ShowDecoders,
                "<C-Left>": CrossfadeDown,
                "<C-Right>": CrossfadeUp,
            },
            navigation: {
                "k":         Up,
                "j":         Down,
                "h":         Left,
                "l":         Right,
                "<Up>":      Up,
                "<Down>":    Down,
                "<Left>":    Left,
                "<Right>":   Right,
                "<C-k>":     PaneUp,
                "<C-j>":     PaneDown,
                "<C-h>":     PaneLeft,
                "<C-l>":     PaneRight,
                "<C-u>":     UpHalf,
                "N":         PreviousResult,
                "a":         Add,
                "A":         AddAll,
                "r":         Rename,
                "n":         NextResult,
                "g":         Top,
                "<Space>":   Select,
                "<C-Space>": InvertSelection,
                "G":         Bottom,
                "<CR>":      Confirm,
                "i":         FocusInput,
                "J":         MoveDown,
                "<C-d>":     DownHalf,
                "/":         EnterSearch,
                "<C-c>":     Close,
                "<Esc>":     Close,
                "K":         MoveUp,
                "D":         Delete,
            },
            queue: {
                "D":       DeleteAll,
                "<CR>":    Play,
                "<C-s>":   Save,
                "a":       AddToPlaylist,
                "d":       Delete,
                "i":       ShowInfo,
                "C":       JumpToCurrent,
            },
        ),
        search: (
            case_sensitive: false,
            mode: Contains,
            tags: [
                (value: "any",         label: "Any Tag"),
                (value: "artist",      label: "Artist"),
                (value: "album",       label: "Album"),
                (value: "title",       label: "Title"),
                (value: "filename",    label: "Filename"),
                (value: "genre",       label: "Genre"),
                (value: "albumartist", label: "Featured"),
            ],
        ),
        artists: (
            album_display_mode: SplitByDate,
            album_sort_by: Date,
        ),
        tabs: [
            (
                name: "Queue",
                pane: Split(
                    direction: Horizontal,
                    panes: [(size: "40%", pane: Pane(AlbumArt)), (size: "60%", pane: Pane(Queue))],
                ),
            ),
            (
                name: "Playlists",
                pane: Pane(Playlists),
            ),
            (
                name: "Artists",
                pane: Pane(Artists),
            ),
            (
                name: "Albums",
                pane: Pane(Albums),
            ),
            (
                name: "Search",
                pane: Pane(Search),
            ),
            (
                name: "Directories",
                pane: Pane(Directories),
            ),
            (
                name: "Lyrics",
                pane: Split(
                    direction: Vertical,
                    panes: [(size: "25%", pane: Pane(AlbumArt)), (size: "70%", pane: Pane(Lyrics), vertical_align: Bottom)],
                ),
            ),
        ],
    )
  '';

  xdg.configFile."rmpc/theme.ron".text = ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
        default_album_art_path: None,
        format_tag_separator: " | ",
        browser_column_widths: [20, 38, 42],
        background_color: None,
        text_color: None,
        header_background_color: None,
        modal_background_color: None,
        modal_backdrop: false,
        preview_label_style: (fg: "yellow"),
        preview_metadata_group_style: (fg: "yellow", modifiers: "Bold"),
        highlighted_item_style: (fg: "blue", modifiers: "Bold"),
        current_item_style: (fg: "black", bg: "blue", modifiers: "Bold"),
        borders_style: (fg: "blue"),
        highlight_border_style: (fg: "blue"),
        symbols: (
            song: "S",
            dir: "D",
            playlist: "P",
            marker: "M",
            ellipsis: "...",
            song_style: None,
            dir_style: None,
            playlist_style: None,
        ),
        level_styles: (
            info: (fg: "blue", bg: "black"),
            warn: (fg: "yellow", bg: "black"),
            error: (fg: "red", bg: "black"),
            debug: (fg: "light_green", bg: "black"),
            trace: (fg: "magenta", bg: "black"),
        ),
        progress_bar: (
            symbols: ["█", "█", "█", " ", "█"],
            track_style: None,
            elapsed_style: (fg: "blue"),
            thumb_style: (fg: "blue"),
            use_track_when_empty: true,
        ),
        scrollbar: (
            symbols: ["│", "█", "▲", "▼"],
            track_style: (),
            ends_style: (),
            thumb_style: (fg: "blue"),
        ),
        tab_bar: (
            active_style: (fg: "black", bg: "blue", modifiers: "Bold"),
            inactive_style: (),
        ),
        lyrics: (
            timestamp: false
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
        song_table_format: [
            (
                prop: (kind: Property(Artist),
                    default: (kind: Text("Unknown"))
                ),
                label_prop: (kind: Text("Artist")),
                width: "20%",
            ),
            (
                prop: (kind: Property(Title),
                    default: (kind: Text("Unknown"))
                ),
                label_prop: (kind: Text("Title")),
                width: "35%",
            ),
            (
                prop: (kind: Property(Album), style: (fg: "white"),
                    default: (kind: Text("Unknown Album"), style: (fg: "white"))
                ),
                label_prop: (kind: Text("Album")),
                width: "30%",
            ),
            (
                prop: (kind: Property(Duration),
                    default: (kind: Text("-"))
                ),
                label_prop: (kind: Text("Duration")),
                width: "15%",
                alignment: Right,
            ),
        ],
        layout: Split(
            direction: Vertical,
            panes: [
                (
                    size: "4",
                    pane: Split(
                        direction: Horizontal,
                        panes: [
                            (
                                size: "35",
                                borders: "LEFT | TOP | BOTTOM",
                                border_symbols: Inherited(parent: Rounded, bottom_left: "├"),
                                pane: Component("header_left")
                            ),
                            (
                                size: "100%",
                                borders: "ALL",
                                border_symbols: Inherited(parent: Rounded, top_left: "┬", top_right: "┬", bottom_left: "┴", bottom_right: "┴"),
                                pane: Component("header_center")
                            ),
                            (
                                size: "35",
                                borders: "RIGHT | TOP | BOTTOM",
                                border_symbols: Inherited(parent: Rounded, bottom_right: "┤"),
                                pane: Component("header_right")
                            ),
                        ]
                    )
                ),
                (
                    pane: Pane(Tabs),
                    borders: "RIGHT | LEFT | BOTTOM",
                    border_symbols: Rounded,
                    size: "2",
                ),
                (
                    pane: Pane(TabContent),
                    size: "100%",
                ),
                (
                    size: "3",
                    pane: Split(
                        direction: Horizontal,
                        panes: [
                            (
                                size: "12",
                                borders: "ALL",
                                border_symbols: Inherited(parent: Rounded, top_right: "┬", bottom_right: "┴"),
                                pane: Component("input_mode")
                            ),
                            (
                                size: "100%",
                                borders: "TOP | BOTTOM | RIGHT",
                                border_symbols: Rounded,
                                border_title: [(kind: Text(" ")), (kind: Property(Status(QueueLength()))), (kind: Text(" songs / ")), (kind: Property(Status(QueueTimeTotal()))), (kind: Text(" total time "))],
                                border_title_alignment: Right,
                                pane: Component("progress_bar"),
                            ),
                        ]
                    ),
                ),
            ],
        ),
        components: {
            "state": Pane(Property(
                content: [
                    (kind: Text("["), style: (fg: "yellow", modifiers: "Bold")),
                    (kind: Property(Status(StateV2( ))), style: (fg: "yellow", modifiers: "Bold")),
                    (kind: Text("]"), style: (fg: "yellow", modifiers: "Bold")),
                    (kind: Text(" XF:"), style: (fg: "blue", modifiers: "Bold")),
                    (kind: Property(Status(Crossfade)), style: (fg: "blue", modifiers: "Bold"),
                        default: (kind: Text("0"), style: (fg: "blue", modifiers: "Bold"))),
                    (kind: Text("s"), style: (fg: "blue", modifiers: "Bold")),
                ], align: Left,
            )),
            "title": Pane(Property(
                content: [
                    (kind: Property(Song(Title)), style: (modifiers: "Bold"),
                        default: (kind: Text("No Song"), style: (modifiers: "Bold"))),
                ], align: Center, scroll_speed: 1
            )),
            "volume": Split(
                direction: Horizontal,
                panes: [
                    (size: "1", pane: Pane(Property(content: [(kind: Text(""))]))),
                    (size: "100%", pane: Pane(Volume(kind: Slider(symbols: (filled: "─", thumb: "●", track: "─"))))),
                    (size: "3", pane: Pane(Property(content: [(kind: Property(Status(Volume)), style: (fg: "blue"))], align: Right))),
                    (size: "2", pane: Pane(Property(content: [(kind: Text("%"), style: (fg: "blue"))]))),
                ]
            ),
            "elapsed_and_bitrate": Pane(Property(
                content: [
                    (kind: Property(Status(Elapsed))),
                    (kind: Text(" / ")),
                    (kind: Property(Status(Duration))),
                    (kind: Group([
                        (kind: Text(" (")),
                        (kind: Property(Status(Bitrate))),
                        (kind: Text(" kbps)")),
                    ])),
                ],
                align: Left,
            )),
            "artist_and_album": Pane(Property(
                content: [
                    (kind: Property(Song(Artist)), style: (fg: "yellow", modifiers: "Bold"),
                        default: (kind: Text("Unknown"), style: (fg: "yellow", modifiers: "Bold"))),
                    (kind: Text(" - ")),
                    (kind: Property(Song(Album)), default: (kind: Text("Unknown Album"))),
                ], align: Center, scroll_speed: 1
            )),
            "states": Split(
                direction: Horizontal,
                panes: [
                    (
                        size: "1",
                        pane: Pane(Empty())
                    ),
                    (
                        size: "100%",
                        pane: Pane(Property(content: [(kind: Property(Status(InputBuffer())), style: (fg: "blue"), align: Left)]))
                    ),
                    (
                        size: "6",
                        pane: Pane(Property(content: [
                            (kind: Text("["), style: (fg: "blue", modifiers: "Bold")),
                            (kind: Property(Status(RepeatV2(
                                on_label: "z",
                                off_label: "z",
                                on_style: (fg: "yellow", modifiers: "Bold"),
                                off_style: (fg: "blue", modifiers: "Dim"),
                            )))),
                            (kind: Property(Status(RandomV2(
                                on_label: "x",
                                off_label: "x",
                                on_style: (fg: "yellow", modifiers: "Bold"),
                                off_style: (fg: "blue", modifiers: "Dim"),
                            )))),
                            (kind: Property(Status(ConsumeV2(
                                on_label: "c",
                                off_label: "c",
                                oneshot_label: "c",
                                on_style: (fg: "yellow", modifiers: "Bold"),
                                off_style: (fg: "blue", modifiers: "Dim"),
                                oneshot_style: (fg: "red", modifiers: "Dim"),
                            )))),
                            (kind: Property(Status(SingleV2(
                                on_label: "v",
                                off_label: "v",
                                oneshot_label: "v",
                                on_style: (fg: "yellow", modifiers: "Bold"),
                                off_style: (fg: "blue", modifiers: "Dim"),
                                oneshot_style: (fg: "red", modifiers: "Bold"),
                            )))),
                            (kind: Text("]"), style: (fg: "blue", modifiers: "Bold")),
                            ],
                            align: Right
                        ))
                    ),
                ]
            ),
            "input_mode": Pane(Property(
                content: [
                    (kind: Transform(Replace(content: (kind: Property(Status(InputMode()))), replacements: [
                        (match: "Normal", replace: (kind: Text(" NORMAL "), style: (fg: "black", bg: "blue"))),
                        (match: "Insert", replace: (kind: Text(" INSERT "), style: (fg: "black", bg: "green"))),
                    ])))
                ], align: Center
            )),
            "header_left": Split(
                direction: Vertical,
                panes: [
                    (size: "1", pane: Component("state")),
                    (size: "1", pane: Component("elapsed_and_bitrate")),
                ]
            ),
            "header_center": Split(
                direction: Vertical,
                panes: [
                    (size: "1", pane: Component("title")),
                    (size: "1", pane: Component("artist_and_album")),
                ]
            ),
            "header_right": Split(
                direction: Vertical,
                panes: [
                    (size: "1", pane: Component("volume")),
                    (size: "1", pane: Component("states")),
                ]
            ),
            "progress_bar": Split(
                direction: Horizontal,
                panes: [
                    (
                        size: "1",
                        pane: Pane(Empty())
                    ),
                    (
                        size: "100%",
                        pane: Pane(ProgressBar)
                    ),
                    (
                        size: "1",
                        pane: Pane(Empty())
                    ),
                ]
            )
        },
    )
  '';
}
