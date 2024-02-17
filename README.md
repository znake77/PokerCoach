# Poker Coach

This script is your ultimate poker companion, designed to help you improve your poker game while keeping the mood light and fun. It works by providing you with random advices, reminders, and jokes related to poker. Here's how it can help you:

1. **Advices**: The script reads from a file named `advices.txt` which should contain various poker advices. These could be strategic tips, betting advice, or even psychological tricks to use against your opponents. The script will randomly select an advice and display it to you. This can help you learn new strategies and improve your poker game.

2. **Reminders**: The script also reads from a file named `reminders.txt`. This file should contain important reminders about poker rules, etiquette, or common mistakes to avoid. The script will randomly select a reminder and display it to you. This can help you avoid making common mistakes and keep important rules fresh in your mind.

3. **Jokes**: To keep things fun, the script also reads from a file named `jokes.txt` which should contain poker-related jokes. The script will randomly select a joke and display it to you. This can help lighten the mood and make your poker sessions more enjoyable.

The script also has a sound feature. If you run the script with the `-nosound` or `--nosound` argument, it will run silently. Otherwise, it will play a different sound depending on whether it's displaying an advice, a reminder, or a joke.

The script ensures that the same advice, reminder, or joke is not repeated until all of them have been displayed at least once. After that, it resets and starts fresh.

To use the script, simply run it in your terminal. It will display a new advice, reminder, or joke every 2 minutes. If you need help or want to disable the sound, you can use the `-h` or `--help` and `-nosound` or `--nosound` arguments respectively.

So, whether you're a poker newbie looking to learn the ropes, or a seasoned player wanting to keep your skills sharp, this script is your ace in the hole. Enjoy your game!

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You need to have `bash` and `mpg123` installed on your system to run this script. If not installed, you can install it using the following command:

For Ubuntu:
```
sudo apt-get install bash
sudo apt-get install mpg123
```

For Mac:
```
brew install bash
brew install mpg123
```

For Windows, you need to install Git Bash and then run the script using it.

### Installing

Clone the repository to your local machine:

```
git clone https://github.com/Znake77/PokerCoach.git
```

Navigate to the project directory:

```
cd PokerCoach
```

Make the script executable:

```
chmod +x pokerCoach.sh
```

### Usage

Run the script:

```
./pokerCoach.sh
```

To display help:

```
./pokerCoach.sh -h
```

To run the script without sound:

```
./pokerCoach.sh -nosound
```

## Built With

* [Bash](https://www.gnu.org/software/bash/) - The scripting language used
* [mpg123](https://www.mpg123.de/) - The audio player used

## Authors

* **Znake77** - [PokerStake](https://contents.pokerstake.com/profiles/znake77/)

## License

This project is licensed under the ProsperityShare License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Salute to Brian Fox, the creator of Bash, the Bourne Again SHell, first released in 1989.
* Hat tip to Michael Hipp, the creator of mpg123, a fast, free and portable MPEG audio player for Unix.
* A big thank you to all the creators and contributors of open-source software. Your work has made a significant impact on the world of technology.

Please note that the dates mentioned are for the initial releases of these tools and platforms.
