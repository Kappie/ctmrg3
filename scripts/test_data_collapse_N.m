function test_data_collapse_N
  q = 2;
  truncation_error = 1e-6;
  N_values = [160 480 1000 1500];
  % N_values = [20 60 100 120 140 160 180 200];
  % N_values = [160 600 1000];
  width = 0.1; number_of_points = 19;
  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    Constants.T_crit_guess(q), number_of_points);
  temperatures_zoom = linspace(Constants.T_crit_guess(q) - width/10, ...
    Constants.T_crit_guess(q), 3*number_of_points);
  % temperatures_super_zoom = linspace(Constants.T_crit_guess(q) - width/100, ...
  %   Constants.T_crit_guess(q) + width/100, number_of_points);
  % temperatures_super_duper_zoom = linspace(Constants.T_crit_guess(q) - width/100000, ...
  %   Constants.T_crit_guess(q) + width/100000, number_of_points);
  temperatures_super_duper_zoom = [];

  temperatures_outer = linspace(Constants.T_crit_guess(q) - 3 * width, ...
    Constants.T_crit_guess(q), 2*number_of_points);

  temperatures = sort(unique([temperatures temperatures_zoom ...
    temperatures_outer]));
  % Throw away T_crit itself; it doesn't help when fitting with a length scale for each data point.
  temperatures = temperatures(temperatures ~= Constants.T_crit_guess(q));

  collapse = DataCollapseN(q, N_values, temperatures, truncation_error)
  N_min = 0;
  fit_width = width/10;

  initial = [Constants.T_crit_guess(q), 0.125, 1];
  if q == 2
    lower_bounds = initial;
    upper_bounds = initial;
  elseif q == 4
    lower_bounds = [1.134 0.12 0.997];
    upper_bounds = [1.135 0.13 1.006];
  end
  collapse = collapse.find_best_collapse(N_min, fit_width, initial, lower_bounds, upper_bounds);
  % collapse.truncation_errors
  collapse.results
  T_crit = collapse.results.T_crit;
  beta = collapse.results.beta;
  nu = collapse.results.nu;
  collapse.simulation.chi_values;
  % Plot all points
  % N_min = 0; fit_width = 10;
  % collapse.plot(N_min, fit_width, Constants.T_crit, 0.125, 1)
  collapse.plot(N_min, fit_width, T_crit, beta, nu)
  xlabel('$tN^{1/\nu}$')
  ylabel('$N^{\beta/\nu}m(t, N)$')
  title(['$T_c = ' num2str(T_crit, 7) ', \beta = ' num2str(beta) ', \nu = ' num2str(nu) '.$'])
  % title(['Ising model. Exact values for $T_c$, $\beta$, and $\nu$'])
  make_legend(N_values(N_values >= N_min), 'N')

  % N_min = 0; fit_width = 10;
  collapse.plot(N_min, fit_width, T_crit, beta, nu)
  xlabel('$tN^{1/\nu}$')
  ylabel('$N^{\beta/\nu}m(t, N)$')
  title(['Exact values.'])
  make_legend(N_values(N_values >= N_min), 'N')
end
