#!/bin/bash   



# Set defaults 
PONY=""


# Load configuration file
source $HOME/ArrestingDevelopment/scripts/config

speakers() {

  # Commands: on, off, -v [integer 0-100], mute, volume, up, down

  volume=""
  
  login() {
    ssh $PONY $1

  }

  case "$1" in 

    # Turns speakers on and sets volume to medium level
    on) volume="40"
        login "open -a 'Airfoil Speakers' && osascript -e 'set volume output volume 40'"
        osascript -e "tell application \"Airfoil\"" \
          -e "repeat until speaker \"PonyExpress\" exists" \
          -e "end repeat"\
          -e  "connect to speaker \"PonyExpress\"" \
          -e "end tell"\
        echo "Speakers on"
        ;;

    # Turns speakers off
    off) volume="0"
         login "osascript -e 'quit app \"Airfoil Speakers\"'"
         echo "Speakers off"
         ;;

    # Sets volume by integer
    # TODO: Check that $2 is between 0-100
    -v) volume=$2
        login "osascript -e 'set volume output volume $2'"
        echo "Speakers volume $2"
        ;;

    # Mutes Speakers
    mute) volume="0"
          login "osascript -e 'set Volume 0'"
          ;;

    # Tells the current volume 
    volume) login "osascript -e 'output volume of (get volume settings)'"
            ;;

    # Turns volume up by 20
    # TODO: accept a third value to tinker with increments
    up) volume=$(login "osascript -e 'output volume of (get volume settings)'")
        volume=$((volume+20));

        if [ "$volume" -lt "100" ]; then
          login "osascript -e 'set volume output volume $volume'"
          echo "Volume set at $volume"

        else
          volume="100"
          login "osascript -e 'set volume output volume 100'"
          echo "Volume maxed"

        fi
        ;;

    # Turns volume down by 20
    # Should also accept a third argument for incremental adjustments
    down) volume=$(login "osascript -e 'output volume of (get volume settings)'")
          volume=$((volume-20));

          if [ "$volume" -gt "0" ]; then
            login "osascript -e 'set volume output volume $volume'"
            echo "Volume set at $volume"

          else
            volume="0"
            login "osascript -e 'set volume output volume 0'"
            echo "Muted"

          fi
          ;;
  esac    

}



