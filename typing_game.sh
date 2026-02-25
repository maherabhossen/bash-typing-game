#!/bin/bash

start_game() {
    difficulty=$1
    if [ "$difficulty" = "easy" ]; then
        words=("cat" "dog" "sun" "map" "pen" "tree" "book")
    elif [ "$difficulty" = "medium" ]; then
        words=("apple" "train" "cloud" "keyboard" "linux" "script")
    else
        words=("function" "variable" "terminal" "algorithm" "parameter")
    fi
    interrupted=false
    trap "interrupted=true" SIGINT
    
    score=0
    correct=0
    total=0
    typed_words=()
    correct_words=()
    duration=10
    start_time=$SECONDS

    echo "Game Started! You have $duration seconds."
    echo "----------------------------------------"

    last_word=""

    while [ $(($SECONDS - start_time)) -lt $duration ] && [ "$interrupted" = false ]
    do
        # Pick a new word that is NOT the same as the last one
        while true; do
            index=$(( RANDOM % ${#words[@]} ))
            random_word=${words[$index]}
            if [ "$random_word" != "$last_word" ]; then
                break
            fi
        done
        last_word=$random_word
        
        echo "Type this word: $random_word"

        if read -t 3 user_input; then
            total=$((total + 1))
            typed_words+=("$user_input")
        else
            echo "Timeout!"
            continue
        fi

        if [ "$user_input" = "$random_word" ]; then
            echo "Correct!"
            score=$((score + 1))
            correct=$((correct + 1))
            correct_words+=("$random_word")
        else
            echo "Wrong!"
        fi

        echo "Score: $score"
        echo "----------------------"
    done
    if [ "$interrupted" = true ]; then
        echo
        echo "Game interrupted!"
    fi

    # echo "Time's up!"
    # echo "Final Score: $score"

    # if [ $total -gt 0 ]; then
    #     accuracy=$(( 100 * correct / total ))
    # else
    #     accuracy=0
    # fi

    # echo "Accuracy: $accuracy%"
    # trap - SIGINT
    # echo
    # read -p "Press Enter to return to menu..."
    echo
    echo "===================================="
    echo "            GAME RESULTS"
    echo "===================================="
    echo

    echo "Total Words Typed : $total"
    echo "Correct Words     : $correct"

    if [ $total -gt 0 ]; then
        accuracy=$(( 100 * correct / total ))
    else
        accuracy=0
    fi

    echo "Accuracy          : $accuracy%"
    echo

    echo "Words You Typed:"
    printf "  %s\n" "${typed_words[@]}"
    echo

    echo "Correct Words:"
    printf "  %s\n" "${correct_words[@]}"
    echo
    
    trap - SIGINT

    echo
    read -p "Press Enter to return to menu..."
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
        echo "Select Difficulty:"
        echo "1. Easy"
        echo "2. Medium"
        echo "3. Hard"

        read -p "Choose difficulty: " level

        if [ "$level" -eq 1 ]; then
            start_game easy
        elif [ "$level" -eq 2 ]; then
            start_game medium
        elif [ "$level" -eq 3 ]; then
            start_game hard
        else
            echo "Invalid difficulty."
        fi
    elif [ "$choice" -eq 2 ]; then
        echo "Exiting..."
        exit 0
    else
        echo "Invalid choice."
        sleep 1
    fi
done