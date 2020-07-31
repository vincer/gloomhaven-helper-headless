#!/usr/bin/env bash

version=$(echo -n $(cat VERSION))

re='([0-9]+)\.([0-9]+)\.?([0-9]*)'
[[ $version =~ $re ]]
major="${BASH_REMATCH[1]}"
minor="${BASH_REMATCH[2]:-0}"
patch="${BASH_REMATCH[3]:-0}"

echo "::set-output name=version::$version"
echo "::set-output name=major::$major"
echo "::set-output name=minor::$minor"
echo "::set-output name=patch::$patch"
