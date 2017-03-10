function obj = calculate_scaling_quantities(obj)
  sim = FixedTruncationErrorSimulation(obj.temperatures, obj.N_values, obj.truncation_error, obj.q).run();
  obj.scaling_quantities = sim.compute('order_parameter');
  obj.simulation = sim;
end
