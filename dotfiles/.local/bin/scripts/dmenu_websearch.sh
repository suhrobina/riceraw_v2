#!/usr/bin/env bash
# =============================================================================
#          FILE: dmenu_websearch.sh
#
#         USAGE: bind a key to call this script
#
#   DESCRIPTION: This script implements Web search function via dmenu
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 29 Oct 2019
# =============================================================================

# URL='https://duckduckgo.com/?q='
URL='https://google.com/search?q='
QUERY=$(echo | dmenu -fn "Iosevka:size=14" -sb "#756869" -i -p "SEARCH" -b)
#BROWSER='chromium' # or surf

if [ -n "$QUERY" ]; then
	$BROWSER "${URL}${QUERY}" 2> /dev/null
	# xdg-open "${URL}${QUERY}" 2> /dev/null
fi
