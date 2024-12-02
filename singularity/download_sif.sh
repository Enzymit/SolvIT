#!/bin/bash

# Download the SIF file from an S3 bucket if it doesn't already exist. If exists, ask the user if they want to overwrite it.
# Usage: ./download_sif.sh

# Implementation:
curscript_path=$(dirname $(realpath $0))
echo "$curscript_path/solvit.sif"
if [ -f "$curscript_path/solvit.sif" ]; then
    read -p "solvit.sif already exists. Do you want to overwrite it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
	wget https://enzymit-solvit-sif.s3.us-east-1.amazonaws.com/solvit.sif -O $curscript_path/solvit.sif
    fi
else
    wget https://enzymit-solvit-sif.s3.us-east-1.amazonaws.com/solvit.sif -O $curscript_path/solvit.sif
fi
