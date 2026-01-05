#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

if [ $1 = "--help" ]; then
    echo "let x = \$1, and y = \$2\n"
    echo "x === \"zsh\" => nvim ~/.zshrc"
    echo "x === \"nvim\" => nvim ~/.config/nvim/init.vim"
    echo "x === \"nvim\" & y === \"--ex\" => nvim ~/.config/nvim/extra.vim"

elif [ "$1" = "zsh" ]; then
    nvim ~/.zshrc

elif [ "$1" = "nvim" ] && [ "$2" = "--ex" ]; then
    nvim ~/.config/nvim/extra.vim

elif [ "$1" = "nvim" ]; then
    nvim ~/.config/nvim/init.vim

else
    echo no preset config $1 found

fi

