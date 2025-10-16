#!/usr/bin/bash

if [ $# -e 0 ]; then
    echo "Usage: $0 <file.asm>"
    exit 1
fi

filename=$1
basename="${filename%.*}"

debug=false

if [[ "$2" == "-d" ]]; then
	debug=true
fi

echo $filename

cp ~/.config/dosbox/dosbox-staging.conf ~/.config/dosbox/dosbox-staging.conf.bak

echo "mount c: ~/TASM" >> ~/.config/dosbox/dosbox-staging.conf
echo "c:" >> ~/.config/dosbox/dosbox-staging.conf
echo "TASM $filename" >> ~/.config/dosbox/dosbox-staging.conf
echo "TLINK $basename.OBJ" >> ~/.config/dosbox/dosbox-staging.conf

if [[ "$debug" == true ]]; then
	echo "TD $basename" >> ~/.config/dosbox/dosbox-staging.conf
else
	echo "$basename" >> ~/.config/dosbox/dosbox-staging.conf
fi

cp $filename ~/TASM

dosbox

echo $debug

# end
rm ~/TASM/$filename
rm ~/.config/dosbox/dosbox-staging.conf
mv ~/.config/dosbox/dosbox-staging.conf.bak ~/.config/dosbox/dosbox-staging.conf
rm ~/TASM/$basename.MAP
rm ~/TASM/$basename.OBJ
