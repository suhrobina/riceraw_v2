#!/usr/bin/env bash
# =============================================================================
#          FILE: show-brightness.sh
#
#         USAGE: bind a key to call this script
#
#   DESCRIPTION: Display volume status message on screen with osd_cat
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 29 Oct 2019
# =============================================================================

MAX_VOLUME=100
COLOR_GREEN="#8ae234" # Color tango bright green
COLOR_RED="#ef2929"   # Color tango normal red
COLOR_GRAY="#bbbbbb"  # Color gray

isMuted="$(pulsemixer --get-mute)"
volume="$(pulsemixer --get-volume | awk '{ printf $1 }')"

# Calculate percentage
let percent=${volume}*100/${MAX_VOLUME}

if [[ "${isMuted}" == "1"  ]]; then
	message="Volume ${volume} % MUTED"
	active_color=${COLOR_GRAY}
else
	message="Volume ${volume} %"
	if [[ ${volume} -gt 100 ]]; then
		active_color=${COLOR_RED}
	else
		active_color=${COLOR_GREEN}
	fi
fi

# Quick and dirty notification text
killall osd_cat > /dev/null 2>&1

# Play sound
paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga &

osd_cat --pos=bottom \
		--align=center \
		--color=${active_color} \
		--font="-*-*-bold-*-*-*-32-320-*-*-*-*-*-*" \
		--outline=2 \
		--delay=2 \
		--barmode=percentage \
		--percentage=${percent} \
		--text="${message}"

