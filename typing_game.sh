#!/bin/bash

start_game() {
    score=0

    echo "Game Started!"
    echo "Press Ctrl+C to stop."

    while true
    do
        random_char=$(tr -dc 'a-z' </dev/urandom | head -c 1)
        echo "Type this: $random_char"

        read user_input

        if [ "$user_input" = "$random_char" ]; then
            echo "Correct!"
            score=$((score + 1))
        else
            echo "Wrong!"
        fi

        echo "Score: $score"
        echo "----------------------"
    done
}

clear
echo "===================================="
echo "        BASH TYPING GAME"
echo "===================================="
echo
echo "Welcome to the Ultimate Bash Typing Game!"
echo
echo "1. Start Typing Challenge"
echo "2. Exit"
echo
read -p "Choose an option: " choice

if [ "$choice" -eq 1 ]; then
    echo "Starting game..."
    start_game
    
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

score=0

read -p "Type the character: " user_char

if [ "$user_char" == "$rand_char" ]; then
    echo "Correct!"
    ((score++))
else
    echo "Incorrect!"
fi

echo "Your score: $score"