#!/usr/bin/env bash
# =============================================================================
#          FILE: syncall.sh
#
#   DESCRIPTION: This script synchronize server folder with local folder
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2019
#       LICENSE: GNU General Public License
#       CREATED: 21 Oct 2019
#       REVISED: 07 Jan 2021
# =============================================================================

BOLD_GREEN='\e[1m\e[32m'
RESET='\e[0m'

echo

# -- PassMan ------------------------------------------------------------------

echo -e "${BOLD_GREEN}LOCAL(PassMan) > > > > > > FILE_SERVER${RESET}"
rsync -havz --delete /home/suhrob/PassMan suhrob@192.168.100.6:/home/suhrob/sync
echo

# -- Taskwarrior --------------------------------------------------------------

echo -e "${BOLD_GREEN}LOCAL(Taskwarrior) > > > > > > FILE_SERVER${RESET}"
rsync -havz --delete /home/suhrob/.task suhrob@192.168.100.6:/home/suhrob/sync
rsync -havz --delete /home/suhrob/.taskrc suhrob@192.168.100.6:/home/suhrob/sync
echo

# -- Joplin -------------------------------------------------------------------

echo -e "${BOLD_GREEN}LOCAL(Notes) > > > > > > FILE_SERVER${RESET}"
rsync -havz --delete /home/suhrob/Notes suhrob@192.168.100.6:/home/suhrob/sync
echo

# -- Projects Archives --------------------------------------------------------

echo -e "${BOLD_GREEN}LOCAL(Projects Archives) > > > > > > FILE_SERVER${RESET}"
rsync -havz --delete /home/suhrob/Documents/Projects/archives suhrob@192.168.100.6:/home/suhrob/sync
echo

echo

# read -p "Press ENTER to continue..."
