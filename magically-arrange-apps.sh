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

if [ "${emacs}" != "" -a "${terminal}" != "" -a "${browser}" != "" ] ; then
    if xprop -id "${emacs}" | grep _NET_WM_STATE_MAXIMIZED_HORZ 2>&1 >/dev/null ; then
        h_max_emacs=yes
    else
        h_max_emacs=no
    fi
    if xprop -id "${emacs}" | grep _NET_WM_STATE_MAXIMIZED_VERT 2>&1 >/dev/null ; then
        v_max_emacs=yes
    else
        v_max_emacs=no
    fi
    if xprop -id "${browser}" | grep _NET_WM_STATE_MAXIMIZED_HORZ 2>&1 >/dev/null ; then
        h_max_browser=yes
    else
        h_max_browser=no
    fi
    if xprop -id "${browser}" | grep _NET_WM_STATE_MAXIMIZED_VERT 2>&1 >/dev/null ; then
        v_max_browser=yes
    else
        v_max_browser=no
    fi
    if xprop -id "${terminal}" | grep _NET_WM_STATE_MAXIMIZED_HORZ 2>&1 >/dev/null ; then
        h_max_terminal=yes
    else
        h_max_terminal=no
    fi
    if xprop -id "${terminal}" | grep _NET_WM_STATE_MAXIMIZED_VERT 2>&1 >/dev/null ; then
        v_max_terminal=yes
    else
        v_max_terminal=no
    fi
    echo "${h_max_emacs}" "${v_max_emacs}" "${h_max_browser}" "${v_max_browser}" "${h_max_terminal}"  "${v_max_terminal}" 
         
    if [ "${h_max_emacs}" == "no" -a "${v_max_emacs}" == "yes" -a \
         "${h_max_browser}" == "yes" -a "${v_max_browser}" == "yes" -a \
         "${h_max_terminal}" == "no" -a "${v_max_terminal}" == "yes" ] ; then
        if [ "${current_focused_window}" == "${emacs}" -o "${current_focused_window}" == "${terminal}" ] ; then
            wmctrl -i -a "${browser}"
        else
            wmctrl -i -a "${terminal}"
            wmctrl -i -a "${emacs}"
        fi
    elif [ "${h_max_emacs}" == "no" -a "${v_max_emacs}" == "yes" -a \
           "${h_max_browser}" == "no" -a "${v_max_browser}" == "yes" -a \
           "${h_max_terminal}" == "yes" -a "${v_max_terminal}" == "yes" ] ; then
        if [ "${current_focused_window}" == "${emacs}" -o "${current_focused_window}" == "${browser}" ] ; then
            wmctrl -i -a "${terminal}"
        else
            wmctrl -i -a "${browser}"
            wmctrl -i -a "${emacs}"
        fi
    elif [ "${h_max_emacs}" == "yes" -a "${v_max_emacs}" == "yes" -a \
           "${h_max_browser}" == "no" -a "${v_max_browser}" == "yes" -a \
           "${h_max_terminal}" == "no" -a "${v_max_terminal}" == "yes" ] ; then
        if [ "${current_focused_window}" == "${terminal}" -o "${current_focused_window}" == "${browser}" ] ; then
            wmctrl -i -a "${emacs}"
        else
            wmctrl -i -a "${browser}"
            wmctrl -i -a "${terminal}"
        fi
    else
        if [ "${current_focused_window}" == "${emacs}" ] ; then
            wmctrl -i -a "${terminal}"
        elif [ "${current_focused_window}" == "${terminal}" ] ; then
            wmctrl -i -a "${browser}"
        else
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
elif [ "${terminal}" != "" -a "${browser}" != "" ] ; then
    if [ "${current_focused_window}" == "${terminal}" ] ; then
        wmctrl -i -a "${browser}"
    else
        wmctrl -i -a "${terminal}"
    fi
elif [ "${terminal}" ] ; then
    wmctrl -i -a "${terminal}"
elif [ "${browser}" ] ; then
    wmctrl -i -a "${browser}"
fi
