#!/bin/bash

# Remove some files
rm -r AppSpamBlock.xcodeproj

# Gen samples project
xcodegen

open AppSpamBlock.xcodeproj
