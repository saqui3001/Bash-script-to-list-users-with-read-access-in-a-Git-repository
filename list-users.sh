#!/bin/bash

######################
# Author: Saqui
# Date: 5th-July
# Version: V1
# Description: This script is to list users with read access in a Git repository
# Usage:
# At first setup GitHub username & Access token it the command prompt with the following commands
# export username="user-name"
# export token="github-access-token"
# or, you can setup the GitHub username & Access token in the script in line number 23 & 24.
# Next, run the script with REPO_OWNER and REPO_NAME parameters as below,
# $ ./list-users.sh REPO_OWNER REPO_NAME
######################

set -x    # to turn on debug mode, to show command before output
set -e  # exit the script when there is an error, but it doesn't work if there is a pipe
set -o pipefail  # that is why this command is used too

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

exit 0
