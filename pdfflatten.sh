#!/bin/bash

# Author: Damodar Rajbhandari (2020)
#--------------------------------------

# Defining Shells coloring
#----------------------------

NONE='\033[00m'
RED='\033[01;31m'
CYAN='\033[01;36m'
UNDERLINE='\033[4m'

# Writing Help message
#-----------------------

if [ "$1" == "-h" ]; then
    echo "Author: Damodar Rajbhandari (2020)"
    echo "Usage: ./pdflatten.sh file.pdf"
    echo "For more pdf files, Usage: ./pdflatten.sh file1.pdf file2.pdf <and so on>"
    exit 0
fi

# Checking Ghostscript program install or not
# ---------------------------------------------
if ! which pdf2ps &> /dev/null; then
  echo -e "${RED}Namaste, Please install the Ghostscript in your machine!${NONE}"
  exit 1
fi

# Abort the program if no pdf file provided!
#---------------------------------------------

if [ $# -eq 0 ]; then
    echo -e "${CYAN}Namaste, Please provide the pdf file!${NONE}"	
    echo -e "${RED}No pdf file provided!${NONE}"
    echo "For help: ./pdflatten.sh -h"
    exit 1
fi

for var in "$@"
do
	echo "Flattening the pdf:" $var"."

	if [[ "$var" =~ ( |\') ]]; 
	then	
		# If pdf with spaces provided, copy it by renaming.
		# Because pdf2ps and ps2pdf in Ghostscript cannot handle
		#--------------------------------------------------------
		$(cp "$var" "${var// /_}_renamed.pdf") 

		# The real things happen from below
		#------------------------------------

		start=`date +%s`
		pdf2ps ${var// /_}_renamed.pdf - | ps2pdf - ${var// /_}_Flattened.pdf
		end=`date +%s`

		echo "Time taken to finish flattening:" $(date -ud "@$((end-start))" +'%H hours %M minutes %S seconds').
        	
		# Delete the copied then renamed pdf
		#-------------------------------------
		$(rm "${var// /_}_renamed.pdf")

	else
		# The real things happen from below
		#------------------------------------

		start=`date +%s`
		pdf2ps ${var} - | ps2pdf - ${var}_Flattened.pdf
		end=`date +%s`

		echo "Time taken to finish flattening:" $(date -ud "@$((end-start))" +'%H hours %M minutes %S seconds').
	
	fi
done

echo "Finished flattening the given pdf(s)!"