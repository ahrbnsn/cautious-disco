#!/bin/bash         
# rsync script
# find script


# Load configuration file
# TODO: source is not secure as it will execute arbitrary code
source /Users/ashleyrobinson/ArrestingDevelopment/scripts/config


# Checks to see if hard drive is attached; transfers files
#  &  sics filebot on them


# Moves files to a seperate directory for review before sending to Plex folder 
# Filebot occasionally messes up catergorization


# alias: delivery

sendToLibrary () {
  if [ -d $MEDIADRIVE ]; then
    rsync -aP --remove-source-files $SOURCEDIR $DESTDIR
  
    # deletes empty directories left by rsync
    cd $SOURCEDIR
    find . -depth -type d -empty -delete
    echo "Clean Up Complete"

    echo "Syncing iTunes"
    rsync -rtP --update $SOURCEMUSIC $PLEXMUSICDIR
    echo "Music Synced"

    echo "Deploying Filebot"
    /usr/local/bin/filebot -script fn:amc $DESTDIR --output $HOLDINGPEN --action move -non-strict  --def excludeList=amc.txt "seriesFormat={plex}" "movieFormat=Movies/{ny}/{fn}" unsorted=y clean=y --log-file "/Volumes/Librarian/dispatch.txt"


  else
    echo "It's not mounted."
  fi

}

#alias: loadPlex

sendToPlex () {
  if [ -d $MEDIADRIVE ]; then
    rsync -aP --update --remove-source-files  $HOLDINGPEN $PLEXDIR

    cd $HOLDINGPEN
    find . -depth -type d -empty -delete
    echo "Clean Up Complete"


   else
    echo "It's not mounted."
  fi


}

#http://stackoverflow.com/questions/8818119/linux-how-can-i-run-a-function-from-a-script-in-command-line

"$@"


