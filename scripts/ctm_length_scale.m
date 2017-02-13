function length_scale = ctm_length_scale(temperature, chi, tolerance)
  sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
  eigenvalues = diag(sim.tensors.C);
  length_scale = exp(1/log(eigenvalues(1)/eigenvalues(2)))^(pi^2/2);
end
