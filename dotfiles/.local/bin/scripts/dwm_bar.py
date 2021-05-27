#!/usr/bin/env python3
# =============================================================================
#   _____   _  _  _ ______     ______        ______
#  (____ \ | || || |  ___ \   (____  \   /\ (_____ \
#   _   \ \| || || | | _ | |   ____)  ) /  \ _____) )
#  | |   | | ||_|| | || || |  |  __  ( / /\ (_____ (
#  | |__/ /| |___| | || || |  | |__)  ) |__| |    | |
#  |_____/  \______|_||_||_|  |______/|______|    |_|
# =============================================================================
#          FILE: dwm_bar.py
#
#         USAGE: run script as background job:
#                $ pkill -f 'dwm_bar.py' > /dev/null 2>&1;dwm_bar.py &
#
#   DESCRIPTION: This python script sets the status bar with the xsetroot
#                command.
#
#  REQUIREMENTS: psutil python lib
#                pulsemixer
#                acpi package
#                ttf-ancient-fonts-symbola
#                ttf-unifont:
#                    unifont.ttf
#                    unifont_csur.ttf
#                    unifont_sample.ttf
#                    unifont_upper.ttf
#
#        ISSUES: Unsolved issue on Debian 10 Buster
#                In case of:
#                    1) All required fonts installed:
#                       Performance is OK, but wrong appearance - useless
#                       extra spaces on the end.
#                    2) Only symbola font installed from requirement list:
#                       Performance is BAD (high CPU load), but appearance is
#                       Correct.
#
#                Temporary Solution:
#                    Deactivate all colors.
#
#                P.S. On Ubuntu LTS 18.04 anything is OK.
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 20 Oct 2019
#      REVISION: 29 Nov 2019
# =============================================================================

import threading
import psutil
import time
import os

# == COLOR SCHEMES ============================================================

# Colour codes from dwm/config.h
SchemeNorm = "\x01"
SchemeSel = "\x02"

BG_normal_red = "\x03"
BG_normal_green = "\x04"
BG_normal_yellow = "\x10"
BG_normal_blue = "\x11"
BG_normal_purpl = "\x13"

FG_normal_red = "\x14"
FG_normal_green = "\x15"
FG_normal_yellow = "\x16"
FG_normal_blue = "\x17"

FG_bright_red = "\x1a"
FG_bright_green = "\x1c"
FG_bright_yellow = "\x1d"
FG_bright_blue = "\x1e"

# Deactivate colors
SchemeNorm = SchemeSel = BG_normal_red = BG_normal_green = BG_normal_yellow = \
    BG_normal_blue = BG_normal_purpl = FG_normal_red = FG_normal_green = \
    FG_normal_yellow = FG_normal_blue = FG_bright_red = FG_bright_green = \
    FG_bright_yellow = FG_bright_blue = ""

# == SETTINGS ==================================================================

DWM_STATUSBAR_REFRESH_INTERVAL = 1

# Symbol Unicode: U+205F, Name: medium mathematical space (whitespace)
delim = SchemeNorm + "\u205F"

# == FUNCTIONS =================================================================

def execute(cmd):
    return os.popen(cmd).read()

def update_bar():
    status = \
        var_network + \
        var_disk_io + \
        var_resources + \
        var_diskusage + delim + \
        var_power + delim + \
        var_backlight + delim + \
        var_volume + delim + \
        var_date + delim + \
        var_time

    # Note that the tr command replaces newlines with spaces.
    # This is to prevent some weird issues that cause significant
    # slowing of everything in dwm.
    command = 'xsetroot -name "{}" | tr "\n" " "'.format(status)
    execute(command)

# == MODULES ===================================================================

var_date = ""
def module_date(refresh_interval_sec):
    global var_date
    while True:
        out = execute('date +"📅 %a %d %b %y"')
        var_date = BG_normal_blue + " " + out.rstrip() + " "
        time.sleep(refresh_interval_sec)

th_date = threading.Thread(target=module_date, args=(60,))
th_date.start()

# ------------------------------------------------------------------------------

var_time = ""
def module_time(refresh_interval_sec):
    global var_time
    while True:
        out = execute('date +"🕐 %H:%M"')
        var_time = BG_normal_purpl + " " + out.rstrip() + " "
        time.sleep(refresh_interval_sec)

th_time=threading.Thread(target=module_time, args=(1,))
th_time.start()

# ------------------------------------------------------------------------------

var_power=""
def module_power(refresh_interval_sec):
    global var_power
    while True:
        percent = int(round(psutil.sensors_battery().percent, 0))
        power_plugged = psutil.sensors_battery().power_plugged
        timeleft = int(round(psutil.sensors_battery().secsleft / 60, 0))

        if 40 <= percent <= 100:
            color = BG_normal_green
        elif 20 <= percent <= 39:
            color = BG_normal_yellow
        elif 0 <= percent <= 19:
            color = BG_normal_red

        if power_plugged is True:
            icon = "🔌"
            minleft = ""
        else:
            icon = "🔋"
            minleft = " [" + str(timeleft).rstrip() + "m]"

        var_power = \
            color + " " + icon + " " + str(percent).rstrip() + "%" + minleft.rstrip() + " "
        time.sleep(refresh_interval_sec)

th_power = threading.Thread(target=module_power, args=(5,))
th_power.start()

# ------------------------------------------------------------------------------

var_backlight = ""
def module_backlight(refresh_interval_sec):
    global var_backlight

    brightness = "/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness"
    max_brightness = "/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/max_brightness"

    while True:
        br = execute('cat {}'.format(brightness))
        max_br = execute('cat {}'.format(max_brightness))
        val = int(round(int(br) * 100 / int(max_br), 0))
        var_backlight = SchemeSel + " 💡 " + str(val).rstrip() + "% "
        time.sleep(refresh_interval_sec)

    # Alternative lag method
    #while True:
        #out = execute('printf "💡 %.0f" "$(xbacklight | sed "s/,/./")"')
        #var_backlight = SchemeSel + " " + out.rstrip() + "% "
        #time.sleep(refresh_interval_sec)

th_backlight = threading.Thread(target=module_backlight, args=(1,))
th_backlight.start()

# ------------------------------------------------------------------------------

var_resources = ""
def module_resources(refresh_interval_sec):
    global var_resources
    while True:
        # -- USED CPU
        used_cpu = int(psutil.cpu_percent(refresh_interval_sec))

        if 90 <= used_cpu <= 100:
            used_cpu_color = FG_normal_red
        elif 70 <= used_cpu <= 89:
            used_cpu_color = FG_normal_yellow
        elif 0 <= used_cpu <= 69:
            used_cpu_color = FG_normal_green

        used_cpu = str(used_cpu)

        # -- CPU TEMP
        # Used Escape Sequence \ for quotes awk \"%.0f\"
        command = "acpi -t | tr -d ',' | awk '{ printf(\"%.0f\", $4) }'"
        cpu_temp = int(execute(command))

        if 0 <= cpu_temp <= 69:
            cpu_temp_color = FG_normal_green
        elif 70 <= cpu_temp <= 89:
            cpu_temp_color = FG_normal_yellow
        else:
            cpu_temp_color = FG_normal_red

        cpu_temp = str(cpu_temp)

        # -- USED RAM
        used_mem = int(round(psutil.virtual_memory().percent, 0))

        if 90 <= used_mem <= 100:
            used_mem_color = FG_normal_red
        elif 80 <= used_mem <= 89:
            used_mem_color = FG_normal_yellow
        elif 0 <= used_mem <= 79:
            used_mem_color = FG_normal_green

        used_mem = str(used_mem)

        var_resources = \
            SchemeNorm + "|" + \
            used_cpu_color + str(used_cpu.rstrip() + "%").center(5) + \
            cpu_temp_color + str(cpu_temp.rstrip() + "°").center(5) + \
            used_mem_color + str(used_mem.rstrip() + "%").center(5) + \
            SchemeNorm + "|"

        time.sleep(refresh_interval_sec)

th_resources = threading.Thread(target=module_resources, args=(1,))
th_resources.start()

# ------------------------------------------------------------------------------

var_volume = ""
def module_volume(refresh_interval_sec):
    global var_volume
    while True:
        volume = execute("pulsemixer --get-volume | awk '{ print $1 }'")
        isMute = execute("pulsemixer --get-mute")

        if int(volume) == 0:
            icon = "🔇"
            color = SchemeSel
        elif 1 <= int(volume) <= 33:
            icon = "🔈"
            color = SchemeSel
        elif 34 <= int(volume) <= 66:
            icon = "🔉"
            color = SchemeSel
        else:
            icon = "🔊"
            color = SchemeSel

        if isMute.rstrip() == "1":
            icon = "🔇"
            color = SchemeNorm

        var_volume = color + " " + icon + " " + volume.rstrip() + "% "
        time.sleep(refresh_interval_sec)

th_volume = threading.Thread(target=module_volume, args=(1,))
th_volume.start()

# ------------------------------------------------------------------------------

var_network = ""
def module_network(refresh_interval_sec):
    global var_network
    while True:
        interface = "kvnet"
        try:
            net = psutil.net_io_counters(pernic=True)
            rx_bytes_old = net[interface].bytes_recv
            tx_bytes_old = net[interface].bytes_sent

            time.sleep(refresh_interval_sec / 2)

            net = psutil.net_io_counters(pernic=True)
            rx_bytes_new = net[interface].bytes_recv
            tx_bytes_new = net[interface].bytes_sent

            rx_rate = round((rx_bytes_new - rx_bytes_old) / 1024, 1)
            tx_rate = round((tx_bytes_new - tx_bytes_old) / 1024, 1)

            rx_rate = rx_rate * 2
            tx_rate = tx_rate * 2

            if tx_rate > 0:
                rx_color = FG_bright_green
            else:
                rx_color = FG_normal_green

            if tx_rate > 0:
                tx_color = FG_bright_blue
            else:
                tx_color = FG_normal_blue

            var_network = \
                "|" + rx_color + "🔻" + str(rx_rate).rstrip() + "K" + \
                " " + tx_color + "🔺" + str(tx_rate).rstrip() + "K" + \
                SchemeNorm + "|"
            time.sleep(refresh_interval_sec / 2)

        except Exception:
            time.sleep(refresh_interval_sec * 10)

th_network = threading.Thread(target=module_network, args=(1,))
th_network.start()

# ------------------------------------------------------------------------------

var_diskusage = ""
def module_diskusage(refresh_interval_sec):
    global var_diskusage
    while True:
        path = '/'
        out = psutil.disk_usage(path).percent

        if 90 <= out <= 100:
            color = BG_normal_red
        elif 80 <= out < 90:
            color = BG_normal_yellow
        else:
            color = BG_normal_green

        var_diskusage = color + " 💽 " + str(out).rstrip() + "% "

        time.sleep(refresh_interval_sec)

th_diskusage = threading.Thread(target=module_diskusage, args=(10,))
th_diskusage.start()

# ------------------------------------------------------------------------------

var_disk_io = ""
def module_disk_io(refresh_interval_sec):
    global var_disk_io
    while True:
        read_bytes_old = psutil.disk_io_counters().read_bytes
        write_bytes_old = psutil.disk_io_counters().write_bytes

        time.sleep(refresh_interval_sec / 2)

        read_bytes_new = psutil.disk_io_counters().read_bytes
        write_bytes_new = psutil.disk_io_counters().write_bytes

        read_bytes_rate = read_bytes_new - read_bytes_old
        write_bytes_rate = write_bytes_new - write_bytes_old

        if int(read_bytes_rate) > 0:
            read_color = BG_normal_green
            read_symbol = "▓"
        else:
            read_color = SchemeNorm
            read_symbol = "░"

        if int(write_bytes_rate) > 0:
            write_color = BG_normal_red
            write_symbol = "▓"
        else:
            write_color = SchemeNorm
            write_symbol = "░"

        var_disk_io = read_color + read_symbol + write_color + write_symbol
        time.sleep(refresh_interval_sec / 2)

th_disk_io=threading.Thread(target=module_disk_io, args=(1,))
th_disk_io.start()


# == MAIN ======================================================================

if __name__ == "__main__":

    while True:
        update_bar()
        time.sleep(DWM_STATUSBAR_REFRESH_INTERVAL)

# EOL
