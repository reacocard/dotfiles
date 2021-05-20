#!/usr/bin/zsh

scriptdir=`dirname "$(readlink -f "$0")"`

cp ${scriptdir}/../../.zshrc /root/.zshrc
cp -r ${scriptdir}/../../.zsh/ /root/
chsh --shell /usr/bin/zsh root
