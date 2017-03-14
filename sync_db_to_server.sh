#!/bin/bash
# cd's to directory with code
cd /Users/geertkapteijns/Code/MATLAB/ctmrg/db/
# sqlite3 'tensors.db' '.backup tensors_backup.db'
rsync --progress tensors_backup.db geert@DTA160162.science.uva.nl:"ctmrg/db/tensors.db"
