#!/bin/sh

AUTH_STRING="This_is_the_assignment_given_by_Mayur"
Token=''

# --------------------------------------------------------------------------------
# To create a SHA256 hash

# 1    -> Parameter
# Hash -> The hash code

hash=''
sha256_function () {
    hash=$(echo $1  | sha256 -s $AUTH_STRING | base64)
}
# --------------------------------------------------------------------------------
# To Generate the Unique ID with the user name and fingerprint for the password
# Don't use this function other than sign in
fingerprint=''
unique_id=''
Sign_Up () {
    sha256_function $1
    fingerprint=$hash

    unique_id=$(cat User.json | wc -l)
}
# --------------------------------------------------------------------------------
# 1 -> User Name
# 2 -> Password
# Token -> Has the User Information as the data
Auth () {

    #Convert the current password to hash
    sha256_function $2
    password=$hash

    #Search the data
    user_data=$(grep -i "$1" User.json)

    #Making the parameter to the correct formate
    user_quote=$(echo '"'$1'"')
    pass_quote=$(echo '"'$password'"')

    #Useing JQ to get the needed data from the User.json
    user_auth=$(echo $user_data | jq '.USER')
    pass_auth=$(echo $user_data | jq '.FINGERPRINT')

    #Authenticating the user
    if [ "$user_quote" = "$user_auth" ]
    then
        if [ "$pass_quote" = "$pass_auth" ]
        then
            echo "Login Success"
            Token=$(echo "$user_data")
        else
            Token=''
            echo "Password is wrong"
        fi
    else
        Token=''
        echo "No user Exist"
    fi
}

# --------------------------------------------------------------------------------
# -----------------------------------MAIN CODE------------------------------------
ending=1
while [ $ending -ne 0 ]
do
    clear
    echo "1. Sign Up\n2. Sign In\n"

    token_exits=$(echo $Token | jq '.USER')
    
    if [ ! -z $token_exits ]
    then
        clear
        echo "1. Sign up with different account || 2. Add new user\n"
        echo "Signed in as : " $token_exits "\n"
        echo "3. Addind new account\n4. Search Website\n5. Show all accounts\n 6. logout"
    fi

    # Reading an option
    read option_user

    if [ $option_user -eq 1 ]
    then
        clear
        echo "User Name : "
        read user
        echo "Password : "
        read pass
        exits=$(grep -i "$user" User.json)
        user_exits=$(echo $exits | jq '.USER')
        if [ -z $user_exits ]
        then
            Sign_Up $pass $user
            #------------------
            echo '{"ID" : "'$unique_id'" ,"USER" : "'$user'" ,"FINGERPRINT" : "'$fingerprint'"}'>>User.json
            touch "$unique_id".json
            echo "SUCCESSFULLY SIGNED - UP"
        else
            
            echo "Account alread exists"
        fi
    elif [ $option_user -eq 2 ]
    then
        token_exits=$(echo $Token | jq '.USER')
        if [ -z $token_exits ]
        then
            clear
            echo "User Name : "
            read user
            echo "Password : "
            read pass
            Auth $user $pass
            echo $Token
        else
            clear
            echo "Signed in as"
            echo $Token | jq '.USER'
        fi
    elif [ $option_user -eq 6 ]
    then
        clear
        Token=''
        echo "Loged out"
    elif [ $option_user -eq 3 ]
    then
        if [ ! -z $token_exits ]
        then
            clear
            echo "Signed in as : " $token_exits "\n"
            echo "Add New Account\n"
            echo "Enter the email"
            read email
            echo "Enter the password"
            read password
            echo "Website"
            read website
            id=$(echo $Token | jq '.ID')
            #enc_password=$(echo $password| openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:'pick.your.password')
            echo '{"WEBSITE" : "'$website'","EMAIL" : "'$email'" ,"PASSWORD" : "'$password'"}'>>$id.json
        fi
    elif [ $option_user -eq 4 ]
    then
        if [ ! -z $token_exits ]
        then
            clear
            echo "Enter the name of the website you wanna search : "
            read website
            id=$(echo $Token | jq '.ID')
            grep -i "$website" $id.json >> site_data.txt

            while read pointer; do
                Email=$(echo $pointer | jq '.EMAIL')
                Password=$(echo $pointer | jq '.PASSWORD')
                echo $Email
                echo $Password
            done <site_data.txt
            #---
            echo "">site_data.txt
        fi
    elif [ $option_user -eq 5 ]
    then
        if [ ! -z $token_exits ]
        then
            clear
            id=$(echo $Token | jq '.ID')
            site_data=$(cat $id.json)
            echo $site_data
        fi
    else    
        clear
        echo "Enter a valid option"
    fi

    echo "\nPRESS ANY NUMBER TO MAIN PAGE.\nEnter 0+ENTER to EXIT"
    read ending
done