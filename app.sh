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

    sha256_function $2
    unique_id=$hash
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
    echo "1. Sign Up\n2. Sign In"

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
            #------
            echo '{"ID" : "'$unique_id'" ,"USER" : "'$user'" ,"FINGERPRINT" : "'$fingerprint'"}'>>User.json
            echo "SUCCESSFULLY SIGNED - UP"
        else
            
            echo "Account alread exists"
        fi
    elif [ $option_user -eq 2 ]
    then
        if [ -z $Token ]
        then
            clear
            echo "User Name : "
            read user
            echo "Password : "
            read pass
            Auth $user $pass
            echo $Token
        else
            echo "Already logged in"
        fi
    else    
        clear
        echo "Enter a valid option"
    fi

    echo "PRESS ANY NUMBER TO MAIN PAGE.\nEnter 0+ENTER to EXIT"
    read ending
done