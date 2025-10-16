#!/usr/bin/bash

filename=$1

echo $filename

cp ~/.config/dosbox/dosbox-staging.conf ~/.config/dosbox/dosbox-staging.conf.bak

echo "mount c: ~/TASM" >> ~/.config/dosbox/dosbox-staging.conf
echo "c:" >> ~/.config/dosbox/dosbox-staging.conf

dosbox

rm ~/.config/dosbox/dosbox-staging.conf
mv ~/.config/dosbox/dosbox-staging.conf.bak ~/.config/dosbox/dosbox-staging.conf
