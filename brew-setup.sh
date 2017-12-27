#!/bin/bash

set -e

# https://brew.sh
if ! (which brew 1>/dev/null); then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew --version
  echo "Updating..."
  brew update && brew upgrade; brew cleanup
fi

# https://caskroom.github.io
if ! (brew tap | grep -q 'caskroom/cask'); then
  echo "Installing caskroom..."
  brew tap caskroom/cask
else
  brew cask --version
  echo "Checking for out-of-date casks..."
  brew cask outdated &&  brew cask cleanup
fi
