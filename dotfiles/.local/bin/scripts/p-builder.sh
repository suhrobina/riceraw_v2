#!/usr/bin/env bash
# =============================================================================
#          FILE: p-builder.sh
#
#   DESCRIPTION: This script automates frequently repeated
#                project development processes.
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 29 Oct 2019
# =============================================================================

PROJECT_FOLDER="${HOME}/Documents/Projects/riceraw_v2"

BLUE='\e[34m'
BOLD_MAGENTA='\e[1m\e[35m'
BOLD_GREEN='\e[1m\e[32m'
RESET='\e[0m'

echo -e
echo -e "${BLUE} ▛▀▖       ▖      ▐   ▛▀▖   ▗▜   ▌      "
echo -e "${BLUE} ▙▄▘▙▀▖▞▀▖▗▖▞▀▖▞▀▖▜▀  ▙▄▘▌ ▌▄▐ ▞▀▌▞▀▖▙▀▖"
echo -e "${BLUE} ▌  ▌  ▌ ▌ ▌▛▀ ▌ ▖▐ ▖ ▌ ▌▌ ▌▐▐ ▌ ▌▛▀ ▌  "
echo -e "${BLUE} ▘  ▘  ▝▀ ▄▘▝▀▘▝▀  ▀  ▀▀ ▝▀▘▀▘▘▝▀▘▝▀▘▘  "
echo -e

while true; do
    read -p "$(echo -ne "${BOLD_GREEN}[1/7] Edit p-collector.sh? [y¹/n²]${RESET} ")" yn
    case $yn in
        [1Yy]* ) vim ${HOME}/.local/bin/scripts/p-collector.sh; break;;
        [2Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "$(echo -ne "${BOLD_GREEN}[2/7] Run p-collector.sh? [y¹/n²]${RESET} ")" yn
    case $yn in
        [1Yy]* ) ${HOME}/.local/bin/scripts/p-collector.sh; break;;
        [2Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "$(echo -ne "${BOLD_GREEN}[3/7] Check project Git repo status? [y¹/n²]${RESET} ")" yn
    case $yn in
        [1Yy]* ) cd ${PROJECT_FOLDER}; git status; break;;
        [2Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "$(echo -ne "${BOLD_GREEN}[4/7] Add all file contents to the Git index? [y¹/n²]${RESET} ")" yn
    case $yn in
        [1Yy]* )
			cd ${PROJECT_FOLDER}
			git add .
			echo
			echo -e "${BOLD_MAGENTA}All file contents added to the index! Check Git status...${RESET}"
			git status
			break;;
        [2Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "$(echo -ne "${BOLD_GREEN}[5/7] Git commit? [y¹/n²]${RESET} ")" yn
    case $yn in
        [1Yy]* )
            cd ${PROJECT_FOLDER}
            git commit -a
			echo
            echo -e "${BOLD_MAGENTA}All changes recorded to the repository! Check Git status...${RESET}"
			echo
            git status
            break;;
        [2Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "$(echo -ne "${BOLD_GREEN}[6/7] Run p-archiver.sh? [y¹/n²]${RESET} ")" yn
    case $yn in
        [1Yy]* ) ${HOME}/.local/bin/scripts/p-archiver.sh; break;;
        [2Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "$(echo -ne "${BOLD_GREEN}[7/7] Run syncall.sh? [y¹/n²]${RESET} ")" yn
    case $yn in
        [1Yy]* ) ${HOME}/.local/bin/scripts/syncall.sh; break;;
        [2Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo
echo -e "${BOLD_GREEN}DONE!${RESET}"
