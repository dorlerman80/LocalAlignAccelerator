#!/usr/bin/env python3

# imports
import argparse
import random

# Constants
SEQ_LETTERS = 32
NUM_GROUPS = 8
# ANSI escape code for red text
RED_CODE = "\033[91m"
# ANSI escape code to reset text color
RESET_CODE = "\033[0m"

# GLOBAL Functions
def letter_to_binary(letter):
    if letter == 'A':
        binary = '00'
    elif letter == 'G':
        binary = '01'
    elif letter == 'T':
        binary = '10'
    elif letter == 'C':
        binary = '11'

    return binary

def letters_group_to_reverse_binary(letters_group):
    sequence_binary_reversed = ''

    print(f'letters group is : {letters_group} \n')
    for i in range(1,len(letters_group)+1):
        sequence_binary_reversed = sequence_binary_reversed + letter_to_binary(letters_group[-i])
    return sequence_binary_reversed


def mode_gen():
    sequence_binary = ''
    sequence_letters = ''

    possible_letters = ['A','T','C','G']
    for i in range(SEQ_LETTERS):
        random_letter = random.choice(possible_letters)
        sequence_letters = sequence_letters + random_letter
        sequence_binary = sequence_binary +  letter_to_binary(random_letter)

    print(f"{RED_CODE}The sequence letters are{RESET_CODE} - {sequence_letters} \n")  
    print(f"{RED_CODE}The binary representation is {RESET_CODE} - {sequence_binary} \n") 

    # Split the string into groups of 4
    letter_groups_of_4 = [sequence_letters[i:i+4] for i in range(0, len(sequence_letters), 4)]

    # Process each group and store the results in a list
    binary_groups_of_8 = [letters_group_to_reverse_binary(letter_groups_of_4[i]) for i in range(8)]

    # Print the results
    for i, binary_groups_of_8 in enumerate(binary_groups_of_8, start=1):
        print(f"Group {i}: {binary_groups_of_8}")


def mode_parse(sequence_letters):
    sequence_binary = ''
    for i in range(0, len(sequence_letters), 2):
        sequence_binary = sequence_binary + letter_to_binary(sequence_letters[i])

    print(f"{RED_CODE}The binary representation is {RESET_CODE} - {sequence_binary} \n") 

def main():

    # Create the argument parser
    parser = argparse.ArgumentParser(description='Script with 2 modes.')

    # Add mode argument
    parser.add_argument('mode', choices=['gen', 'parse'], help='Select mode: gen or parse')

    # Add optional argument for 'parse' mode
    parser.add_argument('--input_string', type=str, help='Required for parse mode: a string with 0s and 1s only')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Check the selected mode
    if args.mode == 'gen':
        mode_gen()
    elif args.mode == 'parse':
        # Validate and process input_string for 'parse' mode
        if args.input_string is None:
            parser.error('When in parse mode, --input_string is required.')
        
        else: 
            possible_letters = ['A','T','C','G']
            if not all(char in possible_letters for char in args.input_string):
                parser.error('Input string must contain only one of the letters A , T , C , G')
            mode_parse(args.input_string)
        

if __name__ == "__main__":
    main()
