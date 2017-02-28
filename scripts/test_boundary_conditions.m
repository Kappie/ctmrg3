function test_boundary_conditions
  q = 5;
  temperatures = linspace(0.9, 1.3, 6);
  chi_values = [4, 16];
  tolerance = 1e-7;
  initial_conditions = {'spin-up', 'symmetric'};

  entropies = zeros(numel(initial_conditions), numel(temperatures));
  order_parameters = zeros(numel(initial_conditions), numel(temperatures));

  for i = 1:numel(initial_conditions)
    sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q);
    sim.initial_condition = initial_conditions{i};
    sim = sim.run();
    entropies(i, :) = sim.compute('entropy');
    order_parameters(i, :) = sim.compute('order_parameter')
  end

  markerplot(temperatures, entropies, '--')
  legend(initial_conditions)
end
