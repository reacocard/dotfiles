#!/usr/bin/zsh

scriptdir=`dirname "$(readlink -f "$0")"`

cp ${scriptdir}/../../.zshrc /root/.zshrc
chsh --shell /usr/bin/zsh root
