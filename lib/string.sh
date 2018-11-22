#!/bin/bash
# This file contains useful functions that are often used for string manipulation.

###############################################################################

# calculates maximum length among all given parameters
getLengthMax() {
    local -i len=${#1};
    for i in ${@}; do
        [[ ${#i} -gt ${len} ]] && len=${#i}
    done
    return ${len:-0};
}

###############################################################################

# calculates minimum length among all parameters (empty parameter is handled)
getLengthMin() {
    local -i len=${#1};
    for i in ${@}; do
        [[ ${#i} -lt ${len} ]] && len=${#i}
    done
    return ${len:-0};
}

###############################################################################

# repeats given string ${1} desired number of times ${2}
repeatMultipleTimes() {
    local str="${1:-#}"
    local cnt="${2:-80}"
    local out="${3:-__${FUNCNAME[0]^^}}"
    
    local res=""
    for (( i=0; i<$cnt; i++)); do
        res+="${str}"
    done
    
    printf -v ${out} "%s" "${res}"
}

###############################################################################

# repeats given string ${1} until desired length ${2} is achieved
repeatUntilLength() {
    local str="${1:-#}"
    local len="${2:-80}"
    local out="${3:-__${FUNCNAME[0]^^}}"
    
    while [ ${#str} -lt ${len} ]; do
        str+="${str}"
    done
    
    printf -v ${out} "%s" "${str:0:${len}}"
}

###############################################################################

# reverses the string given in parameter ${1}
reverseString() {
    local str="${1}"
    local out="${2:-__${FUNCNAME[0]^^}}"
    
    local res=""
    while [ -n ${str} ]; do
        local allButLast="${str%?}"
        local last="${str#${allButLast}}"
        res+="${last}"
        str="${allButLast}"
    done
    
    printf -v ${out} "%s" "${res}"
}

###############################################################################

# trims characters ${2} from the beginning of string ${1}
trimLeft() {
    local str="${1:-""}"
    local -r char2trim="${2:-" "}"
    local out="${3:-__${FUNCNAME[0]^^}}"
    local trimmed="${str%%[!${char2trim}]*}"
    
    str="${str##${trimmed}}"
    
    printf -v ${out} "%s" "${str}"

}

###############################################################################

# trims characters ${2} from the end of string ${1}
trimRight() {
    local str="${1:-""}"
    local -r char2trim="${2:-" "}"
    local out="${3:-__${FUNCNAME[0]^^}}"
    local trimmed="${str##*[!${char2trim}]}"
    
    str="${str%%${trimmed}}"
    
    printf -v ${out} "%s" "${str}"
}

###############################################################################

# trims characters ${1} form the beginning and the end of string ${1}
trim() {
    local str="${1:-""}"
    local -r char2trim="${2:-" "}"
    local out="${3:-__${FUNCNAME[0]^^}}"
    
    trimLeft "${str}" "${char2trim}"
    str="${__TRIMLEFT}"
    trimRight "${str}" "${char2trim}"
    
    printf -v ${out} "%s" "${__TRIMRIGHT}"
}

###############################################################################
