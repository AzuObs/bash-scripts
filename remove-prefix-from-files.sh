#!/bin/bash

FOLDER=${1:?"First parameter must be the folder"}
PREFIX=${2:?"Second parameter must be a prefix"}

for FILE in $( ls $FOLDER )
do
	mv "$FOLDER/$FILE" "$FOLDER/${FILE#$PREFIX}"
done


