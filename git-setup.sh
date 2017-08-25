#!/bin/bash

mkdir ~/.ssh
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

git config --global user.email "prime8@users.noreply.github.com"
git config --global user.name "prime8"
git config --global color.ui auto
git config --global core.editor vim
git config --global core.excludesfile $GITIGNORE_GLOBAL
git config --global push.default simple
git config --global merge.tool kdiff3

git config --list --global
