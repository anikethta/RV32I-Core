#!/bin/bash

search_dir="../hvl"
file_type=".sv"
red='\033[0;34m'

#rm -rf "obj_dir"

for file in "$search_dir"/*"$file_type"; do
    if [ -f "$file" ]; then
        echo "$file"

	verilator --binary -j 0 -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC -Wno-UNOPTFLAT --trace -y "../hdl" -y "../hvl" -y "../hdl/cache" "$file"
	echo -e "${red}Finished building $file :D"
    fi
done
