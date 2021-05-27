#!/bin/bash
 =============================================================================
#          FILE: task-add.sh
#
#   DESCRIPTION: This script add task by TUI
#
#        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@Gmail.com
#     COPYRIGHT: Copyright (c) 2020
#  ORGANIZATION:
#       LICENSE: GNU General Public License
#       CREATED: 02 Jan 2020
#      REVISION: 03 Jan 2020
# =============================================================================

# declare variables
DESCRIPTION=""
PRIORITY=""
PROJECT=""
TAGS=""
DUE=""
WAIT=""
SCHEDULED=""
RECURRENCE=""
UNTIL=""

# select project first
PROJ_VALUES=$(dialog --title "Projects" --menu "" 15 40 0 \
    $(task projects | sed -e '1,3d' | head -n -2 | sed ':a;N;$!ba;s/\n/ /g') 3>&1 1>&2 2>&3)
EXIT_CODE3=$?
if [ ${EXIT_CODE3} -eq 0 ]; then PROJECT=${PROJ_VALUES}; else PROJECT=""; fi

while :;
do
    # open fd
    exec 3>&1

    # setup new line output of dialog --menu
    DEFAULT_IFS=$IFS
    IFS=$'|'

    # store data to $TASK_VALUES variable
    TASK_VALUES=$(                                         \
        dialog --clear                                     \
        --ok-label "Add"                                   \
        --title "Add TASK"                                 \
        --extra-button                                     \
        --extra-label "Project"                            \
        --help-button                                      \
        --help-label "Clear"                               \
        --form "" 0 0 0                                    \
        "Description:" 1 2  "${DESCRIPTION}"  2   2 37 0   \
        "P: "          1 41 "${PRIORITY}"     2  41  3 0   \
        "Project:"     3 2  "${PROJECT}"      4   2 20 0   \
        "Tags:"        3 24 "${TAGS}"         4  24 20 0   \
        "Due:"         5 2  "${DUE}"          6   2 20 0   \
        "Wait:"        5 24 "${WAIT}"         6  24 20 0   \
        "Scheduled:"   7 2  "${SCHEDULED}"    8   2 20 0   \
        "Recurrence:"  7 24 "${RECURRENCE}"   8  24 20 0   \
        "Until:"       9 24 "$UNTIL"          10 24 20 0   \
        2>&1 1>&3)

    EXIT_CODE=$?

    # add button
    if [ ${EXIT_CODE} -eq 0 ]; then
        # close fd
        exec 3>&-

        # Retrieve values
        DESCRIPTION="$(echo ${TASK_VALUES} | sed -n '1p')"
           PRIORITY="$(echo ${TASK_VALUES} | sed -n '2p')"
            PROJECT="$(echo ${TASK_VALUES} | sed -n '3p')"
               TAGS="$(echo ${TASK_VALUES} | sed -n '4p')"
                DUE="$(echo ${TASK_VALUES} | sed -n '5p')"
               WAIT="$(echo ${TASK_VALUES} | sed -n '6p')"
          SCHEDULED="$(echo ${TASK_VALUES} | sed -n '7p')"
         RECURRENCE="$(echo ${TASK_VALUES} | sed -n '8p')"
              UNTIL="$(echo ${TASK_VALUES} | sed -n '9p')"

        # formation of task add cmd
        CMD="task add"
        if [ ! -z "${DESCRIPTION}" ]; then CMD="${CMD} "${DESCRIPTION}""; fi
        if [ ! -z "${PRIORITY}" ]; then CMD="${CMD} priority:"${PRIORITY^^}""; fi
        if [ ! -z "${PROJECT}" ]; then CMD="${CMD} project:"${PROJECT}""; fi
        if [ ! -z "${TAGS}" ]; then CMD="${CMD} tags:"${TAGS}""; fi
        if [ ! -z "${DUE}" ]; then CMD="${CMD} due:"${DUE}""; fi
        if [ ! -z "${WAIT}" ]; then CMD="${CMD} wait:"${WAIT}""; fi
        if [ ! -z "${SCHEDULED}" ]; then CMD="${CMD} scheduled:"${SCHEDULED}""; fi
        if [ ! -z "${RECURRENCE}" ]; then CMD="${CMD} recur:"${RECURRENCE}""; fi
        if [ ! -z "${UNTIL}" ]; then CMD="${CMD} until:"${UNTIL}""; fi

        # execute cmd
        STDOUT_STDERR=$(eval ${CMD} 2>&1)
        EXIT_CODE2=$?

        echo ${STDOUT_STDERR} | fold -w 46 | dialog --title "RESULT" --programbox 9 50

        # if error occurred then keep description value
        if [ ${EXIT_CODE2} -eq 0 ]; then DESCRIPTION=""; fi

    # cancel button
    elif [ ${EXIT_CODE} -eq 1 ]; then
        clear
        exit 0

    # clear button
    elif [ ${EXIT_CODE} -eq 2 ]; then
        DESCRIPTION=""
        PRIORITY=""
        PROJECT=""
        TAGS=""
        DUE=""
        WAIT=""
        SCHEDULED=""
        RECURRENCE=""
        UNTIL=""

    # project button
    elif [ ${EXIT_CODE} -eq 3 ]; then
        IFS=${DEFAULT_IFS}
        PROJ_VALUES=$(dialog --title "Projects" --menu "" 15 40 0 \
            $(task projects | sed -e '1,3d' | head -n -2 | sed ':a;N;$!ba;s/\n/ /g') 3>&1 1>&2 2>&3)

        EXIT_CODE3=$?

        if [ ${EXIT_CODE3} -eq 0 ]; then PROJECT=${PROJ_VALUES}; else PROJECT=""; fi
    fi
done

