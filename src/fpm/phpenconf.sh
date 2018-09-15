#!/bin/bash

## -----------------------------------------------------
## Enable a PHP7.x-FPM pool configuration.
##
## @author Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Defines colors
## -----------------------------------------------------
readonly COLORRED="$(tput -Txterm setaf 1)"
readonly COLORGREEN="$(tput -Txterm setaf 2)"
readonly COLORRESET="$(tput -Txterm sgr0)"

## -----------------------------------------------------
## Main Directories
## -----------------------------------------------------
# Current directory
readonly m_DIR_SCRIPT="$(pwd)"
# Directory for available pool configuration
readonly m_DIR_AVAILABLE="${m_DIR_SCRIPT}/conf-available"
# Directory for enable pool configuration
readonly m_DIR_ENABLE="${m_DIR_SCRIPT}/pool.d"

## -----------------------------------------------------
## Console functions
## -----------------------------------------------------

Console::error() {
    if [[ -n "$1" ]]; then
        if [[ "$1" == "-n" ]]; then
            shift
            echo -e -n "${COLORRED}$*${COLORRESET}" >&2
        else
            echo -e "${COLORRED}$*${COLORRESET}" >&2
        fi
    fi
    return 0
}

Console::success() {
    if [[ -n "$1" ]]; then
        if [[ "$1" == "-n" ]]; then
            shift
            echo -e -n "${COLORGREEN}$*${COLORRESET}"
        else
            echo -e "${COLORGREEN}$*${COLORRESET}"
        fi
    fi
    return 0
}

Console::notice() {
    if [[ -n "$1" ]]; then
        echo -e "$@"
    fi
    return 0
}

## -----------------------------------------------------
## Enable pool configuration
## -----------------------------------------------------
Pool::enable() {

    # Parameters
    if (($# != 3)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        Console::error "Usage: Pool::enable <available pool directory> <enable pool directory> <conf file>"
        exit 1
    fi

    # Init
    local sAvailableDir="$1" sEnableDir="$2" sFile="$3"
    local -i iReturn=1

    # Pool already disabled
    if [[ -f "${sEnableDir}/${sFile}.conf" ]]; then
        Console::notice -n "Pool ${sFile} is "
        Console::success "enabled."
        return 0
    fi

    # Pool does not exist
    if [[ ! -f "${sAvailableDir}/${sFile}.conf" ]]; then
        Console::notice -n "Pool ${sFile} "
        Console::error "does not exist."
        return 1
    fi

    # Do the job
    ln -s "${sAvailableDir}/${sFile}.conf" "${sEnableDir}/${sFile}.conf"
    iReturn=$?
    if (( 0==iReturn )); then
        Console::notice -n "Pool ${sFile} is "
        Console::success "enabled."
    else
        Console::notice -n "Pool ${sFile} "
        Console::error -n "can not be enabled. "
        Console::notice "Code: ${iReturn}"
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Main
## -----------------------------------------------------------------------------

declare -i iReturn=1

# At least one argument
if (($# < 1)) || [[ -z "$1" ]]; then
    echo "Usage: $(basename "$0") <configuration 1> [configuration 2 ...]"
    echo -e "\tEnable a PHP7.x-FPM pool configuration file."
    echo -e "\t<configuration 1>\tPool configuration file."
    exit ${iReturn}
fi

until [ -z "${1+defined}" ]  # Until all parameters used up . . .
do
    Pool::enable "${m_DIR_AVAILABLE}" "${m_DIR_ENABLE}" "${1}"
    iReturn=$?
    if ((0!=iReturn)); then
        exit ${iReturn}
    fi
    shift
done

exit ${iReturn}
