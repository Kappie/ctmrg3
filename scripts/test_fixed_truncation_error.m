function test_fixed_truncation_error
  temperatures = Constants.T_crit;
  N_values = [20 30 40];
  q = 2;
  max_truncation_error = 1e-6;

  sim = FixedTruncationErrorSimulation(temperatures, N_values, max_truncation_error, q);
  sim.SAVE_TO_DB = false; sim.LOAD_FROM_DB = false;
  sim = sim.run()
  sim.compute('order_parameter')
end
