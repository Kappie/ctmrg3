function test_clock_model
  q = 4;
  initial_conditions = {'spin-up'};
  width = 0.05;
  T_start = Constants.T_crit_guess(q) - width;
  T_end = Constants.T_crit_guess(q) + width;
  number_of_points = 10;
  temperatures = linspace(T_start, T_end, number_of_points);
  chi_values = [4, 16, 26, 40]
  tolerance = 1e-7;

  entropies = zeros(numel(initial_conditions), numel(temperatures));
  % for i = 1:numel(initial_conditions)
    sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q);
    sim.initial_condition = initial_conditions{1}
    sim = sim.run();
    entropies = sim.compute('entropy')
    % entropies(i, :) = sim.compute('entropy');

  markerplot(temperatures, entropies, '--')
  make_legend(chi_values, '\chi')
  xlabel('$T$')
  ylabel('$S(T, \chi)$')
  title('$q = 4$ clock model')
  % legend(initial_conditions, 'Location', 'best')
  % xlabel('$T$')
  % ylabel('$S(T, \chi)$')
  % title('$q = 5$ clock model')
  %
  % make_legend(chi_values, '\chi')






end
