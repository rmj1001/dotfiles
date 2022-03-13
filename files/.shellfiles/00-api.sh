#!/usr/bin/env bash

##############################################
#	Author(s): RMCJ <rmichael1001@gmail.com>
#	Project: HeckerShell
#	Version: 1.0
#
# 	Description:
#   	This file provides common bash functions
#		that I use in all my bash scripts. Feel free
#		to use these functions in your own scripts.
##############################################

# Description: Replacement for 'echo'
# Usage:  PRINT "text"
# Returns: string
function PRINT() {
    printf "%b\n" "${@}"
}

# Description: 'echo' replacement w/o newline
# Usage:  NPRINT "text"
# Returns: string
function NPRINT() {
    printf "%b" "${@}"
}

# Description: Pauses script execution until the user presses ENTER
# Usage:  PAUSE
# Returns: int
function PAUSE() {
    NPRINT "Press <ENTER> to continue..."
    read -r
}

# Description: Sets the terminal window title
# Usage:  TITLE "test"
# Returns: void
function TITLE() {
    NPRINT "\033]2;${1}\a"
}

# Description: Generate a random number from 1 to the specified maximum
# Usage:  RANDOM_NUM 100
# Returns: int
function RANDOM_NUM() {
    eval "shuf -i 1-${1} -n 1"
}

# Description: Converts a string to all api.std.failMsg characters
# Usage:  name="$(LOWERCASE $name)"
# Returns: string
function LOWERCASE() {
    NPRINT "${1}" | tr "[:upper:]" "[:lower:]"
}

# Description: Converts a string to all UPPERCASE characters
# Usage:  name="$(UPPERCASE $name)"
# Returns: string
function UPPERCASE() {
    NPRINT "${1}" | tr "[:lower:]" "[:upper:]"
}

# Description: Trim all leading/trailing whitespace from a string
# Usage:  TRIM "   this      "
# Returns: string
function TRIM() {
    local var="$*"

    # remove leading whitespace characters
    var="${var##*( )}"

    # remove trailing whitespace characters
    var="${var%%*( )}"

    # Return trimmed string
    printf '%s' "$var"
}

# Description: Return the name of the script
# Usage:  SCRIPTNAME
# Returns: string
function SCRIPTNAME() {
    NPRINT "$(basename "$(readlink -nf "$0")")"
}

################################################################################
# Script Processing

# Description: Prints "<script>: Invalid command 'command'"
# Usage: INVALID_CMD "<cmd>"
# Returns: string
function INVALID_CMD() {
    PRINT "$(SCRIPTNAME): Invalid command '${1}'."
}

# Description: Find the path for a command
# Usage:  WHICH <cmd>
# Returns: string
function WHICH() {
    command -v "${@}"
}

# Description: Run code silently
# Usage:  SILENTRUN <command>
# Returns: return exit code
function SILENTRUN() {
    "$@" >/dev/null 2>&1
}

# Description: Run code silently and disown it
# Usage:  ASYNC <command>
# Returns: void
function ASYNC() {
    "$@" >/dev/null 2>&1 &
    disown
}

# Description: Checks for a filename in $PATH (commands), if not found then exit with an error
# Usage:  REQUIRE_CMD "7z" "tar" || exit 1
# Returns: string
function REQUIRE_CMD() {
    local NEEDED=()

    while [[ $# -gt 0 ]]; do
        [[ -z "$1" ]] && shift
        SILENTRUN WHICH "${1}" || NEEDED+=("${1}")
        shift
    done

    [[ ${#NEEDED[@]} -eq 0 ]] && return 0

    NPRINT "Missing Commands: "
    NPRINT "${NEEDED[@]}" | sed -r "s|[[:blank:]]|,[[:blank:]]|g"
    PRINT
    return 1
}

# Description: Checks to see if the script is being run as root, and if not then exit.
# Usage:  REQUIRE_ROOT
# Returns: string
function REQUIRE_ROOT() {
    # shellcheck disable=SC2046
    [[ "$(id -u)" == "0" ]] && return 0

    PRINT "'$(SCRIPTNAME)' must be run as root"
    return 1
}

# Description: Checks to see if the script is being run as root, and if so then exit.
# Usage:  DISABLE_ROOT
# Returns: string
function DISABLE_ROOT() {
    # shellcheck disable=SC2046
    [[ "$(id -u)" == "0" ]] || return 0

    PRINT "'$(SCRIPTNAME)' should not be run as root. Please try again as a normal user."
    return 1
}

# Description: Check to see if command exists
# Usage:  CMD_EXISTS <command>
# Returns: return code
function CMD_EXISTS() {
    WHICH "${1}" >/dev/null 2>&1
}

# Description: Check to see if input is 'yes' or empty
# Usage:  CHECK_YES <var>
# Returns: return code (0 for yes/empty, 1 for no)
function CHECK_YES() {
    [[ "$1" =~ [yY][eE]?[sS]? ]] && return 0
    [[ -z "$1" ]] && return 0

    return 1
}

# Description: Check to see if input is 'no' or empty
# Usage:  CHECK_NO <var>
# Returns: return code (0 for no/empty, 1 for yes)
function CHECK_NO() {
    [[ "$1" =~ [nN][oO]? ]] && return 0
    [[ -n "${1}" ]] && return 0

    return 1
}

# Description: Prompt with message, prints answer to prompt
# Usage:  PROMPT "prompt text"
# Returns: string (answer to prompt)
function PROMPT() {
    local confirm

    NPRINT "${1}"
    read -r confirm

    NPRINT "${confirm}"
}

# Description: Prompt with message, check if input is 'yes' or empty
# Usage:  PROMPT_YES "prompt text"
# Returns: return code (0 for yes/empty, 1 for no)
function PROMPT_YES() {
    local confirm

    NPRINT "${1}? (Y/n) "
    read -r confirm

    CHECK_YES "${confirm}"
}

# Description: Prompt with message, check if input is 'no' or empty
# Usage:  PROMPT_NO "prompt text"
# Returns: return code (0 for no/empty, 1 for yes)
function PROMPT_NO() {
    local confirm

    NPRINT "${1}? (y/N) "
    read -r confirm

    CHECK_NO "${confirm}"
}

# Description: Checks to see if input is a number
# Usage:  IS_NUMBER <var>
# Returns: return code (0 for yes)
function IS_NUMBER() {
    [[ "$1" =~ [0-9]+ ]] && return 0
    return 1
}

# Description: Read config file using ini-esque format
# Usage:  READ_CONF <file>
# Returns: void (reads file and inits variables in script from file)
function READ_CONF() {
    local file="${1}"
    local section=""
    local var=""
    local val=""

    # If file doesn't exist, return with error.
    [[ ! -f "${file}" ]] && PRINT "$(SCRIPTNAME): Invalid file ${file}." && return 1

    # Read file line-by-line
    while read -r line; do

        line="$(TRIM "${line}")"

        # Continue to next line if commented
        [[ "${line}" =~ ^\#\.* ]] && continue

        # If line is a section, set `$section` variable and continue to next line
        [[ "${line}" =~ ^\[[a-z]+\]$ ]] && section="$(NPRINT "${line}" | sed -e 's|\[\([a-z]\+\)\]|\1|')" && continue

        # If line is a key=value pair, then set `var` and `val` accordingly, else continue to next line.
        [[ "${line}" =~ ^[a-z]+\=\"?\'?.*\"?\'?$ ]] || continue

        [[ "${line}" =~ ^[a-z]+\=\"?\'?.*\"?\'?$ ]] &&
            var="$(NPRINT "${line}" | sed 's|\([a-z]\+\)\=.*|\1|')" &&
            val="$(NPRINT "${line}" | sed 's|.*\=||g' | cut -d\" -f2 | cut -d\' -f2)"

        # If no section, import as `var="val"`
        [[ -z "${section}" ]] && eval "${var}=\"${val}\"" && continue

        # If section, import as `section.var="val"`
        eval "${section}_${var}=\"${val}\""

    done <"${file}"
}

# Description: Print current time & date
# Usage: TIMESTAMP [-m/--multiline]?
# Returns: string
function TIMESTAMP() {
    local timestamp="$(date +"%I:%M%P %m/%d/%Y")"

    # Multi-line timestamp flag
    [[ "${1}" == "-m" || "${1}" == "--multiline" ]] && timestamp="$(date +"%I:%M%P")\n$(date +"%m/%d/%Y")"

    PRINT "${timestamp}"
}

################################################################################
# HELP MENU HELPER
#

# Description: Add an example entry for the help menu
# Usage: EXAMPLE "[args]" "[comment]?"
# Returns: void
function EXAMPLE() {
    local args="$1"
    local comment="$2"

    [[ -n "$comment" ]] &&
        SCRIPT_EXAMPLES+=("$(SCRIPTNAME) ${args}\t# ${comment}") &&
        return 0

    SCRIPT_EXAMPLES+=("$(SCRIPTNAME) ${args}")
}

# Description: Add a flag/command entry for the help menu
# Usage: FLAG "[flag]" "[args]" "[description]"
# Example: FLAG "-n" "[NUMBER]" "Prints 'no' [NUMER] times"
# Returns: void
function FLAG() {
    local flag="$1"
    local args="$2"
    local description="$3"

    SCRIPT_FLAGS+=("${flag}|${args}|${description}")
}

# Description: Prints a pre-designed help menu based on a few
#   environment variables defined in each HeckerShell script
#
# Usage: HELP
# Returns: string
function HELP() {

    PRINT_EXAMPLES() {
        [[ "${#SCRIPT_EXAMPLES[@]}" == "0" ]] &&
            PRINT "Example(s):\tNone provided." &&
            return 0

        PRINT "Example(s):"
        for example in "${SCRIPT_EXAMPLES[@]}"; do
            PRINT "\t\t${example}"
        done
    }

    PRINT "$(SCRIPTNAME) v${SCRIPT_VERSION:=1.0}"
    PRINT "Copyright $(date +"%Y") ${SCRIPT_AUTHOR:=HeckerShell Project}"
    PRINT
    PRINT "Description:\t${SCRIPT_DESCRIPTION:=A random description}"
    PRINT "Usage:\t\t$(SCRIPTNAME) ${SCRIPT_USAGE:=[FLAG] [ARGS?]...}"

    PRINT_EXAMPLES

    PRINT
    {
        PRINT "-------------|------|---------------------"
        PRINT "Flag|Args|Description"
        PRINT "-------------|------|---------------------"
        PRINT "||"
        for flag in "${SCRIPT_FLAGS[@]}"; do
            PRINT "${flag}"
        done
        PRINT "||"
        PRINT "-h, --help||Show this prompt"
    } | column -t -s'|'

    return 0
}
