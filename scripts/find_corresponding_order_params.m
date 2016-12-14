function order_params = find_corresponding_order_params(temperatures, chi_values, tolerance)
  order_params = containers.Map('keyType', 'double', 'valueType', 'any');
  for chi = chi_values
    % I transpose temperatures(:, c) because I need to pass in a row
    sim = FixedToleranceSimulation(temperatures(chi), chi, tolerance).run();
    order_params(chi) = sim.compute(OrderParameterStrip);
  end
end
