function save_t_pseudocrits_to_db
  load('T_pseudocrits_energy_gap04-Jan-2017 08:43:33')
  tolerance = 1e-8;

  db_path = fullfile(Constants.DB_DIR, 't_pseudocrits.db');
  db_id = sqlite3.open(db_path);
  query = 'insert into t_pseudocrits (t_pseudocrit, chi, energy_gap, tolerance, tol_x) values (?, ?, ?, ?, ?)';

  for c = 1:numel(chi_values)
    result = sqlite3.execute(db_id, query, T_pseudocrits(c), chi_values(c), energy_gaps(c), tolerance, TolXs(c));
  end

end
