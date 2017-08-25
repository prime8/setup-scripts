#!/bin/bash

PATTERN=$1
if [[ "$PATTERN" == "" ]]; then
  echo "Usage: $0 <pattern>"
  exit 1
fi

for d in $(find . -mindepth 1 -maxdepth 2 -type d -iname '.git' | sort); do
  GREPDIR=$(dirname $d)
  pushd $GREPDIR >/dev/null
  if [[ "$GREPDIR" == "." ]]; then
    GREPDIR=$(pwd | xargs basename)
  fi

  if ( git grep -q $PATTERN ); then
    echo "$(tput setaf 6)$GREPDIR$(tput sgr 0)"
    for m in $(git grep -l $PATTERN); do
      echo $m
    done
  fi

  popd 2>&1 >/dev/null
done
