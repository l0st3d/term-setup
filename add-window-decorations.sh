#!/bin/bash

current_focused_window=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2 )

xprop -id $current_focused_window -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x1, 0x0, 0x0"
