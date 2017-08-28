#!/bin/bash

set -e

mkdir -p ~/.ssh
cat <<EOF >> ~/.ssh/config
Host *
ConnectTimeout 5
EOF

GITIGNORE_GLOBAL=~/.gitignore_global
cat <<EOF > $GITIGNORE_GLOBAL
*~
.*.swp
.DS_Store
.idea
EOF

# see e.g. https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
git config --global user.email "prime8@users.noreply.github.com"
git config --global user.name "prime8"
git config --global color.ui auto
git config --global core.editor vim
git config --global core.excludesfile $GITIGNORE_GLOBAL
git config --global push.default simple
git config --global merge.tool kdiff3

git config --list --global
