#!/bin/bash

log_repo_names() {
	node -e \
	"
        var reposJSON = '';
        process.stdin.setEncoding('utf8');
       	process.stdin.on('data', data => reposJSON += data);
        process.stdin.on('end', () => JSON.parse(reposJSON).forEach(repo => console.log(repo.name)));
	"
}

log_user_pulls() {
	node -e \
	"
	var userName = process.argv[1];
	var pullsJSON = '';
	process.stdin.setEncoding('utf8');
        process.stdin.on('data', data => pullsJSON += data);
        process.stdin.on('end', () => {
		var pulls = JSON.parse(pullsJSON) || [];
		pulls.forEach(pull => {
			if (pull.state === 'open') {
				console.log(pull.title + ' by ' + pull.user.login  +' ' +  pull.url);
			}
		});
	});
	"
}

USER=${1:?'First argument must be your case sensitive github username'}
PASSWORD=${2:?'Second argument must be your github password'}
ORG=${3:?'Third argument must be your github org'}

REPO_NAMES=$( curl -s -G "https://api.github.com/orgs/$ORG/repos" -u "$USER:$PASSWORD" --data-urlencode "per_page=1000" | log_repo_names )

while IFS="" read -r REPO_NAME
do
	curl -s -G "https://api.github.com/repos/$ORG/$REPO_NAME/pulls" -u "$USER:$PASSWORD" | log_user_pulls
done <<< "$REPO_NAMES"
