#!/bin/bash

# Check to see if .vim and .vimrc already exist. If they do, archvie them
# into _bck files unless they are just symbolic links, in which case just
# remove the old links.

DAT=`date -u +%s`

if [ -e $HOME/.vimrc ]; then
  echo "Found existing vimrc..."
  if [ -L $HOME/.vimrc ]; then
    echo " Removing vimrc symbolic link..."
    rm $HOME/.vimrc
  else
    echo " Making vimrc bck file..."
    mv $HOME/.vimrc $HOME/.vimrc_bck_$DAT
  fi
fi

if [ -e $HOME/.vim ]; then
  echo "Found existing vim/ dir..."
  if [ -L $HOME/.vim ]; then
    echo " Removing vim/ dir symbolic link..."
    rm $HOME/.vim
  else
    echo " Making vim/ dir bck..."
    mv $HOME/.vim $HOME/.vim_bck_$DAT
  fi
fi

echo "Linking vimrc file and vim/ directory..."
ln -sf ${PWD}/vimrc $HOME/.vimrc
ln -sf ${PWD}/vim $HOME/.vim

if [[ $# > 0 ]]; then
  echo "Overriding vimrc installation with essential.vim only!"
  ln -sf ${PWD}/essential.vim $HOME/.vimrc
fi

echo "Done."
