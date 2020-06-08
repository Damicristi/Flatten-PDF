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
    echo "For help: ./pdflatten -h"
    exit 1
fi

for var in "$@"
do
	# Abort the program if pdf with spaces provided!
	# Because pdf2ps and ps2pdf in Ghostscript cannot handle
	# todo(done): Work with cp and rm
	#----------------------------------------------------------

	#if [[ "$var" =~ ( |\') ]]; then
	#    echo -e "${RED}File name should not have spaces!${NONE}"
	#    echo "Namaste, Please rename the file and provide to me!"
	#    exit 1 
	#fi

	$(cp "$var" "${var// /_}_renamed.pdf") 

	# The real things happen from below
	#------------------------------------

	echo "Flattening the pdf:" $var"."

	start=`date +%s`
	pdf2ps ${var// /_}_renamed.pdf - | ps2pdf - ${var// /_}_Flattened.pdf
	end=`date +%s`

	echo "Time taken to finish flattening:" $((end-start)) "seconds."

	$(rm "${var// /_}_renamed.pdf")
done

echo "Finished flattening the given pdf(s)!"