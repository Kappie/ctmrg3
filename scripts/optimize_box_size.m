function optimal_box_size = optimize_box_size(temperatures, chi_values, order_parameters)
  % input
  % temperatures: map from double to array
  % chi_values: array
  % order_parameters: map from double to array
  %
  % This function takes the scaling function of the largest chi value (calculated with
  % correlation length at T_crit) as a benchmark, and tries to find correlation lengths
  % corresponding with the other chi_values to minimize the error in the data collapse
  %
  %
  %
  % assumption for now is that chi_values has only 2 values, a benchmark and a value to fit.
  tolerance = 1e-7;
  sim = FixedToleranceSimulation(Constants.T_crit, chi_values, tolerance).run();
  correlation_lengths_benchmark = sim.compute(CorrelationLengthAfun);
  % chi_benchmark = chi_values(end);
  % chi = chi_values(1);
  % correlation_length_benchmark = calculate_correlation_length(Constants.T_crit, chi_benchmark, tolerance);

  function mean_squared_error = mse_collapse(correlation_lengths)
    % correlation_lengths = [corr_length; correlation_length_benchmark];
    [mean_squared_error, ~] = data_collapse(chi_values, temperatures, order_parameters, correlation_lengths);
  end

  % options = optimset('Display', 'iter');
  options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-8);
  optimal_box_sizes = fminsearch(@mse_collapse, correlation_lengths_benchmark, options)
  % optimal_box_size = fminbnd(@mse_collapse, 10, correlation_length_benchmark, options)
  % corr_length_transfer_matrix = calculate_correlation_length(Constants.T_crit, chi, tolerance)
  correlation_lengths_benchmark
  correlation_lengths_benchmark(2) / correlation_lengths_benchmark(1)
  optimal_box_sizes(2) / optimal_box_sizes(1)
  data_collapse(chi_values, temperatures, order_parameters, optimal_box_sizes, true)
  optimal_box_size = 3;
end
