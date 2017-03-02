function value = truncation_error(obj, C, T)
  chi = size(C, 1);
  sim = FixedNSimulation([1], [1], [1], 2);
  [~, ~, ~, truncation_error, ~] = sim.grow_lattice(chi, obj.construct_a(), C, T);
  value = truncation_error;
end
