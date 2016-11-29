function free_energy_competing_states
  number_of_points = 10; left_width = 0.001; right_width = 0.001;
  % note temperatures are traversed from high to low:
  % we want to bias the simulation towards a symmetric state.
  % temperatures = linspace(Constants.T_crit - left_width, Constants.T_crit + right_width, number_of_points);
  chi = 2;
  temperatures = linspace(Constants.T_pseudocrit(chi) - left_width, Constants.T_pseudocrit(chi) + right_width, number_of_points);
  chi_values = [chi];
  tolerance = 1e-7;

  [order_params_symm, free_energies_symm, trunc_errors_sym] = reuse_previously_converged_tensors(flip(temperatures), chi_values, tolerance);
  order_params_symm = flip(order_params_symm);
  free_energies_symm = flip(free_energies_symm);
  trunc_errors_sym = flip(trunc_errors_sym);

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  order_params = sim.compute(OrderParameter);
  free_energies = sim.compute(FreeEnergy);


  subplot(2, 1, 1)
  markerplot(temperatures, [order_params_symm order_params], '--')
  legend({['$\chi = ' num2str(chi) '$, symmetric boundary'], ['$\chi = ' num2str(chi) '$, magnetized boundary']}, 'Location', 'NorthEast')
  vline(Constants.T_pseudocrit(chi), '--')
  ylabel('$m$')
  xlabel('$T$')

  subplot(2, 1, 2)

  diffs = free_energies_symm - free_energies
  sign_diffs = sign(diffs)
  % log_diffs = -sign(diffs) .* log10(abs(diffs))
  yyaxis left
  markerplot(temperatures, sign_diffs, '--')
  yticks([-1 1])
  ylabel('$\mathrm{sgn}(\Delta f)$')

  yyaxis right
  markerplot(temperatures, abs(diffs), '--', 'semilogy')
  ylabel('$\|Delta f|$')

  vline(Constants.T_pseudocrit(chi), '--')
  xlabel('$T$')


end

function [order_parameters, free_energies, truncation_errors] = reuse_previously_converged_tensors(temperatures, chi_values, tolerance)
% traverses temperatures array from left to right.

  sim = FixedToleranceSimulation(temperatures, [], []);
  order_parameters = zeros(numel(temperatures), numel(chi_values));
  free_energies = zeros(numel(temperatures), numel(chi_values));
  truncation_errors = zeros(numel(temperatures), numel(chi_values));


  for c = 1:numel(chi_values)
    % [C, T] = sim.initial_tensors(temperatures(1));
    [C, T] = initial_tensors(temperatures(1), chi_values(c), tolerance);

    for t = 1:numel(temperatures)
      [C, T, ~, ~, ~, truncation_error] = sim.calculate_environment(temperatures(t), chi_values(c), tolerance, C, T);
      order_parameters(t, c) = OrderParameter.value_at(temperatures(t), C, T);
      free_energies(t, c) = FreeEnergy.value_at(temperatures(t), C, T);
      truncation_errors(t, c) = truncation_error;
    end
  end
end

function [C, T] = initial_tensors(temperature, chi, tolerance)
  % we want to acquire initial tensors that are firmly 'symmetrically biased'.
  % for this reason, we simulate at a certain higher temperature point, for
  % which we can be sure the outcome is symmetric.
  % assuming the temperature for which we need initial tensors is above the critical point,
  % this value of delta is sure to return tensors that belong to a m = 0 ising model.
  delta = 0.1;
  sim = FixedToleranceSimulation(temperature + delta, chi, tolerance);
  sim.SAVE_TO_DB = false; sim.LOAD_FROM_DB = false;
  sim = sim.run();
  C = sim.tensors.C;
  T = sim.tensors.T;
end
