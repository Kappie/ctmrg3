#!/bin/bash
ssh geert@DTA160162.science.uva.nl 'sqlite3 "/home/geert/ctmrg/db/tensors.db" ".backup /home/geert/ctmrg/db/tensors_backup.db"'
ssh geert@DTA160162.science.uva.nl 'sqlite3 "/home/geert/ctmrg/db/t_pseudocrits.db" ".backup /home/geert/ctmrg/db/t_pseudocrits_backup.db"'

rsync geert@DTA160162.science.uva.nl:"ctmrg/db/tensors_backup.db" "/Users/geertkapteijns/Code/MATLAB/ctmrg/db/tensors.db"
rsync geert@DTA160162.science.uva.nl:"ctmrg/db/t_pseudocrits_backup.db" "/Users/geertkapteijns/Code/MATLAB/ctmrg/db/t_pseudocrits.db"
