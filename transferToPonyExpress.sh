#!/bin/bash         
# rsync script
# find script



# Set defaults 

MEDIADRIVE=""
SOURCEDIR=""
SOURCEMUSIC=""
DESTDIR=""
HOLDINGPEN=""
PLEXDIR=""
PLEXMUSICDIR=""
LOGFILE=""
PONY=""


# Load configuration file
source /Users/ashleyrobinson/ArrestingDevelopment/scripts/config


# Checks to see if hard drive is available; transfers files
#  &  sics filebot on them.
#

# alias: delivery

sendToLibrary () {
  if [ -d $MEDIADRIVE ]; then
    rsync -aP --remove-source-files $SOURCEDIR $DESTDIR
  
    # deletes empty directories left by rsync
    cd $SOURCEDIR
    find . -depth -type d -empty -delete
    echo "Clean Up Complete"

    echo "Deploying Filebot"
    ssh $PONY "/usr/local/bin/filebot -script fn:amc $DESTDIR --output $HOLDINGPEN --action move -non-strict  --def excludeList=amc.txt "seriesFormat={plex}" "movieFormat=Movies/{ny}/{fn}" unsorted=y clean=y --log-file "$LOGFILE"
"


  else
    echo "Librarian unavailable."
  fi

}


# alias: deliveryM
# Syncs iTunes music library and calls sendToLibrary

syncMusic () {
  echo "Syncing iTunes"
  rsync -rtP --update $SOURCEMUSIC $PLEXMUSICDIR
  echo "Music Synced"

  sendToLibrary
}

#alias: loadPlex

sendToPlex () {
  if [ -d $MEDIADRIVE ]; then
    rsync -aP --update --remove-source-files  $HOLDINGPEN $PLEXDIR

    cd $HOLDINGPEN
    find . -depth -type d -empty -delete
    echo "Clean Up Complete"


   else
    echo "Librarian is out to lunch."
  fi


}

#http://stackoverflow.com/questions/8818119/linux-how-can-i-run-a-function-from-a-script-in-command-line

"$@"


