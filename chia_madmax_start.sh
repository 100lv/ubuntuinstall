#!/bin/bash

rm /chia/tmpdir/*.tmp
rm /chia/tmpdir2/*.tmp
sudo mount -a

PLOTSIZE=108900000000
DIRSIZE=$(df --output=avail -B 1 "/chia/dest" |tail -n 1)
USABLESIZE=$(( (DIRSIZE / PLOTSIZE) ))


sudo /home/chpt/chia-plotter/build/chia_plot -n $USABLESIZE  -r 8 -t /chia/tmpdir/ -2 /chia/tmpdir2/ -d /chia/dest/ -f b0c6d1a29116385670577f62d697a62fb9a810f0c4ee3780a2fc29b905bfc7a003e053341bc905a8bb173f246aa37c81  -c xch1j3356j56mflh4jdqxppu7gxrq2v85xnklvj9n29sv9mlfsl76umsnswcen >> /home/chpt/madmax.log



PLOTSIZE=108900000000
DIRSIZE=$(df --output=avail -B 1 "/chia/dest2" |tail -n 1)
USABLESIZE=$(( (DIRSIZE / PLOTSIZE) ))

sudo /home/chpt/chia-plotter/build/chia_plot -n $USABLESIZE  -r 8 -t /chia/tmpdir/ -2 /chia/tmpdir2/ -d /chia/dest2/ -f b0c6d1a29116385670577f62d697a62fb9a810f0c4ee3780a2fc29b905bfc7a003e053341bc905a8bb173f246aa37c81  -c xch1j3356j56mflh4jdqxppu7gxrq2v85xnklvj9n29sv9mlfsl76umsnswcen >> /home/chpt/madmax.log

