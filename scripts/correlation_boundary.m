function correlation_boundary
  width = 0.1;
  % temperatures = [Constants.T_crit + width/10, Constants.T_crit + width];
  temperatures = [Constants.T_crit + 0.001];
  chi_values = [4];
  steps = 3000;

  magnetizations = zeros(numel(temperatures), numel(chi_values), steps);
  sim = FixedNSimulation([], [], []);

  for t = 1:numel(temperatures)
    for c = 1:numel(chi_values)
      [C, T] = sim.initial_tensors(temperatures(t));
      for n = 1:steps
        [C, T, singular_values, truncation_error, full_singular_values] = ...
          sim.grow_lattice(temperatures(t), chi_values(c), C, T);
        magnetizations(t, c, n) = Magnetization.value_at(temperatures(t), C, T);
      end
    end
  end

  plot(1:steps, squeeze(magnetizations))
  % xlabel()
end
