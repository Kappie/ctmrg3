function order_param_test
  q = 2;
  temperature = 2;
  chi = 6;
  N_values = 10:10:100

  sim = FixedNSimulation(temperature, chi, N_values, q);
  sim.initial_condition = 'symmetric';
  sim = sim.run();

  order_parameters = sim.compute('order_parameter')
  markerplot(N_values, order_parameters, '--')

  % markerplot(1:chi, diag(sim.tensors.C), '--', 'semilogy')
end
