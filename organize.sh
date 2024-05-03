#!/bin/bash

root=$(pwd)

sort() {
	# Sorts a directory recursively
	folders=($(ls -p | grep /))
	for folder in ${folders[@]};
	do
		cd $folder
		sort
		cd ..
	done
	files=($(ls -p | grep -v /))
	if [ -n "${files}" ]
	then
		mkdir -p others
		mv "${files[@]}" others
		cd others
		while [ -n "$files" ];
		do
			filename=$(basename -- ${files[0]})
			if [[ $filename == *"."* ]]
			then
				ext=${filename##*.}
				mkdir -p ../$ext
				mv *.$ext -t ../$ext
			else
				mkdir -p temp
				mv $filename temp
			fi
			files=($(ls -p | grep -v /))
		done
		if [ -d temp ]
		then
			mv temp/* .
			rmdir temp
		fi
		cd ..
		if [ -z "$(ls others)" ]
		then
			rmdir others
		fi
	fi
}

sort
cd $root
