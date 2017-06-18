function calculate_beta
  q = 2;
  epsilon = 1e-3;
  RIGHT_BOUND = Constants.T_crit + epsilon;
  width = 0.1; number_of_points = 30;
  temperatures = linspace(RIGHT_BOUND - width, RIGHT_BOUND, number_of_points);
  chi = 50;
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi, tolerance, q).run();
  order_parameters = sim.compute('order_parameter');

  % markerplot(temperatures, order_parameters, '--')
  [slope, intercept] = logfit(-temperatures + RIGHT_BOUND, order_parameters, 'loglog')
end
