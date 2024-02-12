#!/bin/bash

# Determine the script's directory
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define the files containing advices, reminders, and jokes
advices_file="$BASE_DIR/advices.txt"
reminders_file="$BASE_DIR/reminders.txt"
jokes_file="$BASE_DIR/jokes.txt"

# Define arrays to keep track of sent texts
sent_advices=()
sent_reminders=()
sent_jokes=()

# Check if the -nosound or --nosound argument is provided
sound=true
if [[ $1 == "-nosound" ]] || [[ $1 == "--nosound" ]]; then
    sound=false
fi

# Function to display usage information
usage() {
    echo "Usage: $0 [-h|--help] [-nosound|--nosound]"
    echo
    echo "This script is designed to help you improve your poker game by providing advices, reminders, and jokes. It randomly selects and displays a piece of advice, a reminder, or a joke from its respective text file every 2 minutes. The script ensures that the same text is not repeated until all texts in the file have been displayed."
    echo
    echo "Options:"
    echo "-h, --help      Display this help message."
    echo "-nosound, --nosound  Run the script without sound. By default, a different sound is played depending on whether an advice, a reminder, or a joke is displayed."
    exit
}

# Check if the -h or --help argument is provided
if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
    usage
fi

# Function to read a random line from a file
read_random_line() {
    local file=$1
    local lines=$(cat $file | wc -l)
    local random_line=$((RANDOM % $lines + 1))
    local text=$(sed "${random_line}q;d" $file)

    # Check if the text has already been sent
    if [[ $file == $advices_file && " ${sent_advices[@]} " =~ " ${text} " ]] ||
       [[ $file == $reminders_file && " ${sent_reminders[@]} " =~ " ${text} " ]] ||
       [[ $file == $jokes_file && " ${sent_jokes[@]} " =~ " ${text} " ]]; then
        # If the text has already been sent, read another random line
        read_random_line $file
    else
        # If the text has not been sent, add it to the corresponding array and print it
        if [[ $file == $advices_file ]]; then
            sent_advices+=("$text")
        elif [[ $file == $reminders_file ]]; then
            sent_reminders+=("$text")
        elif [[ $file == $jokes_file ]]; then
            sent_jokes+=("$text")
        fi
        echo "$text"
        notify-send "$text"  # Send a notification
    fi
}

# Function to handle SIGINT signal
handle_sigint() {
	echo
    echo "Listen up, you absolute donkey. You just lost because you played like a complete buffoon. Every hand in poker is foldable, you know? It's not the cards that are to blame, it's your lousy decision-making. You chose to play those cards, and look where it got you."
    echo
	echo "But hey, don't get all worked up about it. Take a breather. Go rest, cool down. You're no good to anyone if you're on tilt. Remember, poker is a marathon, not a sprint. You've got to keep your head in the game. So take some time off, get your head straight, and come back when you're ready to play like a pro."
    exit
}

# Set a trap to catch SIGINT and call handle_sigint function
trap handle_sigint SIGINT

# Main loop
while true; do
    clear

    # Choose a random file
    random_file=$((RANDOM % 3))

    # Check if all jokes have been sent
    if [[ ${#sent_jokes[@]} -eq 50 ]]; then
        # If all jokes have been sent, exclude jokes from the selection process
        random_file=$((RANDOM % 2))
    fi

    if [[ $random_file -eq 0 ]]; then
        echo "Advice:"
        read_random_line $advices_file
        # Play a bell sound if sound is enabled
        if $sound; then
            echo -e "\a"
            mpg123 -q $BASE_DIR/sounds/great-bell.mp3
        fi
    elif [[ $random_file -eq 1 ]]; then
        echo "Reminder:"
        read_random_line $reminders_file
        # Play a bell sound if sound is enabled
        if $sound; then
            echo -e "\a"
            mpg123 -q $BASE_DIR/sounds/simple-buzzer.mp3
        fi
    else
        echo "Joke:"
        read_random_line $jokes_file
        # Play a bell sound if sound is enabled
        if $sound; then
            echo -e "\a"
            mpg123 -q $BASE_DIR/sounds/ding-dong.mp3
        fi
    fi

    echo
    echo "To exit: press CTRL + C"

    # Check if all advices, reminders, and jokes have been sent
    if [[ ${#sent_advices[@]} -eq 125 && ${#sent_reminders[@]} -eq 125 && ${#sent_jokes[@]} -eq 50 ]]; then
        # If all have been sent, reset and restart fresh
        sent_advices=()
        sent_reminders=()
        sent_jokes=()
    fi

    # Wait for 2 minutes
    sleep 120
done
