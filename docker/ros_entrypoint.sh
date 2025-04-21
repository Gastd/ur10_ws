#!/bin/bash
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

set -e

if [[ -z "$WORKSPACE" ]] ; then 
  echo >&2 "Missing environment variable 'WORKSPACE'"
  exit 1
fi
cd -- "$WORKSPACE"

if [[ -z "$USER" ]] ; then 
  echo >&2 "Missing environment variable 'USER'"
  exit 2
fi

# joy_node needs to access joysticks via event interface
if [[ -d "/dev/input" ]] ; then
  chmod -R o+rw /dev/input
fi

# execute command as USER
exec sudo -snEHu "$USER" -- /ros_setup.sh $@

cd  
exec bash -i -c $@
