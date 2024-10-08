#!/bin/bash

# Remove some files
rm -r CallSMSBlock.xcodeproj

# Gen samples project
xcodegen

open CallSMSBlock.xcodeproj