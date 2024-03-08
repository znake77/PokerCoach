#!/bin/bash

# Determine the script's directory
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define the files containing advices, reminders, philosopher, and jokes
advices_file="$BASE_DIR/advices.txt"
reminders_file="$BASE_DIR/reminders.txt"
jokes_file="$BASE_DIR/jokes.txt"
philosopher_file="$BASE_DIR/philosopher.txt"

# Check if the required files exist
if [ ! -f "$advices_file" ]; then
    echo "File $advices_file does not exist."
    exit 1
fi

if [ ! -f "$reminders_file" ]; then
    echo "File $reminders_file does not exist."
    exit 1
fi

if [ ! -f "$jokes_file" ]; then
    echo "File $jokes_file does not exist."
    exit 1
fi

if [ ! -f "$philosopher_file" ]; then
    echo "File $philosopher_file does not exist."
    exit 1
fi

# Define arrays to keep track of sent texts
sent_advices=()
sent_reminders=()
sent_jokes=()
sent_philosopher=()

# Check if the -nosound, --nosound, --no-voice, -h, or --help argument is provided
for arg in "$@"
do
    case $arg in
        -nosound|--nosound)
            sound=false
            shift
            ;;
        --no-voice)
            voice=false
            shift
            ;;
        -h|--help)
            usage
            ;;
    esac
done

# Function to display usage information
usage() {
    echo "Usage: $0 [-h|--help] [-nosound|--nosound] [--no-voice]"
    echo
    echo "This script is designed to help you improve your poker game by providing advices, reminders, philosopher sentences and jokes. It randomly selects and displays a piece of advice, a reminder, a philosopher sentence or a joke from its respective text file every 2 minutes. The script ensures that the same text is not repeated until all texts in the file have been displayed."
    echo
    echo "Options:"
    echo "-h, --help      Display this help message."
    echo "-nosound, --nosound  Run the script without sound. By default, a different sound is played depending on whether an advice, a reminder, a philosopher sentence or a joke is displayed."
    echo "--no-voice      Run the script without voice. By default, a voice reads the messages."
    exit
}


# Check if mailx and fetchmail commands are installed
if ! command -v festival &> /dev/null
then
    printf "The 'festival' command could not be found. Please install it by running 'sudo apt-get install festival'\n"
    exit
fi

if ! command -v mpg123 &> /dev/null
then
    printf "The 'mpg123' command could not be found. Please install it by running 'sudo apt-get install mpg123'\n"
    exit
fi

# Function to display welcome message
welcome_message() {
    echo
    echo "Welcome, you poker enthusiast! Ready to up your game? This script is your new best friend. It's going to give you advices, reminders, philosopher sentences and even jokes to keep your spirits high. Remember, poker is not just about the cards, it's about the player. So, buckle up, and let's get started!"
    echo
    echo "Remember, you can exit anytime by pressing CTRL + C. But hey, why would you want to leave when you're just getting started?"
    echo
    echo "Press 'm' to mute/unmute the voice. Press 's' to mute/unmute the sound."
    echo
    sleep 17
}

# Call the welcome_message function at the start of the script
welcome_message

# Function to read a random line from a file
read_random_line() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo "File $file does not exist."
        exit 1
    fi
    local lines=$(cat $file | wc -l)
    if [ "$lines" -eq 0 ]; then
        echo "File $file is empty."
        exit 1
    fi
    local random_line=$((RANDOM % $lines + 1))
    local text=$(sed "${random_line}q;d" $file)

    # Check if the text has already been sent
    if [[ $file == $advices_file && " ${sent_advices[@]} " =~ " ${text} " ]] ||
       [[ $file == $reminders_file && " ${sent_reminders[@]} " =~ " ${text} " ]] ||
       [[ $file == $philosopher_file && " ${sent_philosopher[@]} " =~ " ${text} " ]] ||
       [[ $file == $jokes_file && " ${sent_jokes[@]} " =~ " ${text} " ]]; then
        # If the text has already been sent, read another random line
        read_random_line $file
    else
        # If the text has not been sent, add it to the corresponding array and print it
        if [[ $file == $advices_file ]]; then
            sent_advices+=("$text")
        elif [[ $file == $reminders_file ]]; then
            sent_reminders+=("$text")
        elif [[ $file == $philosopher_file ]]; then
            sent_philosopher+=("$text")
        elif [[ $file == $jokes_file ]]; then
            sent_jokes+=("$text")
        fi
        echo "$text"
        notify-send "$text"  # Send a notification
      echo
      echo "To exit: press CTRL + C. To mute/unmute voice: press 'm'. To mute/unmute sound: press 's'."
        if $voice; then
            echo "$text" | festival --tts
        fi
    fi
}

# Function to handle SIGINT signal
handle_sigint() {
  echo
    closing_text_mad="Listen up, you absolute donkey. You just lost because you played like a complete buffoon. Every hand in poker is foldable, you know? It's not the cards that are to blame, it's your lousy decision-making. You chose to play those cards, and look where it got you."
    closing_text_comfort="But hey, don't get all worked up about it. Take a breather. Go rest, cool down. You're no good to anyone if you're on tilt. Remember, poker is a marathon, not a sprint. You've got to keep your head in the game. So take some time off, get your head straight, and come back when you're ready to play like a pro."
    echo $closing_text_mad
    echo
    echo $closing_text_comfort

    if $voice; then
        echo "$closing_text_mad" | festival --tts
        sleep 1
        echo "$closing_text_comfort" | festival --tts
    fi
    exit
}

# Set a trap to catch SIGINT and call handle_sigint function
trap handle_sigint SIGINT

# Main loop
while true; do
    clear

    # Choose a random file
    random_file=$((RANDOM % 4))

    # Check if all jokes have been sent
    if [[ ${#sent_jokes[@]} -eq 50 ]]; then
        # If all jokes have been sent, exclude jokes from the selection process
        random_file=$((RANDOM % 2))
    fi

    if [[ $random_file -eq 0 ]]; then
        echo "Advice:"
        # Play a bell sound if sound is enabled
        if $sound; then
            echo -e "\a"
            mpg123 -q $BASE_DIR/sounds/great-bell.mp3
        fi
        read_random_line $advices_file
    elif [[ $random_file -eq 1 ]]; then
        echo "Reminder:"
        # Play a bell sound if sound is enabled
        if $sound; then
            echo -e "\a"
            mpg123 -q $BASE_DIR/sounds/simple-buzzer.mp3
        fi
        read_random_line $reminders_file
    elif [[ $random_file -eq 2 ]]; then
        echo "Reminder:"
        # Play a bell sound if sound is enabled
        if $sound; then
            echo -e "\a"
            mpg123 -q $BASE_DIR/sounds/buzzer-bell.mp3
        fi
        read_random_line $philosopher_file
    else
        echo "Joke:"
        # Play a bell sound if sound is enabled
        if $sound; then
            echo -e "\a"
            mpg123 -q $BASE_DIR/sounds/ding-dong.mp3
        fi
        read_random_line $jokes_file
    fi

    # Check if all advices, reminders, philosopher sentences and jokes have been sent
    if [[ ${#sent_advices[@]} -eq 125 && ${#sent_reminders[@]} -eq 125 && ${#sent_philosopher[@]} -eq 125 && ${#sent_jokes[@]} -eq 50 ]]; then
        # If all have been sent, reset and restart fresh
        sent_advices=()
        sent_reminders=()
        sent_philosopher=()
        sent_jokes=()
    fi

    # Wait for 2 minutes
    sleep 120
done
