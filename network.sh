#!/bin/bash
#
# This file contains functions that are often used to connect to other machines.
#
###############################################################################

source "${SCRIPTS_LIB_DIR}/runtime.sh"

###############################################################################

conn2ssh() {
    local p="${1}"
    local u="${2:-${USER}}"
    local h="${3:-${HOSTNAME}}"
    
    isInstalled ssh || return $(die);
    
    local cmd=""
    if [ -z "$(grep ${h} ~/.ssh/known_hosts 2> /dev/null)" ]; then
        cmd="$(which ssh) ${u}@${h}"
    elif [ ${#p} -eq 0 ]; then
        cmd="$(which ssh) ${u}@${h}"
    else
        isInstalled sshpass || \
        cmd="$(which ssh) ${u}@${h}" && \
        cmd="$(which sshpass) -p ${p} $(which ssh) ${u}@${h}"
    fi

    eval "${cmd}"
}

###############################################################################

getRsyncCmd() {
    [[ $# -ge 4 ]] || {
        printf "%s(): invalid number of arguments [%d]!\n" "${FUNCNAME[0]}" $# >&2
        return $(die)
    }
    
    local pas="${1}"
    local usr="${2}"
    local src="${3}"
    local dst="${4}"
    local out="${5:-__${FUNCNAME[0]^^}}"
    
    getLengthMin "${pas}" "${usr}" "${src}" "${dst}" && \
        printf "%s(): one of arguments is empty! [%s] [%s] [%s] [%s]\n" \
        ${FUNCNAME[0]} "${pas}" "${usr}" "${src}" "${dst}" >&2 && \
        return $(die)
        
    isInstalled rsync ssh sshpass || return $(die)
    
    local cmd=""
    cmd+="$(which rsync)"
    cmd+=" --rsh=\"$(which sshpass) -p ${pas} $(which ssh) -l ${usr}\""
    cmd+=" --verbose"           # be verbose during backup
    cmd+=" --recursive"         # copy directories recursively
    cmd+=" --delete-during"     # delete files in destination folder that are not available in source folder during backup
    cmd+=" --force"             # force deletion of directories even if they are not empty
    cmd+=" --times"             # preserve modification time stamps
    cmd+=" --timeout=60"        # if no data is transferred during timeout [seconds] then the rsync will exit
    cmd+=" --progress"          # show progress during backup is being performed
    cmd+=" --human-readable"    # show numbers in a more human readable format"

    printf -v ${out} "%s %s %s" "${cmd}" "${src}" "${dst}"
}

###############################################################################

doRsync() {

    local pas=""
    local usr=""
    local src=""
    local dst=""
    local -i args=0
    
    while getopts p:u:s:d: var; do
        case ${var} in
            p) pas="${OPTARG}" && ((args++));;
            u) usr="${OPTARG}" && ((args++));;
            s) src="${OPTARG}" && ((args++));;
            d) dst="${OPTARG}" && ((args++));;
            *) printf "Invalid option %s\n" "${var}" >&2 && return $(die);;
        esac
    done
    
    [[ ${args} -ge 4 ]] || return $(die)
    
    set -- "${pas}" "${usr}" "${src}" "${dst}"
    getRsyncCmd ${@} && eval "${__GETRSYNCCMD}"
}

###############################################################################
