#!/bin/bash   



# Set defaults 
PONY=""


# Load configuration file
source $HOME/ArrestingDevelopment/scripts/config

function speakers() {

  volume=""
  
  login() {
    ssh $PONY $1

  }

  if [ "$1" = "on" ]; then
    volume="30"
    login "open -a 'Airfoil Speakers' && osascript -e 'set volume output volume 30'"
    echo "Speakers on"

  elif [ "$1" = "off" ]; then
    volume="0"
    login "osascript -e 'quit app \"Airfoil Speakers\"'"
    echo "Speakers off"

  #control the volume 0-100
  elif [ "$1" = "-v" ]; then
    volume=$2
    login "osascript -e 'set volume output volume $2'"


  elif [ "$1" = "mute" ]; then
    volume="0"
    login "osascript -e 'set Volume 0'"

  elif [ "$1" = "volume" ]; then
    login "osascript -e 'output volume of (get volume settings)'"

  elif [ "$1" = "up" ]; then
    volume=$(login "osascript -e 'output volume of (get volume settings)'")
    volume=$((volume+20));

    if [ "$volume" -lt "100" ]; then
      login "osascript -e 'set volume output volume $volume'"
      echo "Volume set at $volume"

    else
      volume="100"
      login "osascript -e 'set volume output volume 100'"
      echo "Volume maxed"

    fi

  elif [ "$1" = "down" ]; then
    volume=$(login "osascript -e 'output volume of (get volume settings)'")
    volume=$((volume-20));

    if [ "$volume" -gt "0" ]; then
      login "osascript -e 'set volume output volume $volume'"
      echo "Volume set at $volume"

    else
      volume="0"
      login "osascript -e 'set volume output volume 0'"
      echo "Muted"

    fi




  else
    echo "Specify '-on' or '-off'"

  fi
}