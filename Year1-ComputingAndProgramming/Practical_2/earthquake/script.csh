#!/bin/csh
#script to find event with a magnitude greater than 7.0 in the northern hemisphere
echo 'Events with magnitude greater than 7.0 from deep to shallow in the northern hemisphere'
awk 'NR > 21 && $9 > 7.0 && ($6 >= 0 && $6 <= 90)' earthquake.dat | sort -k8nr | awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12}' > magnitude_7.0_N.dat
