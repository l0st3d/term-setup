#!/bin/bash

## wmctl -l -x | awk '{print $1}' | xargs -i xprop -id "{}" -f _GTK_HIDE_TITLEBAR_WHEN_MAXIMIZED 32c -set '_GTK_HIDE_TITLEBAR_WHEN_MAXIMIZED' '0x1'

current_focused_window=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2 )
current_desktop=$(wmctrl -d | awk '{ if ($2 == "*") { print $1 }}')
current_desktop_windows=$(wmctrl -l -x -G | awk '{ if ( $2 == "'${current_desktop}'" ) { print $0 } }' | sort -k 5 -n)
emacs=$(echo "$current_desktop_windows" | awk '{ if ( $7 == "emacs.Emacs" ) { print $1 } }' | tail -n1 | sed 's/0x0*/0x/')
terminal=$(echo "$current_desktop_windows" | awk '{ if ( $7 == "gnome-terminal-server.Gnome-terminal" ) { print $1 } }' | tail -n1 | sed 's/0x0*/0x/')
firefox=$(echo "$current_desktop_windows" | awk '{ if ( $7 == "Navigator.Firefox" ) { print $1 } }' | tail -n1 | sed 's/0x0*/0x/')
chrome=$(echo "$current_desktop_windows" | awk '{ if ( $7 == "google-chrome.Google-chrome" ) { print $1 } }' | tail -n1 | sed 's/0x0*/0x/')
if [ "" != "${firefox}" ] ; then
    browser=$firefox
else
    browser=$chrome
fi

if xprop -id "${emacs}" | grep _NET_WM_STATE_MAXIMIZED_HORZ 2>&1 >/dev/null ; then
    max_emacs=yes
else
    max_emacs=no
fi

if [ "${emacs}" != "" -a "${terminal}" != "" -a "${browser}" != "" ] ; then
    if [ "${max_emacs}" == "yes" ] ; then
        if [ "${current_focused_window}" == "${emacs}" ] ; then
            wmctrl -i -a "${terminal}"
        elif [ "${current_focused_window}" == "${terminal}" ] ; then
            wmctrl -i -a "${browser}"
        else
            wmctrl -i -a "${emacs}"
        fi
    else
        if [ "${current_focused_window}" == "${emacs}" -o "${current_focused_window}" == "${terminal}" ] ; then
            wmctrl -i -a "${browser}"
        else
            wmctrl -i -a "${terminal}"
            wmctrl -i -a "${emacs}"
        fi
    fi
elif [ "${emacs}" != "" -a "${terminal}" != "" ] ; then
    if [ "${current_focused_window}" == "${emacs}" ] ; then
        wmctrl -i -a "${terminal}"
    else
        wmctrl -i -a "${emacs}"
    fi
elif [ "${emacs}" ] ; then
    wmctrl -i -a "${emacs}"
fi
