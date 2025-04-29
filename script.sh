#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
fi

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory does not exist"
    exit 1
fi

mkdir -p "$output_dir"

find "$input_dir" -type f -exec sh -c '
    for file do
        filename=$(basename "$file")
        if [ -e "$2/$filename" ]; then
            counter=1
            while [ -e "$2/${filename%.*}_$counter.${filename##*.}" ]; do
                counter=$((counter + 1))
            done
            new_filename="${filename%.*}_$counter.${filename##*.}"
            cp "$file" "$2/$new_filename"
        else
            cp "$file" "$2/$filename"
        fi
    done
' sh {} "$output_dir" \;

echo "Files copied successfully to $output_dir"