function find_T_crit
  q_values = [2];
  % T_crit_bounds = {[2.2 2.3], [1.1 1.2]};
  % T_crit_bounds = {[1.1 1.2]};
  T_crit_bounds = {[2.2 2.3]};
  chi_values = 22:2:30;
  tolerance = 1e-7;
  TolX = 1e-6;
  method = 'energy gap';

  for chi = chi_values
    for q_index = 1:numel(q_values)
      range = T_crit_bounds{q_index};
      q = q_values(q_index);
      if is_in_db(chi, tolerance, q, TolX, method)
	display(['Already in database for q = ' num2str(q) ' chi = ' num2str(chi)])
        [T_pseudocrit, entropy, energy_gap] = find_T_pseudocrit(chi, tolerance, q, range, TolX, method);
        save_to_db(T_pseudocrit, entropy, energy_gap, chi, tolerance, q, TolX, method);
      end
      % We assume the pseudocritical temperature of a system with bigger chi
      % will be smaller than the previous pseudocritical temperature
      % Don't do this anymore: the sequence of temperatures tried by the algorithm depends on the
      % initial range, so it is better to leave it always the same.
      % range = [range(1) T_pseudocrit];
    end
  end


end

function answer = is_in_db(chi, tolerance, q, TolX, method)
  db_path = fullfile(Constants.DB_DIR, 't_pseudocrits.db');
  query = ['select * from t_pseudocrits ' ...
    'where chi = ? and tolerance = ? and q = ? and tol_x = ? and method = ?'];
  db_id = sqlite3.open(db_path);
  result = sqlite3.execute(db_id, query, chi, tolerance, q, TolX, method);
  sqlite3.close(db_id);

  answer = isempty(result);
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
    negative_entropy = -sim.compute('entropy');
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
