#!/bin/bash

# Set the path to the root directory that hosts your GitHub repositories, for example the one below.
# If you have multiple locations that hosts the GitHub repositories, put the root folders in the array
#    below, separated by spaces.
declare -a pathSet=( ${HOME}/code/github/me/ ${HOME}/another_path/that/hosts/github/rpos )

# Refer to https://en.wikipedia.org/wiki/ANSI_escape_code for colored escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'           # No Color


for srcPath in "${pathSet[@]}"; do

    echo -e "\n\n===== Searching and updating GitHub source code under ${srcPath} ... =====\n\n"

    if [ ! -d $srcPath ]; then
        printf "\n${RED}$srcPath${NC} does ${RED}NOT${NC} exist\n\n"
        continue
    fi

    pushd $srcPath

    for dir in ./*/ ; do
        printf "\nSyncing git source in $(dirname $(readlink -e $dir))/$(basename $dir) ...\n"
        cd $dir

        gitBranch=$(git branch --show-current)
        printf "\tBranch: ${GREEN}$gitBranch${NC} "
        if [[ "$gitBranch" = "master" || "$gitBranch" = "main" ]] ; then
            printf "\n"
            git remote update -p
            git rebase
            git pull
        else
            echo -e "\t\t${RED}skip it${NC}\n"
        fi


        cd ..
    done

    popd

done
echo -e "\n===== Done =====\n"
