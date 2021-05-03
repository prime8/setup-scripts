#!/bin/bash

for d in $(find . -mindepth 1 -maxdepth 2 -type d -iname '.git' | sort); do
  PULLDIR=$(dirname $d)
  pushd $PULLDIR >/dev/null
  if [ "$PULLDIR" == "." ]; then
    PULLDIR=$(pwd | xargs basename)
  fi

  echo -n "$(tput setaf 6)$PULLDIR$(tput sgr 0) "

  if ! (git diff-index --quiet HEAD); then
    git status --branch --short
  else
    DEFAULT_BRANCH=$(git branch -av | grep 'origin/HEAD' | awk '{print $3}' | cut -d/ -f2)
    BRANCH=$(test "$DEFAULT_BRANCH" != "" && echo $DEFAULT_BRANCH || echo master)
    git checkout $BRANCH --quiet
    git fetch --quiet --all --prune
    git pull --rebase

    for merged in $(git branch --merged | egrep -v "$BRANCH|master"); do
      git branch -d $merged
    done

    git branch -av | grep '\[gone\]' | awk '{print $1}' | xargs -n 1 git branch -D
  fi

  popd 2>&1 >/dev/null
done
