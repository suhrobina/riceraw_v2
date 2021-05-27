#!/usr/bin/env bash
# =============================================================================
# ╔═╗┬┌─┐┬  ┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐┬  ┌─┐┌─┐
# ╠╣ ││ ┬│  ├┤  │   ║  ├─┤ │ ├─┤│  │ ││ ┬
# ╚  ┴└─┘┴─┘└─┘ ┴   ╚═╝┴ ┴ ┴ ┴ ┴┴─┘└─┘└─┘
# =============================================================================
#          FILE: figlet-catalog.sh 
#
#   DESCRIPTION: This script generates figlet fonts preview catalog
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 1 Nov 2019
# =============================================================================

FONTS_FOLDER=${HOME}/.local/share/figlet/

read -p "Enter text: " TEXT
read -p "Output width (default 80): " WIDTH

TMP_FILE=$(mktemp /tmp/figlet-catalog_XXXXX.tmp)

for filename in ${FONTS_FOLDER}*
do
 	echo "${filename}" >> ${TMP_FILE}
	echo -ne "\n" >> ${TMP_FILE}
	figlet -w ${WIDTH} -f "${filename}" ${TEXT} >> ${TMP_FILE}
	echo -ne "\n\n" >> ${TMP_FILE}
done

less ${TMP_FILE}

rm -f ${TMP_FILE}
