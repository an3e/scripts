#!/bin/bash
# This file contains useful functions that are often used for controlling
# purposes of execution purposes.

source "${SCRIPTS_LIB_DIR}/string.sh"

###############################################################################

# returns true when the script is sourced; false - when not
isSourced() {
    local len=${#BASH_SOURCE[@]}
    test "${0}" != "${BASH_SOURCE[${len}-1]}"
    return $?
}

###############################################################################

# returns true when the script is executed; false - when not
isExecuted() {
    isSourced && return 1 || return 0
}

###############################################################################

# returns true when all the binaries given in parameter list are installed
# false - when not (number of missed utilities)
isInstalled() {
    local missed="0"
    while [ $# -gt 0 ]; do
        local utility="${1}"
        shift 1
        which "${utility}" &> /dev/null && continue
        [[ ${missed} -eq 0 ]] \
            && printf "Following utilities are not available in \$PATH:\n" >&2
        ((missed++))
        printf "\t'%s'\n" "${utility}" >&2;
    done
    return ${missed};
}

###############################################################################

die() {
    [[ $# -gt 0 ]] && printf "$*\n"
    printStackTraceFormatted >&2
    exit 1
}

###############################################################################

printStackTrace() {
    # prints stack trace using 'caller' builtin directly
    local frame=0
    while caller ${frame}; do
        ((frame++))
    done
}

###############################################################################

printStackTraceFormatted() {
    # prints stack trace in format FILE --> FUNCTION --> LINE
    local separator="${1:- --> }"
    
    mapfile <<< "$(printStackTrace)"
    for i in "${MAPFILE[@]}"; do
        IFS=' ' set -- ${i}
        local lines[${#lines[@]}]="${1}";
        local funcs[${#funcs[@]}]="${2}";
        local files[${#files[@]}]="${3}";
    done
    
    getLengthMax ${files[@]}
    local len_files=$?
    getLengthMax ${lines[@]}
    local len_lines=$?
    getLengthMax ${funcs[@]}
    local len_funcs=$?
    
    printf "%-${len_files}s${separator}%-${len_funcs}s${separator}%${len_lines}s\n" "FILE" "FUNCTION" "LINE"
    for (( i=0; i<${#files[@]}; i++ )); do
        printf "%-${len_files}s${separator}%-${len_funcs}s${separator}%${len_lines}d\n" \
        "${files[$i]}" "${funcs[$i]}" "${lines[$i]}" 
    done
}

###############################################################################
