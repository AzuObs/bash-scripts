#!/bin/bash

# rename files in cwd (where script is called) from PascalCase to camelCase

for FILE in $( ls ); do
	LETTERS_FIRST="${FILE:0:1}"
	LETTERS_REST="${FILE:1}"
	LETTERS_FIRST_LOWER="${LETTERS_FIRST,,}"
	NEW_FILE="$LETTERS_FIRST_LOWER$LETTERS_REST"

	if [[ ! $FILE == $NEW_FILE ]]; then
		mv "./$FILE" "./$NEW_FILE"
	fi
done
