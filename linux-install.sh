#!/bin/bash
set -e

git --version  >/dev/null 2>&1
GIT_IS_AVAILABLE=$?

if [ ! $GIT_IS_AVAILABLE -eq 0 ]; then
    echo "Unable to find Git..."
    echo "Please install Git before running this command again"
    exit 1
fi

cd "$HOME" || exit 1

git https://github.com/JateNensvold/environment.git
./environment/scripts/linux-setup