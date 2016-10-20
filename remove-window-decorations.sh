#!/bin/bash

## wmctl -l -x | awk '{print $1}' | xargs -i xprop -id "{}" -f _GTK_HIDE_TITLEBAR_WHEN_MAXIMIZED 32c -set '_GTK_HIDE_TITLEBAR_WHEN_MAXIMIZED' '0x1'

current_focused_window=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2 )
xprop -id $current_focused_window -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0"
