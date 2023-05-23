#last edit 2023-05-23

#!/bin/bash

# Change to the directory of pdf file
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $(dirname "$1")
pdf=$(basename "$1")
pdf_data="${pdf%.*}""_data.txt"
EXTRACT_FILE=booky_bookmarks_extract

### fixed bookmarks list as "booky.txt"
#bkFile="$2"
bkFile="booky.txt"



if [[ "$OSTYPE" == "darwin"* ]]; then
    SED=gsed
else
    SED=sed
fi


### combinds logsheet and the PDF
echo "combinds pdf & logsheet..."
pdftk "$pdf" "logsheet.pdf" cat output "${pdf%.*}""_binder.pdf"

echo "Converting $bkFile to pdftk compatible format"
python3 $SCRIPT_DIR/booky.py < "$bkFile" > "$EXTRACT_FILE"

echo "Dumping pdf meta data..."
#pdftk "$pdf" dump_data_utf8 output "$pdf_data"
pdftk "${pdf%.*}""_binder.pdf" dump_data_utf8 output "$pdf_data"

echo "Clear dumped data of any previous bookmarks"
$SED -i '/Bookmark/d' "$pdf_data"

echo "Inserting your bookmarks in the data"
$SED -i "/NumberOfPages/r $EXTRACT_FILE" "$pdf_data"

echo "Creating new pdf with your bookmarks..."
#pdftk "$pdf" update_info_utf8 "$pdf_data" output "${pdf%.*}""_booky.pdf" owner_pw 1234 allow Printing
### encrypts the PDF
#pdftk "${pdf%.*}""_binder.pdf" update_info_utf8 "$pdf_data" output "${pdf%.*}""_booky.pdf" owner_pw 1234 allow Printing
### no encrypts to the PDF
pdftk "${pdf%.*}""_binder.pdf" update_info_utf8 "$pdf_data" output "${pdf%.*}""_booky.pdf"

echo "Deleting leftovers"
rm "$EXTRACT_FILE" "$pdf_data"
