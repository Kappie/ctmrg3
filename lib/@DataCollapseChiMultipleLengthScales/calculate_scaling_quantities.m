function obj = calculate_scaling_quantities(obj)
  sim = FixedToleranceSimulation(obj.temperatures, obj.chi_values, obj.tolerance, obj.q).run();
  obj.scaling_quantities = sim.compute('order_parameter');
  obj.simulation = sim;
end
