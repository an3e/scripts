#! /bin/bash

source "${SCRIPTS_LIB_DIR}/network.sh"

###############################################################################

usage() {
cat << EOF
NAME:
    $(basename "${0}") - restore data

SYNOPSIS:
    $(basename "${0}") [OPTIONS]

DESCRIPTION:
    This script will restore data from following directories:

    The OPTIONS are as follows:

    -h  Print this help an exit.
    -b  Restore directory "[${storage[eBooks]}]"
        into "[${PWD}]"
EOF
}

declare -A storage=""
storage["eBooks"]="an3@nasbox.fritz.box:/home/an3/backup/docs/eBooks"

###############################################################################

doRestoreBooks() {

    for h in \
        "nasbox" \
        "192.168.178.25" \
        "nasbox.fritz.box" \
    ; do
        printf "Trying to reach host [%s] ...\n" "${h}"
        ping -c4 ${h} && break;
    done \
    && doRsync \
        -u "an3" \
        -s "an3@${h}:/home/an3/backup/docs/eBooks" \
        -d "${PWD}"
}

###############################################################################

doRestore() {
    while getopts hb arg; do
        case "${arg}" in
            h) usage && exit 0;;
            b) doRestoreBooks ;;
            *) usage && exit 1;;
        esac
    done
}

###############################################################################

isSourced \
    && printf "This script is aimed to be executed!\n" \
    || doRestore ${@}

