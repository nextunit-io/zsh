#!/bin/bash

# This script exports the AWS tokens to your environment, so you could switch profiles
# without setting the exported AWS_PROFILE variable.
#
# This is useful if you need direct access to your AWS tokens, e.g. you'd like
# to sign a AWS Gateway request and this endpoint is secured by IAM.
#
# To use this script just execute:
#    source aws_exports.sh <profile name>
#
# If you do not specify the profile, you'd like to use it will be default to
# the exported AWS_PROFILE. If there is no profile in the exported variables available
# or the aws credentials file does not contain the profile it will fail.
#
# At the end of that script it will unset the exported AWS_PROFILE, so you could use
# directly the aws cli with the exported token credentials.

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