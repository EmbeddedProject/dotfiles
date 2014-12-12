--
-- Notion tiling module configuration file
--

-- Bindings for the tilings. 
defbindings("WTiling", {
    bdoc("Split current frame horizontally."),
    kpress(META.."H", "WTiling.split_at(_, _sub, 'bottom', false):goto_()"),
    bdoc("Split current frame vertically."),
    kpress(META.."V", "WTiling.split_at(_, _sub, 'right', false):goto_()"),

    bdoc("Go to frame right/left of current frame."),
    kpress(META.."Right", "ioncore.goto_next(_chld, 'right')", "_chld:non-nil"),
    kpress(META.."Left", "ioncore.goto_next(_chld, 'left')", "_chld:non-nil"),
    bdoc("Go to frame up/down of current frame."),
    kpress(META.."Up", "ioncore.goto_next(_chld, 'up')", "_chld:non-nil"),
    kpress(META.."Down", "ioncore.goto_next(_chld, 'down')", "_chld:non-nil"),
})

-- Frame bindings.
defbindings("WFrame.floating", {
    submap(META.."K", {
        bdoc("Tile frame, if no tiling exists on the workspace"),
        kpress("B", "mod_tiling.mkbottom(_)"),
    }),
})

-- Context menu for tiled workspaces.
defctxmenu("WTiling", "Tiling", {
    menuentry("Destroy frame", 
              "WTiling.unsplit_at(_, _sub)"),

    menuentry("Split vertically", 
              "WTiling.split_at(_, _sub, 'bottom', false):goto_()"),
    menuentry("Split horizontally", 
              "WTiling.split_at(_, _sub, 'right', false):goto_()"),
    
    menuentry("Flip", "WTiling.flip_at(_, _sub)"),
    menuentry("Transpose", "WTiling.transpose_at(_, _sub)"),
    
    menuentry("Untile", "mod_tiling.untile(_)"),
    
    submenu("Float split", {
        menuentry("At left", 
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'left')"),
        menuentry("At right", 
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'right')"),
        menuentry("Above",
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'up')"),
        menuentry("Below",
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'down')"),
    }),

    submenu("At root", {
        menuentry("Split vertically", 
                  "WTiling.split_top(_, 'bottom')"),
        menuentry("Split horizontally", 
                  "WTiling.split_top(_, 'right')"),
        menuentry("Flip", "WTiling.flip_at(_)"),
        menuentry("Transpose", "WTiling.transpose_at(_)"),
    }),
})

-- Extra context menu extra entries for floatframes. 
defctxmenu("WFrame.floating", "Floating frame", {
    append=true,
    menuentry("New tiling", "mod_tiling.mkbottom(_)"),
})
