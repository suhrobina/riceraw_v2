#!/usr/bin/env bash
# =============================================================================
#          FILE: pointer-devices.sh
#
#         USAGE: Use xinput to find pointer device, determine ID and set 
#                properties:
#                    $ xinpit list 
#                    $ xinput list-props
#                
#                Script running:
#                    $ pointer-devices.sh
#
#   DESCRIPTION: Pointer devices configuration script
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 29 Oct 2019
# =============================================================================


# -- Turn OFF TouchPad --------------------------------------------------------
POINTER_NAME="Synaptics TM3053-003"
POINTER_PROP_NAME="Synaptics Off"
POINTER_PROP_VALUE="1"

POINTER_ID="$(xinput list | grep "$POINTER_NAME" | sed 's/^.*id=//g;s/\[.*//g')"
POINTER_PROP_ID=$(xinput list-props ${POINTER_ID} | \
		grep "${POINTER_PROP_NAME}" | head -1 | sed "s/^.*(//;s/).*//")
xinput set-prop ${POINTER_ID} ${POINTER_PROP_ID} ${POINTER_PROP_VALUE}


# -- Change TrackPoint sensitivity --------------------------------------------
POINTER_NAME="TPPS/2 IBM TrackPoint"
POINTER_PROP_NAME="libinput Accel Speed"
POINTER_PROP_VALUE="-0.5"

POINTER_ID="$(xinput list | grep "$POINTER_NAME" | sed 's/^.*id=//g;s/\[.*//g')"
POINTER_PROP_ID=$(xinput list-props ${POINTER_ID} | \
		grep "${POINTER_PROP_NAME}" | head -1 | sed "s/^.*(//;s/).*//")
xinput set-prop ${POINTER_ID} ${POINTER_PROP_ID} ${POINTER_PROP_VALUE}

