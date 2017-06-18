function corr_lengths = correlation_lengths(obj)
  sim = FixedToleranceSimulation(Constants.T_crit_guess(obj.q), obj.chi_values, 1e-8, obj.q).run();
  % corr_lengths = sim.compute('correlation_length');
  % corr_lengths = exp((6/0.5)*sim.compute('entropy'));
  [~, corr_lengths] = find_corr_lengths_T_star(obj);

end


function [T_pseudocrits, corr_lengths] = find_corr_lengths_T_star(obj)
  TolX = 1e-6;
  tolerance = 1e-8;
  method = 'entropy';
  sim = FindTCritFixedChi(obj.q, TolX, obj.chi_values)
  sim.method = method; sim.tolerance = tolerance;
  sim = sim.run();
  T_pseudocrits = sim.T_pseudocrits;
  corr_lengths = sim.length_scales;
end
