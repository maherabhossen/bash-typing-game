#!/bin/bash

start_game() {
    score=0
    duration=10
    start_time=$SECONDS

    echo "Game Started! You have $duration seconds."
    echo "----------------------------------------"

    while [ $(($SECONDS - start_time)) -lt $duration ]
    do
        random_char=$(tr -dc 'a-z' </dev/urandom | head -c 1)
        echo "Type this: $random_char"

        read -t 3 user_input

        if [ "$user_input" = "$random_char" ]; then
            echo "Correct!"
            score=$((score + 1))
        else
            echo "Wrong or Timeout!"
        fi

        echo "Score: $score"
        echo "----------------------"
    done

    echo "Time's up!"
    echo "Final Score: $score"
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
    start_game
elif [ "$choice" -eq 2 ]; then
    echo "Exiting..."
    exit 0
else
    echo "Invalid choice."
fi