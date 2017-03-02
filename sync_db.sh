#!/bin/bash
ssh geert@DTA160162.science.uva.nl 'sqlite3 "/home/geert/ctmrg/db/tensors.db" ".backup /home/geert/ctmrg/db/tensors_backup.db"'
ssh geert@DTA160162.science.uva.nl 'sqlite3 "/home/geert/ctmrg/db/t_pseudocrits.db" ".backup /home/geert/ctmrg/db/t_pseudocrits_backup.db"'
ssh geert@DTA160162.science.uva.nl 'sqlite3 "/home/geert/ctmrg/db/t_pseudocrits_n.db" ".backup /home/geert/ctmrg/db/t_pseudocrits_n_backup.db"'

rsync geert@DTA160162.science.uva.nl:"ctmrg/db/tensors_backup.db" "/Users/geertkapteijns/Code/MATLAB/ctmrg/db/tensors_server.db"
rsync geert@DTA160162.science.uva.nl:"ctmrg/db/t_pseudocrits_backup.db" "/Users/geertkapteijns/Code/MATLAB/ctmrg/db/t_pseudocrits_server.db"
rsync geert@DTA160162.science.uva.nl:"ctmrg/db/t_pseudocrits_n_backup.db" "/Users/geertkapteijns/Code/MATLAB/ctmrg/db/t_pseudocrits_n_server.db"

cd ~/Code/MATLAB/ctmrg/db/

sqlite3 tensors.db '.read merge_tensors_server.sql'
sqlite3 t_pseudocrits.db '.read merge_t_pseudocrits_server.sql'
sqlite3 t_pseudocrits_n.db '.read merge_t_pseudocrits_n_server.sql'
