#!/bin/bash

LAST_DIR="$(pwd)"

while [ ! -d "$LAST_DIR/.git" ] && [ "$LAST_DIR" != "/" ]; do
	pushd "$LAST_DIR/.." > /dev/null
		LAST_DIR=$(pwd);
	popd > /dev/null
done

if [ "$LAST_DIR" != "/" ]; then
	cd "$LAST_DIR"
else
	echo "ERROR: No project root found."
fi
