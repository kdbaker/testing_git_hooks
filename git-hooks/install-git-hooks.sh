#!/bin/sh
# Based on: https://gist.github.com/pixelhandler/5718585
# This script will install Git hooks to your local repo
# Install in current Git repo:
# sh git-hooks/install-git-hooks.sh

# Uninstall:
# rm .git/hooks/HOOK_NAME
# in each repository that you've added this to.

HOOK_NAMES=( pre-push pre-commit applypatch-msg pre-applypatch post-applypatch prepare-commit-msg commit-msg post-commit pre-rebase post-checkout post-merge pre-receive update post-receive post-update pre-auto-gc )
GITROOT=`git rev-parse --show-toplevel 2> /dev/null`
HOOK_DIR=$GITROOT/.git/hooks

for hook in "${HOOK_NAMES[@]}"
do

    # check if in a git repo
    if [ "$GITROOT" == "" ]; then
      echo This does not appear to be a git repo.
      exit 1
    fi

    is_not_installed='true'

    # check if hook is already installed
    if [ -f "$GITROOT/.git/hooks/$hook" ]; then
      is_not_installed='false'
      echo There is already a $hook hook installed. Delete it first.
      echo "    rm '$GITROOT/.git/hooks/$hook'"
      echo
      continue
    fi

    # if the hook exists in git-hooks dir then simlink it
    if [ -f "$GITROOT/git-hooks/$hook" ] && [ $is_not_installed = 'true' ]; then
      echo Setting up simlink to $hook

      ln -s -f $GITROOT/git-hooks/$hook $GITROOT/.git/hooks/$hook

      chmod +x "$GITROOT/.git/hooks/$hook"
    fi

done
