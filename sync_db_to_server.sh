#!/bin/bash
# cd's to directory with code
cd /Users/geertkapteijns/Code/MATLAB/ctmrg/
rsync --progress ./db/tensors.db geert@DTA160162.science.uva.nl:"ctmrg/db/tensors_server.db"
