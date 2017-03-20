function test_data_collapse_N
  q = 4;
  truncation_error = 1e-5;
  % N_values = [20 80 160 320 480 600 1000 1500];
  N_values = [20 60 100 120 140 160 180 200];
  width = 0.1; number_of_points = 10;
  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    Constants.T_crit_guess(q) + width, number_of_points);
  temperatures_zoom = linspace(Constants.T_crit_guess(q) - width/10, ...
    Constants.T_crit_guess(q) + width/10, number_of_points);
  temperatures_super_zoom = linspace(Constants.T_crit_guess(q) - width/100, ...
    Constants.T_crit_guess(q) + width/100, number_of_points);
  temperatures_outer = linspace(Constants.T_crit_guess(q) - 3 * width, ...
    Constants.T_crit_guess(q) + 6 * width, 2* number_of_points);


  temperatures = sort(unique([temperatures temperatures_zoom temperatures_super_zoom temperatures_outer]));

  temperatures = sort([temperatures temperatures_zoom temperatures_super_zoom])

  collapse = DataCollapseN(q, N_values, temperatures, truncation_error)
  N_min = 600;
  fit_width = width / 100;

  initial = [Constants.T_crit_guess(q), 0.125, 1];
  lower_bounds = [2.2691 0.12 0.997];
  upper_bounds = [2.2692 0.13 1.006];
  collapse = collapse.find_best_collapse(N_min, fit_width, initial, lower_bounds, upper_bounds);
  % collapse.truncation_errors
  collapse.results
  T_crit = collapse.results.T_crit;
  beta = collapse.results.beta;
  nu = collapse.results.nu;
  collapse.simulation.chi_values;
  % Plot all points
  N_min = 0; fit_width = 10;
  collapse.plot(N_min, fit_width, T_crit, beta, nu)
  xlabel('$tN^{1/\nu}$')
  ylabel('$N^{\beta/\nu}m(t, N)$')
  title(['$T_c = ' num2str(T_crit) ', \beta = ' num2str(beta) ', \nu = ' num2str(nu) '.$'])
  make_legend(N_values(N_values >= N_min), 'N')
end
