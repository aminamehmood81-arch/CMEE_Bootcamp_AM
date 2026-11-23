#!/bin/bash
# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: MyExampleScript.sh
# Desc: Prints a greeting using a set variable and $USER
# Arguments: None
# Date: Nov 2026

greeting="Hello"
user_name=$USER
printf '%s %s\n' "$greeting" "$user_name"