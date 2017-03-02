function value = truncation_error(obj, C, T)
  chi = size(C, 1);
  sim = FixedNSimulation([1], [1], [1], 2);
  [C, T, singular_values, truncation_error, full_singular_values] = sim.grow_lattice(chi, obj.construct_a(), C, T);
  value = struct('truncation_error', truncation_error, 'full_singular_values', full_singular_values);
end
