function find_T_pseudocrit_chi
  % Simulation parameters
  q = 5;
  % chi_values = [10 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90];
  % chi_values = [20 30 40 50 60 70 80 90];
  % chi_values = 10:10:80;
  % Symmetric values
  % chi_values = [15, 25, 30, 35, 55, 65, 95];
  chi_values = [25];
  % TolX = 1e-6;
  TolX = 1e-5;
  tolerance = 1e-7;
  method = 'entropy';

  sim = FindTCritFixedChi(q, TolX, chi_values);
  sim.method = method;
  sim.tolerance = tolerance;
  sim.initial_condition = 'symmetric';
  % sim.initial_condition = 'spin-up';
  sim.T_crit_range = [0.7 0.92];
  sim = sim.run();

  % Fitting parameters
  TolXFit = 1e-12;
  search_width = 6e-2;
  T_crit_guess = 0.96;
  chi_min = 20;
  chi_max = Inf;
  exclude = chi_values < chi_min | chi_values > chi_max;

  sim.T_pseudocrits

  % [T_crit, error, ~] = fit_kosterlitz_transition2(sim.T_pseudocrits, ...
  %   sim.length_scales, exclude, Constants.T_crit_guess(q), search_width, TolXFit)
  % title('kosterlitz')

  % [T_crit, slope, mse] = fit_power_law3(sim.length_scales, sim.T_pseudocrits, exclude, search_width, TolXFit);
  % title('power law')
end
