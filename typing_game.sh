#!/bin/bash

clear
echo "===================================="
echo "        BASH TYPING GAME"
echo "===================================="
echo
echo "1. Start Game"
echo "2. Exit"
echo
read -p "Choose an option: " choice

if [ "$choice" -eq 1 ]; then
    echo "Starting game..."
elif [ "$choice" -eq 2 ]; then
    echo "Exiting..."
    exit 0
else
    echo "Invalid choice."
fi