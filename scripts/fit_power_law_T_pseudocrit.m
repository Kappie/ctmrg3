function fit_power_law_T_pseudocrit
  chi_values = [17, 21, 26, 31, 37];
  [T_pseudocrits, energy_gaps] = load_t_pseudocrit_from_db(chi_values);
  second_eigenvalues = 1 - energy_gaps;
  length_scales = exp(1./(log(1./second_eigenvalues)));
  % length_scales = zeros(1, numel(chi_values));

  % for c = 1:numel(chi_values)
  %   length_scales(c) = calculate_correlation_length(T_pseudocrits(c), chi_values(c), 1e-8);
  % end





  % [slope, intersect, mse] = logfit(1./length_scales, T_pseudocrits - Constants.T_crit, 'loglog', 'skipBegin', 0)
  % xlabel('$\exp(-1/\log(C_1/C_2)) = 1/N_{\mathrm{CTM}}$')
  % ylabel('$T^{\star}(\chi) - T_c$')
  % title('tolerance = $10^{-7}$')
  % hline(Constants.T_crit, '--')
  fit_power_law(T_pseudocrits, length_scales)
end

function fit_power_law(T_pseudocrits, length_scales)
  search_width = 0.00010;
  TolX = 1e-12;

  function mse = f_minimize(T_crit)
    t_pseudocrits = T_pseudocrits - T_crit;
    [slope, intercept, mse] = logfit(1./length_scales, t_pseudocrits, 'loglog', 'skipBegin', 0, 'skipEnd', 0);
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_crit, mse, exitflag] = fminbnd(@f_minimize, Constants.T_crit - search_width, Constants.T_crit + search_width, options)

  disp(Constants.T_crit - T_crit)
end

function [T_pseudocrits, energy_gaps] = load_t_pseudocrit_from_db(chi_values)
  db_path = fullfile(Constants.DB_DIR, 't_pseudocrits.db');
  db_id = sqlite3.open(db_path);
  % query = 'select * from t_pseudocrits where chi = ? ORDER BY tolerance ASC, tol_x ASC limit 1';
  query = 'select * from t_pseudocrits where chi = ? ORDER BY tolerance DESC limit 1';

  T_pseudocrits = zeros(1, numel(chi_values));
  energy_gaps = zeros(1, numel(chi_values));

  for c = 1:numel(chi_values)
    result = sqlite3.execute(db_id, query, chi_values(c));
    T_pseudocrits(c) = result.t_pseudocrit;
    energy_gaps(c) = result.energy_gap;
  end

  sqlite3.close(db_id);
end
