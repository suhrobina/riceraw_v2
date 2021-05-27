#!/usr/bin/env bash
# =============================================================================
#          FILE: power-manager.sh
#
#         USAGE: run script as background job:
#                $ pkill -f 'power-manager.sh' > /dev/null 2>&1;power-manager.sh &
#
#   DESCRIPTION: This script notify and suspend laptop on the low battery level
#
#  REQUIREMENTS: acpi package
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 21 Nov 2019
# =============================================================================


# Play sounds functions
PowerPlugSound() { paplay /usr/share/sounds/freedesktop/stereo/power-plug.oga & }
PowerUnplugSound() { paplay /usr/share/sounds/freedesktop/stereo/power-unplug.oga & }

trigger=false
battery_last_state="$(acpi -b | tr -d ',%:' | awk '{ print $3 }')"

function battery_check() {
	battery_current_state="$(acpi -b | tr -d ',%:' | awk '{ print $3 }')"
	battery_current_level="$(acpi -b | tr -d ',%:' | awk '{ print $4 }')"

	# Reset trigger than AC adapter plugged
	if [[ "$battery_current_state" != "Discharging" ]]; then
		trigger=false
	fi

	if [[ "$battery_current_state" == "Discharging" ]]; then
		if [[ "$battery_current_level" -lt "12" ]]; then
			# suspend on low battery level
			notify-send "Power Manager" \
						"The battery level is too low. Suspend after 10 seconds..." \
						-u critical -t 9000
			sleep 10s
			systemctl suspend
		elif [[ "$battery_current_level" -lt "19" ]] && [[ "$trigger" == "false" ]]; then
			# notify
			notify-send "Power Manager" \
						"The battery level is low ($battery_current_level%)" \
						-u critical -t 15000
			trigger=true
		fi
	fi

    # Play sound on power plug/unplug events
    if [[ "$battery_current_state" != "$battery_last_state" ]]; then
	    if [[ "$battery_current_state" == "Discharging" ]]; then
	        PowerUnplugSound
        elif [[ "$battery_last_state" == "Discharging" ]]; then
	        PowerPlugSound
	    fi
    fi

	battery_last_state=$battery_current_state
}

while true
do
	battery_check
	sleep 5s
done
