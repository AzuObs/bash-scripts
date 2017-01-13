#!/bin/bash

# Parse positional arguments with getopt
PARSED_ARGS=$( getopt -o "s" -l "image-regexp:,tag-regexp:" -n "$SCRIPT_NAME" -- "$@" )

# Set positional arguments to PARSED_ARGS
set -- $PARSED_ARGS

# Assign positional arguments to parameters
while true
do
	case $1 in
		"-s")
			SILENT="true"
			shift 1
			;;
		"--image-regexp")
			IMAGE_REGEXP="$2"
			shift 2
			;;
		"--tag-regexp")
			TAG_REGEXP="$2"
			shift 2
			;;
		"--")
			break
			;;
		*)
			echo "Internal Error: unrecognized positional argument $1" 1>2
			exit 1
	esac
done

