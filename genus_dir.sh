#!/bin/bash

# Given a collection of .doc* and pdf files, each corresponding to a species, genus_dir.sh organises them 
# into a directory following their taxonomic hierarchy at the genus level and grouping species-specific
# files inside a species (Genus_species) folder
# written by: Francoise Cavada-Blanco | https://github.com/fcavada on 21/06/2020

#This script does the following:
# 
# 2) Creates a folder named after the first two strings of the files, replacing spaces with '_'
# 3) Makes a copy of each .doc* file and re-names the suffix based on a regex,
#    i.e. original file :  'First second_published_YYY-MM-DD.doc' copy: 'First_second_workingcopy.doc'
# 4) Moves both .pdf and renamed .doc* files into the folder with the same name
# 5) Moves all folder whose names start with the same string ('First') into a common folder with that name  
# 
# IMPORTANT: .pdf files need to exist before running this scrip
# To batch convert from .doc* to .pdf, run the following command in shell console:
# lowriter --convert-to pdf *.doc*


shopt -s nullglob


for item in *.doc* ; do # for each file with .doc* in its name
	# creates a list named genus_spp in which filenames' sufixes are dropped based on a regex. 
	# i.e. original file :  'First second_published_YYY-MM-DD.doc' name on list: 'First second'
	genus_spp=$(echo $item | sed 's/[ _]published.*//g') 
	# creates a list named genus with only the 'First' string of the .doc* filenames 
	# i.e. original file :  'First second_published_YYY-MM-DD.doc' name on list: 'First'
	genus=$( echo $genus_spp | sed 's/[ _].*//g')
	# Prints items in both list per iteration to keep track on outputs
	echo "------------------------"
	echo "genus_spp:  "$genus_spp
	echo "genus:      "$genus
	echo "+++++++++++++++++++++++++"
	# creates a list named directory with only the first and second strings of the .doc* filenames. Also replacing spaces
	# i.e. original file :  'First second_published_YYY-MM-DD.doc' name on list: 'First_second'
	directory=$(echo $genus_spp | sed 's/ /_/g') 
	# Prints original file name and item in list directory  per iteration to keep track on outputs
	echo "------------------------"
	echo "Item:  "$item
	echo "Directorio: "$directory
	echo "+++++++++++++++++++++++++"
	

	# Creates a folder for each species using names stored in the list directory
	mkdir -p "$directory"; 

	# creates a list changing the .doc* filenames with a given suffix based on a regex before moving it to its corresponding folder
	final_copy_name=$(echo $item | sed 's/[ _]published.*\./_workingcopy\./g') # adds suffix to the copy "_"
	# Prints new name  per iteration to keep track on outputs
	echo "---------------------------"
	echo -e "Final copy name 1:     "$final_copy_name
	# substitutes space between genus and sp with "_"
	final_copy_name=$(echo $final_copy_name | sed 's/ /_/g') 
	# Prints new name  per iteration to keep track on outputs
	echo -e "Final copy name 2:     "$final_copy_name
	echo "++++++++++++++++++++++++++++"
	
	# Creates a copy of the .doc* file inside the corresponding species folder 
	# renaming it with the final_copy_name list
	cp "$item" "$directory"/"$final_copy_name"
	# Creates a list of the .pdf files
	item_pdf=$(echo $item | sed 's/doc*/pdf/g')
	# Prints items on list per iteration to keep track on outputs
	echo "-----------------------------"
	echo "New name as PDF:       "$item_pdf
	echo "++++++++++++++++++++++++++++"
	
	# Moves the .pdf files from working directory to their corresponding species folder
	mv "$item_pdf" "$directory/$item_pdf"
	# Creates a folder per each genus
	mkdir -p "$genus"; 
	# Moves all species folder inside their corresponding genus folder
	mv "$directory" "$genus"

done


	