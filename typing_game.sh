#!/bin/bash

# ===============================
# BASH TYPING GAME PRO - DIALOG
# ===============================

HIGH_SCORE_FILE="highscores.txt"
touch "$HIGH_SCORE_FILE"

# Words per difficulty
WORDS_EASY=("cat" "dog" "sun" "map" "pen" "tree" "book")
WORDS_MEDIUM=("apple" "train" "cloud" "keyboard" "linux" "script")
WORDS_HARD=("function" "variable" "terminal" "algorithm" "parameter")

# ===============================
# Show Leaderboard
# ===============================
show_leaderboard() {
    if [ ! -s "$HIGH_SCORE_FILE" ]; then
        dialog --title "Leaderboard" --msgbox "No scores yet!" 10 40
        return
    fi

    leaderboard=$(sort -t',' -k2 -nr "$HIGH_SCORE_FILE" | head -10 | awk -F',' '{printf "%-15s Score:%-4s Acc:%-3s%% WPM:%-3s\n",$1,$2,$3,$4}')
    dialog --title "Leaderboard - Top 10" --msgbox "$leaderboard" 20 60
}

# ===============================
# Start Game Function
# ===============================
start_game() {
    local player_name=$1
    local difficulty=$2

    case $difficulty in
        easy) words=("${WORDS_EASY[@]}"); duration=15 ;;
        medium) words=("${WORDS_MEDIUM[@]}"); duration=20 ;;
        hard) words=("${WORDS_HARD[@]}"); duration=25 ;;
    esac

    # Shuffle words for no repeats
    words_shuffled=($(printf "%s\n" "${words[@]}" | shuf))
    word_index=0

    score=0
    correct=0
    total=0
    typed_words=()
    shown_words=()

    start_time=$SECONDS

    interrupted=false

    # Main game loop
    while [ $word_index -lt ${#words_shuffled[@]} ] && [ $((SECONDS - start_time)) -lt $duration ]; do
        random_word="${words_shuffled[$word_index]}"
        shown_words+=("$random_word")

        # Progress gauge percentage
        percent=$(( (SECONDS - start_time) * 100 / duration ))
        [ $percent -gt 100 ] && percent=100

        # Display input box with progress gauge
        user_input=$(dialog --title "Typing Game" \
            --inputbox "Type this word: $random_word\nScore: $score\nTime left: $((duration-(SECONDS-start_time)))s" 10 50 2>&1 >/dev/tty)

        exit_status=$?
        if [ $exit_status -ne 0 ]; then
            interrupted=true
            break
        fi

        typed_words+=("$user_input")
        total=$((total+1))

        if [ "$user_input" = "$random_word" ]; then
            correct=$((correct+1))
            score=$((score+1))
        fi

        word_index=$((word_index+1))
    done

    # Calculate accuracy and WPM
    if [ $total -gt 0 ]; then
        accuracy=$((100*correct/total))
    else
        accuracy=0
    fi

    elapsed=$((SECONDS - start_time))
    if [ $elapsed -gt 0 ]; then
        wpm=$((correct * 60 / elapsed))
    else
        wpm=0
    fi

    # Prepare detailed results
    result_text="Player: $player_name\nDifficulty: $difficulty\n\nTotal Words: $total\nCorrect: $correct\nAccuracy: $accuracy%\nWPM: $wpm\n\n"
    result_text+="Detailed Results:\n------------------------------------\n"

    for ((i=0;i<${#typed_words[@]};i++)); do
        result_text+="Word $((i+1))  Shown: ${shown_words[$i]}  Typed: ${typed_words[$i]}"
        if [ "${typed_words[$i]}" = "${shown_words[$i]}" ]; then
            result_text+="  ✅ Correct\n"
        else
            result_text+="  ❌ Wrong\n"
        fi
    done

    # Show results in dialog
    dialog --title "Game Results" --msgbox "$result_text" 25 70

    # Save high score
    echo "$player_name,$score,$accuracy,$wpm" >> "$HIGH_SCORE_FILE"
}

# ===============================
# MAIN MENU
# ===============================
while true; do
    choice=$(dialog --title "BASH TYPING GAME PRO" --menu "Select an option:" 15 50 5 \
        1 "Start Game" \
        2 "Leaderboard" \
        3 "Exit" 2>&1 >/dev/tty)
    clear

    case $choice in
        1)
            player_name=$(dialog --title "Enter Name" --inputbox "Your Name:" 10 40 2>&1 >/dev/tty)
            diff_choice=$(dialog --title "Difficulty" --menu "Select Difficulty:" 15 40 3 \
                1 "Easy" \
                2 "Medium" \
                3 "Hard" 2>&1 >/dev/tty)
            case $diff_choice in
                1) start_game "$player_name" easy ;;
                2) start_game "$player_name" medium ;;
                3) start_game "$player_name" hard ;;
            esac
            ;;
        2)
            show_leaderboard
            ;;
        3)
            break
            ;;
        *)
            dialog --msgbox "Invalid choice" 5 30
            ;;
    esac
done

clear
echo "Thanks for playing!"