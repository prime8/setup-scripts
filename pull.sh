#!/bin/bash

mainbranch () {
  local HEAD_BRANCH=""
  local loop=1

  while [ "$HEAD_BRANCH" = "" -a $loop -le 2 ]; do
    if [ $loop -eq 2 ]; then
      git remote set-head $1 --auto > /dev/null
    fi
    HEAD_BRANCH=$(git branch -av | grep "remotes/$1/HEAD" | awk '{print $3}' | cut -d/ -f2)
    loop=$(( $loop + 1 ))
  done

  echo $HEAD_BRANCH
}

pull () {
  local REMOTE=$(git remote)
  if [ "$REMOTE" = "" ]; then
    echo "-- No remote --"
    return
  fi

  git fetch --quiet --all --prune

  local BRANCH=$(mainbranch $REMOTE)
  if [ "$BRANCH" = "" ]; then
    echo "-- Unable to determine main branch for remote '$REMOTE' --"
    return
  fi

  git checkout $BRANCH --quiet
  git pull --rebase

  for merged in $(git branch --merged | egrep -v "$BRANCH"); do
    git branch -d $merged
  done

  git branch -av | grep '\[gone\]' | awk '{print $1}' | xargs -n 1 git branch -D
}

for d in $(find . -mindepth 1 -maxdepth 2 -type d -iname '.git' | sort); do
  PULLDIR=$(dirname $d)
  pushd $PULLDIR >/dev/null
  if [ "$PULLDIR" = "." ]; then
    PULLDIR=$(pwd | xargs basename)
  fi

  echo -n "$(tput setaf 6)$PULLDIR$(tput sgr 0) "

  if ! (git diff-index --quiet HEAD); then
    git status --branch --short
  else
   pull $PULLDIR
  fi

  popd 2>&1 >/dev/null
done
