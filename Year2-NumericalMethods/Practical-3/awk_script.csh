#!/bin/csh

#script to read in the OSZICAR file and write the simulation time and temperature to a file called temp.dat

echo "Reading in the OSZICAR file and writing the simulation time and temperature to a file called temp.dat"

 awk '$2 ~ /T=/ {print $1,$3}' OSZICAR | sort -k1n >> temp.dat
