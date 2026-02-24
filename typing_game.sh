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

while true
do
    clear
    echo "===================================="
    echo "        BASH TYPING GAME"
    echo "===================================="
    echo
    echo "1. Start Typing Challenge"
    echo "2. Exit"
    echo
    read -p "Choose an option: " choice

    if [ "$choice" -eq 1 ]; then
        start_game
        echo
        read -p "Press Enter to return to menu..."
    elif [ "$choice" -eq 2 ]; then
        echo "Exiting..."
        exit 0
    else
        echo "Invalid choice."
        sleep 1
    fi
done