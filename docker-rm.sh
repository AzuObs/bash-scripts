#!/bin/bash

		#########################################################################
		#	 	Remove Docker Entities - images, containers						#
		#																		#
		#			dleaverfr@gmail.com											#
		#			 															#
		#																		#
		#########################################################################

parse_positional_params(){
	# Parse positional arguments with getopt
	local PARSED_ARGS=$( getopt -o "s" -l "image-regexp:,container-regexp:" -n "$SCRIPT_NAME" -- "$@" )

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
				# we eval and printf to remove the quotation marks
				IMAGE_REGEXP=$( eval "printf $2" )
				shift 2
				;;
			"--container-regexp")
				CONTAINER_REGEXP=$( eval "printf $2" )
				shift 2
				;;
			"--")
				break
				;;
			*)
				printf "Internal Error: unrecognized positional argument $1" 1>2
				exit 1
		esac
	done
}

# collect the docker entities marked by the regexp
queue_docker_entities() {
	if [[ -n ${IMAGE_REGEXP+"expand_if_set"} ]]; then
		RM_IMAGES=$( docker images | grep -E "$IMAGE_REGEXP" )
	fi

	if [[ -n ${CONTAINER_REGEXP+"expand_if_set"} ]]; then
		RM_CONTAINERS=$( docker ps -a | grep -E "$CONTAINER_REGEXP" )
	fi
}

# prompt "Are you sure" if option -f wasn't set
confirm_queue() {
	if [[ -z ${SILENT+"expand_if_set"} ]]; then
		printf "$RM_CONTAINERS$RM_IMAGES\n"
		read -p "Are you sure you want to delete these docker instances? (Yn) " GO_AHEAD

		if [[ -z $GO_AHEAD ]]; then
		GO_AHEAD="Y"
		fi
	else
		GO_AHEAD="Y"
	fi

	if [[ ! $GO_AHEAD == "Y" ]]; then
		printf "Exiting...\n"
		exit 0
	fi
}

# delete queue
delete_queue() {
	if [[ -n ${RM_CONTAINERS+"expand_if_set"} ]]; then
		while IFS="" read -r CONTAINER; do
			CONTAINER_ID=$( printf "$CONTAINER" | awk '{print $1}' )
		printf "Deleting container $CONTAINER_ID...\n"
		docker rm $CONTAINER_ID
		done < <( printf "$RM_CONTAINERS\n" )
	fi

	if [[ -n ${RM_IMAGES+"expand_if_set"} ]]; then
		while IFS="" read -r IMAGE; do
			IMAGE_ID=$( printf "$IMAGE" | awk '{print $3}' )
			docker rmi $IMAGE_ID

			if (( $? >= 1 )) && [[ -z ${SILENT+"expand_if_set"} ]];then
				# redirect input here because otherwise it reads from < <( printf "$RM_IMAGES" )
				read -p "Force deleted $IMAGE_ID? (Yn) " FORCE_DELETE <&1

				if [[ -n ${FORCE_DELETE+"expand_if_set"}} ]] && [[ $FORCE_DELETE == "Y" ]]; then
					docker rmi -f $IMAGE_ID
				fi
			fi
		done < <( printf "$RM_IMAGES\n" )
	fi

	printf "Done\n"
}

# Start script execution
parse_positional_params $@
queue_docker_entities
confirm_queue
delete_queue