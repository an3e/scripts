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
# false - when not
isInstalled() {
    while [ $# -gt 0 ]; do
        which ${1} &> /dev/null && shift 1 && continue
        printf "Utility '%s' is not available on your system. Please install it!\n" "${1}" >&2; \
        return 1;
    done
    return 0;
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
