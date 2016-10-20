#!/bin/bash

current_focused_window=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2 )
current_desktop=$(wmctrl -d | awk '{ if ($2 == "*") { print $1 }}')
current_desktop_windows=$(wmctrl -l -x | awk '{ if ( $2 == "'${current_desktop}'" ) { print $0 } }')
emacs=$(echo "$current_desktop_windows" | awk '{ if ( $3 == "emacs.Emacs" ) { print $1 } }' | sed 's/0x0*/0x/')
terminal=$(echo "$current_desktop_windows" | awk '{ if ( $3 == "gnome-terminal-server.Gnome-terminal" ) { print $1 } }' | sed 's/0x0*/0x/')

# echo "$current_desktop_windows"
# echo $current_focused_window
# echo $emacs
# echo $terminal
# exit 0

if [ "${emacs}" != "" -a "${terminal}" != "" ] ; then
    if [ "${current_focused_window}" == "${emacs}" ] ; then
        wmctrl -i -a "${terminal}"
    else
        wmctrl -i -a "${emacs}"
    fi
fi
