function data_collapse_chi
  % chi_values = [6 10 12 18 22 27 32 38];
  chi_values = [10 18 27 32 ]
  x_start = -0.10; x_end = +0.0;
  number_of_points = 9;
  x_values = linspace(x_start, x_end, number_of_points);
  temperatures_per_chi = 30;
  tolerances = [1e-7];
  max_x_err = 1e-3;
  tolerance_correlation_length = 1e-6;

  DATABASE = fullfile(Constants.DB_DIR, 'tensors.db');

  calculate_corresponding_temperatures(x_values, chi_values, tolerance_correlation_length, max_x_err, DATABASE);

  temperatures = retrieve_all_temperatures(x_start, x_end, chi_values, temperatures_per_chi, DATABASE);

  [order_parameters, correlation_lengths] = select_order_params_and_correlation_lengths_with_best_boundary(chi_values, temperatures, tolerances);


  [total_mse, mse_chi_values] = data_collapse(chi_values, temperatures, order_parameters, correlation_lengths)

  make_legend(chi_values, '\chi')
  xlabel('$t\xi(\chi, T)^{1/\nu}$');
  ylabel('$m(T, \chi)\xi(\chi,T)^{\beta/\nu}$')
  title(['Tolerance  = $10^{' num2str(mantexpnt(tolerances(1))) '}$'])
  legend_labels = {};
  for c = 1:numel(chi_values)
    if c == numel(chi_values)
      legend_labels{end + 1} = ['$\chi = ' num2str(chi_values(c)) '$'];
    else
      legend_labels{end + 1} = ['$\chi = ' num2str(chi_values(c)) '$, mse = ' num2str(mse_chi_values(c))];
    end
  end
  legend(legend_labels, 'Location', 'best')
end

function [total_mse, mse_chi_values] = data_collapse(chi_values, temperatures, order_parameters, correlation_lengths)
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

  x_values = containers.Map('keyType', 'double', 'valueType', 'any');
  scaling_function_values = containers.Map('keyType', 'double', 'valueType', 'any');

  for chi = chi_values
    temperatures_chi = temperatures(chi);
    correlation_lengths_chi = correlation_lengths(chi);
    order_parameters_chi = order_parameters(chi);
    x_values_chi = zeros(1, numel(temperatures_chi));
    scaling_function_values_chi = zeros(1, numel(temperatures_chi));

    for t = 1:numel(temperatures_chi)
      x_values_chi(t) = Constants.reduced_T(temperatures_chi(t)) * correlation_lengths_chi(t)^(1/nu);
      scaling_function_values_chi(t) = order_parameters_chi(t) * correlation_lengths_chi(t)^(beta/nu);
    end

    marker = MARKERS(marker_index);
    plot(x_values_chi, scaling_function_values_chi, marker);
    marker_index = marker_index + 1;

    x_values(chi) = x_values_chi;
    scaling_function_values(chi) = scaling_function_values_chi;
  end

  [total_mse, mse_chi_values] = mse_data_collapse(x_values, scaling_function_values, chi_values);
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
    temperature_width = 0.01;
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
