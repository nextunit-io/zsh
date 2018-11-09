#!/bin/bash

PROFILE="$(echo "$AWS_PROFILE")"

# Profile override...
if [ -n "$1" ]; then
    PROFILE="$1" 
fi

if [ -z "$PROFILE" ]; then
    echo "You need to specify a profile. Ether as argument (${0} <profile>) or via export (export AWS_PROFILE=<profile>)."
    return 1
fi

tmp_file=$(mktemp)
sed -n '1,/'"$PROFILE"'/d;/\[/,$d;/^$/d;p' "$HOME/.aws/credentials" > $tmp_file

content="$(cat $tmp_file)"
if [ -z "$content" ]; then
    echo "No profile $PROFILE available."
    return 2
fi

source $tmp_file

export AWS_SESSION_TOKEN="$aws_session_token"
export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"
export AWS_ACCESS_KEY_ID="$aws_access_key_id"

unset AWS_PROFILE

echo "Environment variables updates and AWS_PROFILE removed."