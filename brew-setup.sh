#!/bin/bash

set -e

if ! (which brew 1>/dev/null); then
  echo "Installing xcode command-line tools..."
  xcode-select --install

  # https://brew.sh
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew --version
  echo "Updating..."
  brew update && brew upgrade --formula
fi

echo "Checking for out-of-date casks..."
brew outdated --cask
