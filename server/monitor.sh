#!/bin/bash

DEFAULT_IF='wlan0'

if [ -n "$1" ]; then
  IF=$1
  echo Using interface $1
else
  IF=DEFAULT_IF
  echo Interface not specified, using $DEFAULT_IF
fi

if [ `whoami` != 'root' ]; then
  echo Error: Current user is `whoami`, please run as root. Exiting.
  exit 1
fi

ifconfig -s $IF &> /dev/null
if [ $? -ne 0 ]; then
  echo Interface $IF does not exists. Exiting.
  exit 1
fi

ifconfig $IF down
iwconfig $IF mode Monitor
ifconfig $IF up

if [ $? -eq 0 ]; then
  echo $IF was restarted in Monitor mode
fi
