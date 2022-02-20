#!/bin/sh

a=1
one=1
while [ $a -ne 0 ]
do

    # Code to add or select the user
    echo "Enter the operation:\n1. Enter a new account\n---------\n Choose a User :"
    index=1
    while read p; do
        echo "$((index+1)) $p"
        index=$((index+1))
    done <user.txt
    if [ $index = 2 ]
    then
        echo "There is no users"
    fi
    index=2

    # Option is used to map to new user or current users in the user.txt
    read option

    # Option 1 is to choose new user
    if [ $option = 1 ]
        then
            echo "Enter your name : "
            read data
            echo $data>> user.txt

            echo "Enter your password : "
            read data
            echo $data| openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:'pick.your.password'>>pass.txt
    else
        # option-1 = line number in the user.txt
        # Finding the user
        echo "Enter the password "
        read password
        index=1
        while read p; do
            if [ $option = $index ]
                then
                  echo $p | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:'pick.your.password' > temp.txt
                while read p; do
                    PASS=$p
                done <temp.txt
                else
                    index=$((index+1))
                    echo "">> temp.txt
            fi
        done <pass.txt
        
        if [ $PASS = $password ]
        then
            echo "1. Add new account\n2. View Password"
            read option_sub_1
            if [ $option_sub_1 = 1 ]
            then
                echo "Enter the email ID :"
                read email
                echo "Enter the password :"
                read pass
                echo "$(($option-1)) $email $pass" >>account.txt
                
            elif [ $option_sub_1 = 2 ]
            then
                grep -i "$(($option-1))" account.txt
            fi
        fi
    fi
    echo "Press 0 +ENTER to exit"
   read a
done