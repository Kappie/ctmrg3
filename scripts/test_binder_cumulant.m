function test_binder_cumulant
  width = 0.1; number_of_points = 9;
  temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, number_of_points)
  chi_values = [4];
  tolerance = 1e-7;

  cumulants = zeros(numel(temperatures), numel(chi_values));

  for t = 1:numel(temperatures)
    for c = 1:numel(chi_values)
      disp(['doing chi = ' num2str(chi_values(c)) ', temp = ' num2str(temperatures(t)) '.'])
      cumulants(t, c) = binder_cumulant(temperatures(t), chi_values(c), tolerance);
    end
  end

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  sim.initial_condition = 'symmetric';
  magnetizations = sim.compute(Magnetization);
  % ratios = cumulants(:, 1) ./ cumulants(:, 2)
  % cumulants
  markerplot(temperatures, [cumulants magnetizations], '--');
end
