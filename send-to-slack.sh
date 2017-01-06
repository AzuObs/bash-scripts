#!/bin/bash

SERVICE={1:?'First parameter must be a service'}

curl "https://hooks.slack.com/services/${SERVICE}" \
-H "Content-Type: application/json" \
-d @- << EOF
	{"text": "$( cat /dev/stdin )"}
EOF
