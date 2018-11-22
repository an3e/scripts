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

###############################################################################

declare -A storage=""
storage["eBooks"]="an3@nasbox.fritz.box:/home/an3/backup/docs/eBooks"

###############################################################################

doRestoreBooks() {
    doRsync \
        -u "an3" \
        -s "${storage[eBooks]}" \
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

