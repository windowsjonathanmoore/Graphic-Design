#!/bin/bash
# egregore launching script
# chdh - 2014

# change to debug=1 to have informations in log.txt
debug=0

# add user command line option to start pd, change to -jack if needed
USER_OPTION="-alsa"


userpd=null
# uncomment one of the next line to force a specific command to start pd
# userpd=pd
# userpd=pdextended


# add few comment on a log file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"
    if [[ $debug = 1 ]]; then
        echo "////////////////////////////// START : $(date)" >> log.txt
        echo "script version 1.0-RC1" >> log.txt
        echo "linux : $(uname -r)" >> log.txt
        echo "proc : ">>log.txt
        cat /proc/cpuinfo | grep model | grep name >>log.txt
    fi

function do_loop_download { 

  while [ true ]; do
    if [[ $debug = 1 ]]; then
        echo "STARTING param down sub pd">>../log.txt
        $pdbin -noprefs -nogui -noadc -nodac -send "debug "$debug"" abs/param_down_sub.pd 2>>../log.txt
        echo ------------------------------------------
        echo --------------- CRASH --------------------
        date
        echo ------------------------------------------
        echo "CRASH : param_down_sub : $(date)">>../log.txt
    else
        $pdbin -noprefs -nogui -noadc -nodac -send "debug "$debug"" abs/param_down_sub.pd
    fi
  done
}


# try to find the best pd version to start
pdbin=null

pdversion=pd_$(which puredata) 
if [ $pdversion != "pd_" ]
then
    pdbin=puredata
fi

pdversion=pd_$(which pd) 
if [ $pdversion != "pd_" ]
then
    pdbin=pd
fi

pdversion=pd_$(which pd-extended) 
if [ $pdversion != "pd_" ]
then
    pdbin=pd-extended
fi

pdversion=pd_$(which pdextended) 
if [ $pdversion != "pd_" ]
then
    pdbin=pdextended
fi

if [ $pdbin = "null" ]
then
    echo "No version of pure data was found"
    echo "Please install a version (> 0.43)"
    echo "See instructions online :"
    echo "http://puredata.info/downloads/pd-extended"
    exit 0
fi

if [ $userpd != "null" ]
then
    pdbin=$userpd
fi

# adding few more comment on the log
if [[ $debug = 1 ]]; then
    echo using pd binary : $pdbin
    echo "using pd binary : $pdbin" >> log.txt
    echo "pd version :" >> log.txt 
    $pdbin -version 2>> log.txt
fi

cd src

# start a background loop on a part that may crash
# do_loop_download &
# pid_loop=$!

# start main patch
if [[ $debug = 1 ]]; then
echo "STARTING main pd">>../log.txt
    $pdbin -noprefs -stderr -lib Gem -r 48000 -noadc -audiobuf 50 -blocksize 128 -midiindev 0,1,2 $USER_OPTION -send "debug "$debug"" -send "os linux" egregore.pd 2>>../log.txt
else
    $pdbin -noprefs -lib Gem -r 48000 -noadc -audiobuf 50 -blocksize 128 -midiindev 0,1,2 $USER_OPTION -send "debug "$debug"" -send "os linux" egregore.pd
fi


# end background loop when man patch exit
# kill $pid_loop
# pkill -f abs/param_down_sub.pd

if [[ $debug = 1 ]]; then
    echo "////////////////////////////// STOP: $(date)" >>../log.txt
fi
