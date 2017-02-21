#!/bin/sh
nohup nice matlab -nodesktop -nosplash -nodisplay -r "main" > output.txt </dev/null &
