#!/bin/sh -e

INFO_PLIST="MusicArchive/Info.plist"
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFO_PLIST")
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFO_PLIST"
