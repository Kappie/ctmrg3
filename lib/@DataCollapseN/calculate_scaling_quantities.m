function obj = calculate_scaling_quantities(obj)
  sim = FixedNSimulation(obj.temperatures, obj.chi_max, obj.N_values, obj.q).run()
  obj.scaling_quantities = sim.compute('order_parameter');
  truncation_error_structs = sim.compute('truncation_error');
  obj.truncation_errors = arrayfun(@(s) s.truncation_error, truncation_error_structs);
end
