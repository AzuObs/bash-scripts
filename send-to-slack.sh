#!/bin/bash

SERVICE=${1:?'First parameter must be a service'}

if [[ -s /dev/stdin ]]; then
	curl -v "https://hooks.slack.com/services/${SERVICE}" \
	-H "Content-Type: application/json" \
	-d @- << EOF
		{"text": "Open pull requests\n $( cat /dev/stdin )"}
	EOF
fi
