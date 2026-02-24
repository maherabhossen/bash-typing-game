#!/bin/bash

start_game() {
    trap "echo; echo 'Game interrupted! Returning to menu...'; return" SIGINT
    
    score=0
    correct=0
    total=0
    duration=10
    start_time=$SECONDS

    echo "Game Started! You have $duration seconds."
    echo "----------------------------------------"

    words=("apple" "train" "cloud" "keyboard" "linux" "script" "terminal" "function" "variable" "random")

    while [ $(($SECONDS - start_time)) -lt $duration ]
    do
        index=$(( RANDOM % ${#words[@]} ))
        random_word=${words[$index]}
        echo "Type this word: $random_word"

        read -t 3 user_input

        total=$((total + 1))

        if [ "$user_input" = "$random_word" ]; then
            echo "Correct!"
            score=$((score + 1))
            correct=$((correct + 1))
        else
            echo "Wrong or Timeout!"
        fi

        echo "Score: $score"
        echo "----------------------"
    done

    echo "Time's up!"
    echo "Final Score: $score"

    if [ $total -gt 0 ]; then
        accuracy=$(( 100 * correct / total ))
    else
        accuracy=0
    fi

    echo "Accuracy: $accuracy%"
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