#!/bin/bash

FOLDER=${1:?"First parameter must be the folder"}

for FILE in $( ls $FOLDER )
do
	mv "$FOLDER/$FILE" "$FOLDER/${FILE##favicon@}"
done


