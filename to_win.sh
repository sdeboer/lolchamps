#!/usr/bin/bash
# these should really be links....

if [[ -e ${HOME}/.bashrc ]]; then
  cp ${HOME}/.bashrc ${HOME}/.bashrc.local
fi

cp .bashrc ${HOME}/.bashrc

for f in .bash_logout .gitignore .irbrc .screenrc .tmux.conf
do
  if [[ -e ${HOME}/$f ]]; then
    cp ${HOME}/$f "${HOME}/$f".bak
  fi

  cp $f ${HOME}
done

if [[ -e ${HOME}/_vimrc ]]; then
  cp ${HOME}/_vimrc ${HOME}/_vimrc.bak
fi

cp .vimrc ${HOME}/_vimrc

if [[ ! -e "${HOME}/Application Data/Vim" ]]; then
  mkdir -p "${HOME}/Application Data/Vim"
fi

if [[ ! -d ${HOME}/vimfiles ]]; then
  mkdir ${HOME}/vimfiles
fi

rm -rf ${HOME}/vimfiles/*

cp -Rp .vim/* ${HOME}/vimfiles

if [[ -e ${HOME}/.ssh/config ]]; then
  cp ${HOME}/.ssh/config ${HOME}/.ssh/config.bak
fi

cp .ssh/config ${HOME}/.ssh/config
