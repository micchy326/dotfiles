#!/usr/bin/env zsh

cd ${1}
git_status=("${(f)$(git status --porcelain --branch 2> /dev/null)}")
if [[ $? -ne 0 ]]; then
    echo -n "Not a git repository ${1}"
    exit 0
fi

typeset -A git_info
git_info[branch]="${${git_status[1]}#\#\# }"
shift git_status
git_info[modified]=${#${(M)git_status:#?M*}}
git_info[added]=${#${(M)git_status:#A?*}}
echo ${git_info[added]}
add=${#${(M)git_status:#M?*}}
git_info[added]=$((add + git_info[added]))
echo ${git_info[added]}
git_info[untracked]=${#${(M)git_status:#\?\?*}}
local git_indicator=("${git_info[branch]}")
(( ${git_info[modified]} )) && git_indicator+=("${git_info[modified]} modified")
(( ${git_info[added]} )) && git_indicator+=("${git_info[added]} added")
(( ${git_info[untracked]} )) && git_indicator+=("${git_info[untracked]} untracked")

echo -n ${git_indicator} ${1}
