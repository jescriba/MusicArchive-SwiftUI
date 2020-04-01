#!/bin/bash
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
HOOKS_DIR="$SCRIPT_PATH/../../.git/hooks"
mkdir -p "$HOOKS_DIR"

cp -v "$SCRIPT_PATH/pre-commit" "$HOOKS_DIR/pre-commit"
cp -v "$SCRIPT_PATH/xcodegen" "$HOOKS_DIR/post-checkout"
cp -v "$SCRIPT_PATH/xcodegen" "$HOOKS_DIR/post-merge"
