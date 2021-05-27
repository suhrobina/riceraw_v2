#!/usr/bin/env bash
# =============================================================================
#   ____            _           _        _             _     _
#  |  _ \ _ __ ___ (_) ___  ___| |_     / \   _ __ ___| |__ (_)_   _____ _ __
#  | |_) | '__/ _ \| |/ _ \/ __| __|   / _ \ | '__/ __| '_ \| \ \ / / _ \ '__|
#  |  __/| | | (_) | |  __/ (__| |_   / ___ \| | | (__| | | | |\ V /  __/ |
#  |_|   |_|  \___// |\___|\___|\__| /_/   \_\_|  \___|_| |_|_| \_/ \___|_|
#                |__/
# =============================================================================
#          FILE: p-archiver.sh
#
#   DESCRIPTION: This script archives the project files/folders
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 21 Oct 2019
# =============================================================================


# == SETTINGS =================================================================

# Project root folder full path/
PROJECT_ROOT_FOLDER_PATH="${HOME}/Documents/Projects/"

# Only Project Folder/
PROJECT_FOLDER="riceraw_v2/"

# Archive filepath
ARCHIVE_FILEPATH="$HOME/Documents/Projects/archives/project_riceraw_v2.tar.gz"

# == PERFORM ==================================================================

cd ${PROJECT_ROOT_FOLDER_PATH}

tar -cvpzf ${ARCHIVE_FILEPATH} ${PROJECT_FOLDER}

echo
# read -p "Press ENTER to continue..."
