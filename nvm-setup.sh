#!/bin/bash

set -e

# See https://github.com/nvm-sh/nvm

LATEST_NVM=$(curl -Is https://github.com/nvm-sh/nvm/releases/latest | grep -i 'location:' | awk -F \/ '{print $NF}' | tr -d \[:cntrl:\])
CURRENT_NVM="$(grep '"version":' ~/.nvm/package.json | awk -F\" '{print "v"$(NF-1)}')"

if [[ "$CURRENT_NVM" == "" || "$CURRENT_NVM" != "$LATEST_NVM" ]]; then
  INSTALLER=https://raw.githubusercontent.com/nvm-sh/nvm/$LATEST_NVM/install.sh
  echo "Installing $INSTALLER"
  curl -s -o- $INSTALLER | bash
else
  echo "Using nvm $CURRENT_NVM..."
fi

source ~/.nvm/nvm.sh

set +e

RECENT_NODE_VERSIONS=$(nvm ls-remote --lts | awk -F '[v.]' '{print $(NF-2)}' | sort -rn | uniq | head -2)
for i in $RECENT_NODE_VERSIONS; do 
  echo "*****************"
  echo "Setting up node $i"
  latest=$(nvm version-remote $i)
  current=$(nvm version $i)
  if [ "$latest" == "$current" ]; then
    echo "Latest $i => $latest is already installed"
    nvm use $i
  else
    echo "Installing latest $i => $latest..."
    nvm install --no-progress $i
  fi
done
