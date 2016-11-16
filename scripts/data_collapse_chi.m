function data_collapse_chi
  chi_values = [32 37];
  x_start = -0.2; x_end = +0.1;
  number_of_points = 10;
  % x_values = linspace(0.1, 0.2, 10);
  x_values = linspace(x_start, x_end, number_of_points);
  temperatures_per_chi = 1e3;
  tolerances = [1e-8];
  max_x_err = 1e-3;
  tolerance_correlation_length = 1e-6;

  DATABASE = fullfile(Constants.DB_DIR, 'scaling_function.db');

  calculate_corresponding_temperatures(x_values, chi_values, tolerance_correlation_length, max_x_err, DATABASE);
  % temperatures = retrieve_corresponding_temperatures(x_values, chi_values, DATABASE);

  temperatures = retrieve_all_temperatures(x_start, x_end, chi_values, temperatures_per_chi, DATABASE);

  order_parameters = containers.Map('keyType', 'double', 'valueType', 'any');
  correlation_lengths = containers.Map('keyType', 'double', 'valueType', 'any');

  for chi = chi_values
    sim = FixedToleranceSimulation(temperatures(chi), [chi], tolerances);
    sim.initial_condition = 'spin-up';
    sim = sim.run();
    order_parameters(chi) = sim.compute(OrderParameterStrip);
    correlation_lengths(chi) = sim.compute(CorrelationLengthAfun);
  end


  % DO DATA COLLAPSE
  % Critical exponents
  beta = 1/8; nu = 1;
  MARKERS = markers();

  figure
  hold on
  marker_index = 1;
  legend_labels = {};

  for chi = chi_values
    for tol = 1:numel(tolerances)
      temperatures_chi = temperatures(chi);
      correlation_lengths_chi = correlation_lengths(chi);
      order_parameters_chi = order_parameters(chi);
      % T_pseudocrit = Constants.T_pseudocrit(chi);

      x_values = zeros(1, numel(temperatures_chi));
      scaling_function_values = zeros(1, numel(temperatures_chi));

      for t = 1:numel(temperatures_chi)
        % x_values(t) = Constants.reduced_T_dot(temperatures_chi(t), T_pseudocrit) * correlation_lengths_chi(t)^(1/nu);
        % x_values(t) = Constants.reduced_T(temperatures_chi(t)) * correlation_lengths_chi(t, tol)^(1/nu);
        x_values(t) = Constants.reduced_T(temperatures_chi(t)) * correlation_lengths_chi(t)^(1/nu);
        % x_values(t) = correlation_lengths_chi(t, tol) / Constants.correlation_length(temperatures_chi(t));
        % scaling_function_values(t) = order_parameters_chi(t, tol) * correlation_lengths_chi(t, tol)^(beta/nu);
        scaling_function_values(t) = order_parameters_chi(t) * correlation_lengths_chi(t)^(beta/nu);
      end

      marker = MARKERS(marker_index);
      plot(x_values, scaling_function_values, marker);
      marker_index = marker_index + 1;
      % legend_labels{end + 1} = ['$\chi$ = ' num2str(chi) ' tol = ' num2str(tolerances(tol))];
    end
  end

  make_legend(chi_values, '\chi')
  xlabel('$t\xi(\chi, T)^{1/\nu}$');
  ylabel('$m(T, \chi)\xi(\chi,T)^{\beta/\nu}$')
  title(['Tolerance  = $10^{' num2str(mantexpnt(tolerances(1))) '}$'])
  legend(legend_labels)
  % title('Scaling ansatz for $\xi(\chi, T)$. Tolerance = $10^{-7}$. $|T - T_c| < 0.05$.')
end

% find t * xi(chi, t) ^ (1/v) that equals x
% Used for finding equally spaced values for making a nice data collapse.
function calculate_corresponding_temperatures(x_values, chi_values, tolerance_correlation_length, max_x_err, db)
  db_id = sqlite3.open(db);

  % round to 5 decimal places; the x coordinate doesn't matter to high precision
  % in a data collapse.
  x_values = arrayfun(@(x) round(x, 5), x_values);
  temperatures = zeros(1, numel(x_values));
  width = 0.05;

  function stop = outfun(chi, temperature, optimValues, state)
    if strcmp(state, 'done') | optimValues.fval < max_x_err
      stop = true;
    elseif strcmp(state, 'init')
      stop = false;
    else
      x_value = Constants.reduced_T(temperature) * ...
        calculate_correlation_length(temperature, chi, tolerance_correlation_length);
      store_to_db(x_value, temperature, chi, 0, max_x_err, db_id);
      stop = false;
    end
  end

  for x_index = 1:numel(x_values)
    for chi_index = 1:numel(chi_values)
      %
      % outfun_chi = @(temperature, optimValues, state) outfun(chi_values(chi_index), temperature, optimValues, state);
      options = optimset('Display', 'iter', 'TolX', 1e-8, 'OutputFcn', @(temperature, optimValues, state) outfun(chi_values(chi_index), temperature, optimValues, state));

      if ~isempty(query_db(x_values(x_index), chi_values(chi_index), db_id))
        display(['Already in DB: ' num2str(x_values(x_index))])
        continue
      else
        f = @(temperature) (abs(Constants.reduced_T(temperature) * calculate_correlation_length(temperature, chi_values(chi_index), tolerance_correlation_length) - x_values(x_index)));
        [temperature, err] = fminbnd(f, Constants.T_crit - width, Constants.T_crit + width, options)
        store_to_db(x_values(x_index), temperature, chi_values(chi_index), err, max_x_err, db_id)
      end
    end
  end

  sqlite3.close(db);
end

function store_to_db(x, temperature, chi, err, max_x_err, db_id)
  x = round(x, 5);
  if err > max_x_err
    fprintf(['not storing this shit: error is ', num2str(err), '.\n'])
  else
    query = 'insert into scaling_function (x, temperature, chi, error) values (?, ?, ?, ?);';
    sqlite3.execute(db_id, query, x, temperature, chi, err);
    fprintf('stored that shit to db.\n')
  end
end

function temperatures = retrieve_corresponding_temperatures(x_values, chi_values, db)
  db_id = sqlite3.open(db);

  temperatures = zeros(numel(x_values), numel(chi_values));
  for x_index = 1:numel(x_values)
    for chi_index = 1:numel(chi_values)
      result = query_db(x_values(x_index), chi_values(chi_index), db_id);
      temperatures(x_index, chi_index) = result.temperature;
    end
  end
end

function xi = calculate_correlation_length(temperature, chi, tolerance)
  if temperature < 0
    xi = 0;
  elseif temperature > 20
    error('hou maar op')
  else
    sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
    xi = sim.compute(CorrelationLength2);
  end
end

function result = query_db(x, chi, db_id)
  x = round(x, 5);
  query = 'select * from scaling_function where x = ? AND chi = ?;';
  result = sqlite3.execute(db_id, query, x, chi);
end

function temperatures = retrieve_all_temperatures(x_start, x_end, chi_values, temperatures_per_chi, db)
  db_id = sqlite3.open(db);
  temperatures = containers.Map('KeyType', 'double', 'ValueType', 'any');

  for c = 1:numel(chi_values)
    query = ['select x, temperature from scaling_function ' ...
      'where x >= ? and x <= ? ' ...
      'and chi = ?;'];
    result = sqlite3.execute(db_id, query, x_start, x_end, chi_values(c));
    temps = arrayfun(@(s) s.temperature, result);
    x_values = arrayfun(@(s) s.x, result);
    % thin out, in order to not get too much temperatures (takes longer to simulate and curve is already clear.)
    step_size = ceil(numel(temps) / temperatures_per_chi);
    temps = temps(1:step_size:end);
    temperature_width = 0.001;
    temps = keep(temps, @(T) T > Constants.T_crit - temperature_width & T < Constants.T_crit + temperature_width);
    if isempty(temps)
      display(['no temperatures for temperature width = ' num2str(temperature_width) ' and chi = ' num2str(chi_values(c))])
    end
    temperatures(chi_values(c)) = temps;
  end
end

function array = keep(array, p)
  indices_to_keep = p(array);
  array = array(indices_to_keep);
end
