#!/bin/sh

cd ../
# Install CocoaPods using Homebrew.
brew install cocoapods

# Install dependencies you manage with CocoaPods.
pod install
