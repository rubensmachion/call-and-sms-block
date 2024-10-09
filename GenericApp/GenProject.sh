#!/bin/bash

# Remove some files
rm -r GenericApp.xcodeproj

# Gen samples project
xcodegen

open GenericApp.xcodeproj
