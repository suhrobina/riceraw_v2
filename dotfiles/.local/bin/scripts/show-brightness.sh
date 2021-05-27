#!/usr/bin/env bash
# =============================================================================
#          FILE: show-brightness.sh
#
#         USAGE: bind a key to call this script
#
#   DESCRIPTION: Display brightness status message on screen with osd_cat
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 29 Oct 2019
# =============================================================================

color="#fce94f" # Color tango bright yellow
brightness="$(printf "%.0f" "$(xbacklight | sed "s/,/./")")"

# Quick and dirty notification text
killall osd_cat > /dev/null 2>&1

osd_cat --pos=bottom \
		--align=center \
		--color=${color} \
		--font="-*-*-bold-*-*-*-32-320-*-*-*-*-*-*" \
		--outline=2 \
		--delay=2 \
		--barmode=percentage \
		--percentage=${brightness} \
		--text="Brightness ${brightness} %"
