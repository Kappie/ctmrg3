function data_collapse_chi_power_law
  reduced_temperature_width = 0.001;
  number_of_points = 10;

  chi_values = [12 20 28 36 44];
  tolerance = 1e-7;

  temperatures = corresponding_temperatures(chi_values, reduced_temperature_width, number_of_points);
  order_params = corresponding_order_params(temperatures, chi_values, tolerance);

  initial_kappa = 1.9;
  initial_beta = 0.125;
  corr_lengths = corr_lengths_initial(chi_values);
  % corr_lengths = correlation_length_at_T_crit(chi_values, tolerance);
  [kappa, beta] = optimize_kappa_beta(chi_values, temperatures, order_params, initial_kappa, initial_beta)
  % beta = optimize_beta(chi_values, temperatures, order_params, corr_lengths, initial_beta)

  % Plot data collapse for optimal values
  optimal_corr_lengths = chi_values .^ kappa;
  data_collapse(chi_values, temperatures, order_params, optimal_corr_lengths, beta, true)

  make_legend(chi_values, '\chi')
  xlabel('$x \equiv t \chi^\kappa$')
  ylabel('$\chi^{\kappa \beta / \nu} m(t, \chi)$')
  title([
  'Best fit with polynomial of order 5 gives $\beta = ' ...
  num2str(beta) ', \kappa =  ' num2str(kappa) '$.'
  ])
  % title(['Best fit with polynomial of order 5 gives $\beta = ' ...
  %   num2str(beta) ', \kappa = ' num2str(kappa) '$.'])
end

function [beta] = optimize_beta(chi_values, temperatures, order_params, correlation_lengths, initial_beta)
  % Input:
  % temperatures: map from chi value to array
  %
  % Fixes kappa to values found from earlier simulations.

  function fitness = fitness_collapse(beta)
    [mean_squared_error, ~, norm_of_residuals] = data_collapse(chi_values, temperatures, order_params, correlation_lengths, beta);
    fitness = norm_of_residuals;
  end

  options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-4);
  beta = fminsearch(@fitness_collapse, initial_beta, options);
end

function [kappa, beta] = optimize_kappa_beta(chi_values, temperatures, order_params, initial_kappa, initial_beta)
  % Input:
  % temperatures and order_params: map from chi value to array
  %
  % Finds best kappa and beta for data collapse of the form:
  % f(t * chi^kappa) = m(t, chi) * chi^{kappa * beta}
  % (here, we have put \nu = 1 for simplicity.)

  function fitness = fitness_collapse(exponents)
    kappa = exponents(1);
    beta = exponents(2);

    correlation_lengths = chi_values .^ kappa;
    % correlation_lengths = [corr_length; correlation_length_benchmark];
    [mean_squared_error, ~, norm_of_residuals] = data_collapse(chi_values, temperatures, order_params, correlation_lengths, beta);
    fitness = norm_of_residuals;
  end

  options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-4);
  optimal_exponents = fminsearch(@fitness_collapse, [initial_kappa, initial_beta], options)
  kappa = optimal_exponents(1);
  beta = optimal_exponents(2);
end

function corr_lengths = corr_lengths_initial(chi_values)
  % as an indication of the correlation length corresponding to a chi-value
  % we take 10^intersect * chi^slope that we find from simulations.
  kappa = 1.900;
  constant_term = 10^0.0806;

  corr_lengths = constant_term * chi_values .^ kappa;
end

function temperatures = corresponding_temperatures(chi_values, reduced_temperature_width, number_of_points)
  % Given correlation lengths and a temperature width, give corresponding
  % temperatures that such that x values per correlation length match.
  % Output:
  % temperatures: map from chi value to array
  corr_lengths = corr_lengths_initial(chi_values)
  x_width = corr_lengths(1) * reduced_temperature_width;
  temperatures = containers.Map('keyType', 'double', 'valueType', 'any');

  for c = 1:numel(chi_values)
    chi = chi_values(c);
    t_width = x_width / corr_lengths(c);
    temperatures_chi = Constants.inverse_reduced_Ts(linspace(-t_width, 0, number_of_points));
    % Remove T_crit, because the data collapse doesn't seem to work very well close to it.
    % temperatures(chi) = temperatures_chi(1:end-1)
    temperatures(chi) = temperatures_chi;
  end
end

function order_params = corresponding_order_params(temperatures, chi_values, tolerance)
  % Input:
  % temperatures: map from chi value to array
  % Output:
  % order_params: map from chi value to array
  order_params = containers.Map('keyType', 'double', 'valueType', 'any');

  for chi = chi_values
    sim = FixedToleranceSimulation(temperatures(chi), chi, tolerance).run();
    order_params(chi) = sim.compute(OrderParameter);
  end
end

function corr_lengths = correlation_length_at_T_crit(chi_values, tolerance)
  sim = FixedToleranceSimulation(Constants.T_crit, chi_values, tolerance).run();
  corr_lengths = sim.compute(CorrelationLengthAfun);
end
