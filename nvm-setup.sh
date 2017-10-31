#!/bin/bash

set -e

# See https://github.com/creationix/nvm

LATEST_NVM=$(curl -Is https://github.com/creationix/nvm/releases/latest | grep 'Location:' | awk -F \/ '{print $NF}' | tr -d [:cntrl:])
CURRENT_NVM="$(grep '"version":' ~/.nvm/package.json | awk -F\" '{print "v"$(NF-1)}')"

if [[ "$CURRENT_NVM" == "" || "$CURRENT_NVM" != "$LATEST_NVM" ]]; then
  INSTALLER=https://raw.githubusercontent.com/creationix/nvm/$LATEST_NVM/install.sh
  echo "Installing $INSTALLER"
  curl -o- $INSTALLER | bash
else
  echo "Using nvm $CURRENT_NVM..."
fi

source ~/.nvm/nvm.sh

set +e

for i in 4 6 8; do 
  echo "*****************"
  echo "Setting up node $i"
  latest=$(nvm version-remote $i)
  current=$(nvm version $i)
  if [ "$latest" == "$current" ]; then
    echo "Latest $i => $latest is already installed"
    nvm use $i
  else
    echo "Installing latest $i => $latest..."
    nvm install $i
  fi

  echo "Setting up global packages"
  npm install --global npm-check-updates nsp yo
done
