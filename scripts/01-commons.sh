#!/usr/bin/env bash

##############################################
#	Author: Nidia Achrys
#	Project: scriptctl - common functions
#	Version: 1.0
# 
# Description:
#   This script provides a basic API for other
#	bash scripts, to make their development
#	easier and more consistent.
##############################################

# Replacement for 'echo'
function PRINT()
{
	if [ -z "${1}" ]; then
		printf "\n"
	else
		printf "%b\n" "${1}"
	fi

	return 0
}

# Retrieve the name of the script file
function SCRIPTNAME()
{
	PRINT "${0##*/}"
	return 0
}

# Pauses script execution until the user presses ENTER
function pause()
{
	read -p "Press ENTER to continue..." cmd
	return 0
}

# Converts a string to all lowercase characters
function lowercase()
{
	printf "${1}" | tr "[:upper:]" "[:lower:]"
	return 0
}

# Error message for when an invalid command is used
function invalid()
{
	PRINT 
	PRINT "Invalid command \"${1}\". See \"`SCRIPTNAME` help\"."
	PRINT 
	return 1
}

# Error message for when no command is used
function emptycmd()
{
	PRINT 
	PRINT "You must specify a subcommand. See \"`SCRIPTNAME` help\"."
	PRINT 
	return 1
}

# Checks for a filename in $PATH (commands), if not found then exit with an error
function dependency()
{
	[[ ! `command -v ${1}` ]] && PRINT "'${1}' is required to run this program." && exit 1
}

# Checks to see if the script is being run as root, and if not then exit.
function requireRoot()
{
	if [[ $EUID -ne 0 ]]
	then
		PRINT "This script must be run as root" 1>&2
		exit 1
	fi
}

# Prints the script name and version, as well as copyright, license notice, and 
# author name
function version()
{
	PRINT "`SCRIPTNAME` v${version}"
	PRINT "Copyright (C) `date +"%Y"` ${author}"
	PRINT "License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>."
	PRINT "This is free software: you are free to change and redistribute it."
	PRINT "There is NO WARRANTY, to the extent permitted by law."
	PRINT
	PRINT "Written by ${author}."
	return 0
}