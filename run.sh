#!/bin/sh

if ! node --version
then
    echo "Node is missing on your computer, install it to continue\n"
    exit
fi

if ! elm --version
then
    echo "ELM langage is not install on your computer, note that to run this program version 0.19.1 is required\n"
    exit
fi

npm install 

npm start

