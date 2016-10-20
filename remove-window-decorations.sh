#!/bin/bash

## wmctl -l -x | awk '{print $1}' | xargs -i xprop -id "{}" -f _GTK_HIDE_TITLEBAR_WHEN_MAXIMIZED 32c -set '_GTK_HIDE_TITLEBAR_WHEN_MAXIMIZED' '0x1'

xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0"
