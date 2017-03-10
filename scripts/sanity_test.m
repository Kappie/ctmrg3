function sanity_test
  temperature = Constants.T_crit + 1;
  chi = 12;
  tolerance = 1e-10;
  q = 2;

  sim = FixedToleranceSimulation(temperature, chi, tolerance, q);
  sim.LOAD_FROM_DB = false; sim.SAVE_TO_DB = false;

  sim = sim.run();
  order_parameter = sim.compute('order_parameter');
  order_parameter_exact = Constants.order_parameter(temperature);

  IsNear(order_parameter, order_parameter_exact, 1e-12)
end
