function fit_magnetization
  q = 2;
  number_of_points = 10; width = 0.001;
  RIGHT_BOUND = Constants.T_crit_guess(q);
  temperatures = linspace(RIGHT_BOUND - width, RIGHT_BOUND, number_of_points);
  chi_values = [4 10 20 30 40 50 60 70 80 90];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  order_params = sim.compute('order_parameter');
  order_params(:,end)
  % markerplot(temperatures, order_params, '--');
  % make_legend(chi_values, '\chi')
end
