function data_collapse_chi
  % chi_values = [23 27 32 33 42 43];
  % chi_values = [27 28 29 30 31 32];
  % chi_values = [6 10 12 18 22 27 32 38];
  chi_values = [6 18 27 38]
  % chi_values = [6 10 12];
  x_start = -0.10; x_end = +0.1;
  number_of_points = 5;
  x_values = linspace(x_start, x_end, number_of_points);
  temperatures_per_chi = 15;
  tolerances = [1e-7];
  max_x_err = 1e-3;
  tolerance_correlation_length = 1e-6;

  DATABASE = fullfile(Constants.DB_DIR, 'tensors.db');

  % calculate_corresponding_temperatures(x_values, chi_values, tolerance_correlation_length, max_x_err, DATABASE);

  temperatures = retrieve_all_temperatures(x_start, x_end, chi_values, temperatures_per_chi, DATABASE);

  [order_parameters, correlation_lengths] = select_order_params_and_correlation_lengths_with_best_boundary(chi_values, temperatures, tolerances);


  data_collapse(chi_values, temperatures, order_parameters, correlation_lengths)

  make_legend(chi_values, '\chi')
  xlabel('$t\xi(\chi, T)^{1/\nu}$');
  ylabel('$m(T, \chi)\xi(\chi,T)^{\beta/\nu}$')
  title(['Tolerance  = $10^{' num2str(mantexpnt(tolerances(1))) '}$'])
end

function data_collapse(chi_values, temperatures, order_parameters, correlation_lengths)
  % chi_values: array
  % temperatures: map from double to array
  % order_parameters: map from double to array
  % correlation_lengths: map from double to array

  % Critical exponents
  beta = 1/8; nu = 1;
  MARKERS = markers();

  figure
  hold on
  marker_index = 1;

  for chi = chi_values
    temperatures_chi = temperatures(chi);
    correlation_lengths_chi = correlation_lengths(chi);
    order_parameters_chi = order_parameters(chi);

    x_values = zeros(1, numel(temperatures_chi));
    scaling_function_values = zeros(1, numel(temperatures_chi));

    for t = 1:numel(temperatures_chi)
      x_values(t) = Constants.reduced_T(temperatures_chi(t)) * correlation_lengths_chi(t)^(1/nu);
      scaling_function_values(t) = order_parameters_chi(t) * correlation_lengths_chi(t)^(beta/nu);
    end

    marker = MARKERS(marker_index);
    plot(x_values, scaling_function_values, marker);
    marker_index = marker_index + 1;
  end
end

function [order_parameters, correlation_lengths] = select_order_params_and_correlation_lengths_with_best_boundary(chi_values, temperatures, tolerance)
  % chi_values: 1D array
  % temperatures: map from double to array

  order_parameters = containers.Map('keyType', 'double', 'valueType', 'any');
  correlation_lengths = containers.Map('keyType', 'double', 'valueType', 'any');

  for chi = chi_values
    temperatures_chi = temperatures(chi);
    order_params_chi = zeros(1, numel(temperatures_chi));
    corr_lengths_chi = zeros(1, numel(temperatures_chi));
    for t = 1:numel(temperatures_chi)
      [free_energy_spin_up, sim_spin_up] = calculate_free_energy(temperatures_chi(t), chi, tolerance, 'spin-up');
      % [free_energy_symmetric, sim_symmetric] = calculate_free_energy(temperatures_chi(t), chi, tolerance, 'symmetric');

      % if free_energy_spin_up < free_energy_symmetric
      %   sim = sim_spin_up;
      % else
      %   sim = sim_symmetric;
      % end
      sim = sim_spin_up;

      order_params_chi(t) = sim.compute(OrderParameter);
      corr_lengths_chi(t) = sim.compute(CorrelationLengthAfun);
    end

    order_parameters(chi) = order_params_chi;
    correlation_lengths(chi) = corr_lengths_chi;
  end
end

function [free_energy, sim] = calculate_free_energy(temperature, chi, tolerance, initial_condition)
  sim = FixedToleranceSimulation(temperature, chi, tolerance);
  sim.initial_condition = initial_condition;
  sim = sim.run();
  free_energy = sim.compute(FreeEnergy);
end

% find t * xi(chi, t) ^ (1/v) that equals x
% Used for finding equally spaced values for making a nice data collapse.
function calculate_corresponding_temperatures(x_values, chi_values, tolerance_correlation_length, max_x_err, db)
  db_id = sqlite3.open(db);

  % round to 5 decimal places; the x coordinate doesn't matter to high precision
  % in a data collapse.
  x_values = arrayfun(@(x) round(x, 5), x_values);
  temperatures = zeros(1, numel(x_values));
  width = 0.20;

  function stop = outfun(chi, temperature, optimValues, state)
    % if strcmp(state, 'done') | optimValues.fval < max_x_err
    %   stop = true;
    % elseif strcmp(state, 'init')
    %   stop = false;
    % else
    %   correlation_length = calculate_correlation_length(temperature, chi, tolerance_correlation_length);
    %   x_value = Constants.reduced_T(temperature) * correlation_length;
    %   store_to_db(x_value, correlation_length, temperature, chi, 0, max_x_err, db_id);
    %   stop = false;
    % end
    stop = false;

    if strcmp(state, 'done') | optimValues.fval < max_x_err
      stop = true;
    end

    if ~strcmp(state, 'init')
      correlation_length = calculate_correlation_length(temperature, chi, tolerance_correlation_length);
      x_value = Constants.reduced_T(temperature) * correlation_length;
      store_to_db(x_value, correlation_length, temperature, chi, 0, max_x_err, db_id);
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
        correlation_length = calculate_correlation_length(temperature, chi_values(chi_index), tolerance_correlation_length);
        store_to_db(x_values(x_index), correlation_length, temperature, chi_values(chi_index), err, max_x_err, db_id)
      end
    end
  end

  sqlite3.close(db);
end

function store_to_db(x, correlation_length, temperature, chi, err, max_x_err, db_id)
  x = round(x, 5);
  if err > max_x_err
    warning(['could not converge on x value of ' num2str(x) ' . Error is ' num2str(err) '.'])
  else
    query = 'insert into scaling_function (x, correlation_length, temperature, chi, error) values (?, ?, ?, ?, ?);';
    sqlite3.execute(db_id, query, x, correlation_length, temperature, chi, err);
  end

  % try to prevent matlab from crashing :(
  fclose('all');
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
    xi = sim.compute(CorrelationLengthAfun);
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
    query = ['select x, correlation_length, temperature from scaling_function ' ...
      'where x >= ? and x <= ? ' ...
      'and chi = ?;'];
    result = sqlite3.execute(db_id, query, x_start, x_end, chi_values(c));
    struct2table(result)

    temps = unique(arrayfun(@(s) s.temperature, result));
    temps' - Constants.T_pseudocrit(24)'
    x_values = unique(arrayfun(@(s) s.x, result));
    % thin out, in order to not get too much temperatures (takes longer to simulate and curve is already clear.)
    step_size = ceil(numel(temps) / temperatures_per_chi);
    temps = temps(1:step_size:end);
    temperature_width = 10;
    temps = keep(temps, @(T) T > Constants.T_crit - temperature_width & T < Constants.T_crit + temperature_width);
    if isempty(temps)
      display(['no temperatures for temperature width = ' num2str(temperature_width) ' and chi = ' num2str(chi_values(c))])
    end
    temperatures(chi_values(c)) = temps;
    disp(['found ' num2str(numel(temps)) ' temperatures for chi = ' num2str(chi_values(c)) '.'])
  end
end

function array = keep(array, p)
  indices_to_keep = p(array);
  array = array(indices_to_keep);
end
