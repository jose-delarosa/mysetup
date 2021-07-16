#!/bin/bash

HDIR=`pwd`

if [ `grep $HDIR/bashrc $HOME/.bashrc | wc -l` -eq 0 ] ; then
    echo "[ -f $HDIR/bashrc ] && . $HDIR/bashrc" >> $HOME/.bashrc
    echo "Modified $HOME/.bashrc"
fi

cd $HOME
[ ! -L $HOME/.dircolors ] && ln -s $HDIR/dircolors .dircolors
[ ! -L $HOME/.gitconfig ] && ln -s $HDIR/gitconfig .gitconfig
[ ! -L $HOME/.screenrc ] && ln -s $HDIR/screenrc .screenrc
[ ! -L $HOME/.vimrc ] && ln -s $HDIR/vimrc .vimrc
echo "Done!"
