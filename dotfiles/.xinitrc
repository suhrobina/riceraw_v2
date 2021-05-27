#!/usr/bin/env bash
#         _       _ _
#   __  _(_)_ __ (_) |_ _ __ ___
#   \ \/ / | '_ \| | __| '__/ __|
#  _ >  <| | | | | | |_| | | (__
# (_)_/\_\_|_| |_|_|\__|_|  \___|
#
# .xinitrc runs automatically when we run startx

# Start WM
dbus-launch --exit-with-session xmonad
