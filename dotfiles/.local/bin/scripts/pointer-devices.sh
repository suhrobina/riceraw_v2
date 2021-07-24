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
#                Check man pages:
#                    $ man libinput
#                    $ man 4 libinput
#
#   DESCRIPTION: Pointer devices configuration script
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 29 Oct 2019
#       REVISED: 25 Jun 2021
# =============================================================================


# -- Lenovo T440p Touchpad ----------------------------------------------------

POINTER_NAME="Synaptics TM3053-003"
POINTER_ID="$(xinput list | grep "$POINTER_NAME" | sed 's/^.*id=//g;s/\[.*//g')"

# Turn OFF
POINTER_PROP_NAME="Synaptics Off" # default is 0
xinput set-prop ${POINTER_ID} "${POINTER_PROP_NAME}" 1

# -- Lenovo T440p TrackPoint --------------------------------------------------

POINTER_NAME="TPPS/2 IBM TrackPoint"
POINTER_ID="$(xinput list | grep "$POINTER_NAME" | sed 's/^.*id=//g;s/\[.*//g')"

# Switch to flat acceleration mode
POINTER_PROP_NAME="libinput Accel Profile Enabled" # default is 1, 0
xinput set-prop ${POINTER_ID} "${POINTER_PROP_NAME}" 0, 1

# Set the pointer speed
POINTER_PROP_NAME="libinput Accel Speed" # default is 0.000000
xinput set-prop ${POINTER_ID} "${POINTER_PROP_NAME}" "0.5"

# -- Logitech MX300 -----------------------------------------------------------

POINTER_NAME="B16_b_02 USB-PS/2 Optical Mouse"

POINTER_ID="$(xinput list | grep "$POINTER_NAME" | sed 's/^.*id=//g;s/\[.*//g')"

# Switch to flat acceleration mode
POINTER_PROP_NAME="libinput Accel Profile Enabled" # default is 1, 0
xinput set-prop ${POINTER_ID} "${POINTER_PROP_NAME}" 0, 1

# Set the pointer speed
POINTER_PROP_NAME="libinput Accel Speed" # default is 0.000000
xinput set-prop ${POINTER_ID} "${POINTER_PROP_NAME}" "0.55"

# -- Kensington Slimblade Trackball -------------------------------------------

POINTER_NAME="Kensington Slimblade Trackball"

POINTER_ID="$(xinput list | grep "$POINTER_NAME" | sed 's/^.*id=//g;s/\[.*//g')"

# Switch to flat acceleration mode
POINTER_PROP_NAME="libinput Accel Profile Enabled" # default is 1, 0
xinput set-prop ${POINTER_ID} "${POINTER_PROP_NAME}" 0, 1

# Set the pointer speed
POINTER_PROP_NAME="libinput Accel Speed" # default is 0.000000
xinput set-prop ${POINTER_ID} "${POINTER_PROP_NAME}" "0.4"

