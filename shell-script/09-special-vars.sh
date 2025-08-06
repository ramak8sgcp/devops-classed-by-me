#!/bin/bash

echo "All variables passed to the script: $@"
echo "Number of variable passed: $#"
echo "Script Name: $0"
echo "Current working directory: $PWD"
echo "Home directory of the current user: $HOME"
echo "PID of the script executing now: $$"
sleep 100 &
echo "PID of last background command: $!"