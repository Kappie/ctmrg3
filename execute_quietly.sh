#!/bin/sh
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6:/lib/x86_64-linux-gnu/libgcc_s.so.1 nohup nice -n 10 matlab -singleCompThread -nodesktop -nosplash -nodisplay -r "main" > output.txt </dev/null &
