#!/bin/bash

clear
echo "===================================="
echo "        BASH TYPING GAME"
echo "===================================="
echo
echo "Welcome to the Ultimate Bash Typing Game!"
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
# Random character generator
generate_char() {
    letters=({a..z})
    index=$(( RANDOM % 26 ))
    echo "${letters[$index]}"
}

echo
rand_char=$(generate_char)
echo "Type this character: $rand_char"