function find_T_crit
  q = 4;
  chi_values = 14:2:20;
  tolerance = 1e-8;
  T_crit_lower_bound = 1.1;
  T_crit_upper_bound = 1.2;
  initial_range = [T_crit_lower_bound T_crit_upper_bound];
  TolX = 1e-8;
  method = 'energy gap';

  range = initial_range;
  for chi = chi_values
    [T_pseudocrit, entropy, energy_gap] = find_T_pseudocrit(chi, tolerance, q, range, TolX, method);
    save_to_db(T_pseudocrit, entropy, energy_gap, chi, tolerance, q, TolX, method);
    % We assume the pseudocritical temperature of a system with bigger chi
    % will be smaller than the previous pseudocritical temperature
    range = [range(1) T_pseudocrit];
  end


end

function save_to_db(T_pseudocrit, entropy, energy_gap, chi, tolerance, q, TolX, method);
  db_path = fullfile(Constants.DB_DIR, 't_pseudocrits.db');
  db_id = sqlite3.open(db_path);
  query = ['insert into t_pseudocrits ' ...
    '(t_pseudocrit, entropy, energy_gap, chi, tolerance, tol_x, q, method)' ...
    ' values (?, ?, ?, ?, ?, ?, ?, ?)'];
  sqlite3.execute(db_id, query, T_pseudocrit, entropy, energy_gap, chi, tolerance, TolX, q, method);
  sqlite3.close(db_id)
end

% function name = filename()
%   name = ['T_pseudocrits_energy_gap' datestr(now)];
% end

function [T_pseudocrit, entropy, energy_gap] = find_T_pseudocrit(chi, tolerance, q, range, TolX, method)
  function negative_entropy = minimize_negative_entropy(temperature)
    % We maximize the entropy to find the pseudocritical point.
    sim = FixedToleranceSimulation(temperature, chi, tolerance, q).run();
    negative_entropy = -sim.compute(Entropy);
  end

  function energy_gap = minimize_energy_gap(temperature)
    % Minimize energy gap to find the pseudocritical point
    sim = FixedToleranceSimulation(temperature, chi, tolerance, q).run();
    energy_gap = sim.compute('energy_gap');
  end

  if strcmp(method, 'entropy')
    f_minimize = @minimize_negative_entropy;
  elseif strcmp(method, 'energy gap');
    f_minimize = @minimize_energy_gap;
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_pseudocrit, minimized_quantity, EXITFLAG, OUTPUT] = fminbnd(f_minimize, ...
    range(1), range(2), options);

  if strcmp(method, 'entropy')
    entropy = -minimized_quantity;
    energy_gap = NaN;
  elseif strcmp(method, 'energy gap')
    energy_gap = minimized_quantity;
    entropy = NaN;
  end
end
