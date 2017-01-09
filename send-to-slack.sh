#!/bin/bash

SERVICE=${1:?'First parameter must be a service'}

TEXT=$( sed 's/$/\\n/g' /dev/stdin )

curl -v "https://hooks.slack.com/services/${SERVICE}" \
-H "Content-Type: application/json" \
-d @- <<< "{\"text\": \"$TEXT\"}"
