# Symphony — Generated from template
# {{ accent }}

# : Manager [[[

[mgr]
cwd = { fg = "{{ text }}" }

# Find
find_keyword = { fg = "{{ color1 }}", bold = true, italic = true, underline = true }
find_position = { fg = "{{ color1 }}", bold = true, italic = true }

# Marker
marker_copied = { fg = "{{ color2 }}", bg = "{{ color2 }}" }
marker_cut = { fg = "{{ color1 }}", bg = "{{ color1 }}" }
marker_marked = { fg = "{{ color3 }}", bg = "{{ color3 }}" }
marker_selected = { fg = "{{ accent }}", bg = "{{ accent }}" }

# Count
count_copied = { fg = "{{ background }}", bg = "{{ color2 }}" }
count_cut = { fg = "{{ background }}", bg = "{{ color1 }}" }
count_selected = { fg = "{{ background }}", bg = "{{ accent }}" }

# Border
border_symbol = " "
border_style  = { fg = "{{ subtle }}" }

# : ]]]


# : Tabs [[[

[tabs]
active = { fg = "{{ background }}", bg = "{{ accent }}", bold = true }
inactive = { fg = "{{ subtle }}", bg = "{{ surface }}" }
sep_inner = { open = "[", close = "]" }

# : ]]]


# : Status [[[

[status]
sep_left = { open = "", close = "🭠" }
sep_right = { open = "🭁", close = "" }

# Permissions
perm_type = { fg = "{{ subtle }}" }
perm_read = { fg = "{{ color2 }}" }
perm_write = { fg = "{{ warn }}" }
perm_exec = { fg = "{{ color1 }}" }
perm_sep = { fg = "{{ muted }}" }

# Progress
progress_label = { bold = true }
progress_normal = { fg = "{{ accent }}", bg = "{{ surface }}" }
progress_error = { fg = "{{ color1 }}", bg = "{{ surface }}" }

# : ]]]


# : Mode [[[

[mode]
# Mode
normal_main = { bg = "{{ accent }}", fg = "{{ background }}", bold = true }
normal_alt  = { bg = "{{ overlay }}", fg = "{{ text }}" }

# Select mode
select_main = { bg = "{{ warn }}", fg = "{{ background }}", bold = true }
select_alt  = { bg = "{{ overlay }}", fg = "{{ text }}" }

# Unset mode
unset_main = { bg = "{{ color2 }}", fg = "{{ background }}", bold = true }
unset_alt  = { bg = "{{ overlay }}", fg = "{{ text }}" }

# : ]]]


# : Select [[[

[select]
border = { fg = "{{ subtle }}" }
active = { fg = "{{ text }}", bold = true }

# : ]]]


# : Input [[[

[input]
border = { fg = "{{ subtle }}" }
value = { fg = "{{ foreground }}" }

# : ]]]


# : Completion [[[

[cmp]
border = { fg = "{{ subtle }}", bg = "{{ surface }}" }

# : ]]]


# : Tasks [[[

[tasks]
border = { fg = "{{ subtle }}" }
title = {}
hovered = { fg = "{{ text }}", underline = true }

# : ]]]


# : Which [[[

[which]
cols = 3
mask = { bg = "{{ surface }}" }
cand = { fg = "{{ accent }}" }
rest = { fg = "{{ muted }}" }
desc = { fg = "{{ text }}" }
separator = " > "
separator_style = { fg = "{{ text }}" }

# : ]]]


# : Help [[[

[help]
on = { fg = "{{ text }}" }
run = { fg = "{{ text }}" }
footer = { fg = "{{ background }}", bg = "{{ subtle }}" }

# : ]]]


# : Notify [[[

[notify]
title_info = { fg = "{{ color2 }}" }
title_warn = { fg = "{{ warn }}" }
title_error = { fg = "{{ color1 }}" }

# : ]]]


# : File-specific styles [[[

[filetype]

rules = [
    # Images
    { mime = "image/*", fg = "{{ color6 }}" },

    # Media
    { mime = "{audio,video}/*", fg = "{{ warn }}" },

    # Archives
    { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "{{ color5 }}" },

    # Documents
    { mime = "application/{pdf,doc,rtf}", fg = "{{ color2 }}" },

    # Special files
    { url = "*", is = "orphan", bg = "{{ color1 }}" },
    { url = "*", is = "exec", fg = "{{ text }}" },

    # Fallback
    { url = "*", fg = "{{ text }}" },
    { url = "*/", fg = "{{ accent }}" },
]

# : ]]]
