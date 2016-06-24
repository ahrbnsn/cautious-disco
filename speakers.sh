#!/bin/bash   

# Controls Media Server audio output
# 
#   on)   Opens Airfoil Speakers app & connects
#   off)  Quits Airfoil Speakers
#   mute) Mutes speakers
#   vol)  Sets exact volume
#   v)    With no argument, tells current volume on remote mac. 
#         
#         Options
#         --------------
#         +  Increases volume by 20
#         -  Decreases volume by 20
#         [integer] Increases or decreases volume by amount specified
# 
# 
# 



# Load configuration file
source $HOME/ArrestingDevelopment/scripts/config

speakers() {
  
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


    # Retrieves current volume or tweaks it
    vol) volume=$2
        if [[ "$2" -ge "0" && "$2" -le "100" ]]; then
          login "osascript -e 'set volume output volume $2'"
          echo "Speakers volume $2"
        
        else 
          echo "Specify a volume between 0-100"
        fi
        ;;


    # Mutes Speakers
    mute) volume="0"
          login "osascript -e 'set Volume 0'"
          ;;


    # Turns volume up or down incrementally; with no arguments passed tells current volume
    v) volume=$(login "osascript -e 'output volume of (get volume settings)'")
          
          if [[ -z "$2" ]]; then
            echo $volume
            return;
          
          elif [[ "$2" = "+" ]] ; then
           increment="20"
          
          elif [[ "$2" = "-" ]] ; then 
            increment="-20"
          
          else
            increment="$2"
          fi


          volume=$((volume+increment));
          echo $volume
          login "osascript -e 'set volume output volume $volume'"
          echo "Volume set at $volume"
          ;;          

  esac    

}



