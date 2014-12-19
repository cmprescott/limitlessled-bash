#!/bin/bash

##########
# About - color_fade_in.sh
##########
# This script slowly changes a zone of Limitless RGBW lightbulbs from the darkest setting to the brightest.
# An example use case would be for using your lights to help you wake up in the morning.

##########
# Config
##########
# Please configure the location of led.sh in the script. The script also take 3 parameters (zone, sleep time, color)
path_to_led_script="/home/cp/MiLight/limitlessled-bash/led.sh"

##########
# Input
##########
# Example usage: ./color_fade_in.sh 0 60 white
zone=$1
sleep_time=$2
color=$3

##########
# Setup. Go to script loc, turn on, and set color.
##########
cd $path_to_led_script
bash $path_to_led_script c $zone on
sleep 1
bash $path_to_led_script c $zone c $color
sleep 1

##########
# Function changes brightness level and sleeps for configged amount of time
##########
function changeBrightAndSleep {
    level=$1
    bash $path_to_led_script c $zone b $level
    sleep $sleep_time
}

##########
# Iterate starting at lowest brightness all the way until highest brightness
##########
for i in `seq 0 18`;
do
    changeBrightAndSleep $i
done    