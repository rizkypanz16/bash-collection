#!/bin/bash

IPADDR=$(ip address show | grep 'inet ' | grep 'eth' | awk '{print $2}' | cut -d'/' -f1)
echo $IPADDR