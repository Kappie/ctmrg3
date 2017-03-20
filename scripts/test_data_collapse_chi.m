function test_data_collapse_chi
  chi_values = [4 10 16 24 32 40 50 60 70];
  % chi_values = [4, 8];
  q = 2;
  tolerance = 1e-7;
  width = 0.1; number_of_points = 10;
  RIGHT_BOUND = Constants.T_crit;
  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    RIGHT_BOUND, number_of_points);
  temperatures_zoom = linspace(Constants.T_crit_guess(q) - width/10, ...
    RIGHT_BOUND, 2*number_of_points);
  temperatures_super_zoom = linspace(Constants.T_crit_guess(q) - width/100, ...
    RIGHT_BOUND, floor(number_of_points));
  temperatures_outer = linspace(Constants.T_crit_guess(q) - 3 * width, Constants.T_crit_guess(q) - width, ...
    2 * number_of_points);
  temperatures = sort(unique([temperatures temperatures_zoom temperatures_super_zoom temperatures_outer]))

  collapse = DataCollapseChi(q, chi_values, temperatures, tolerance);

  collapse.scaling_quantities
  chi_min = 16; fit_width = width/10;
  initial = [Constants.T_crit_guess(q), 0.125, 1, 1.9];
  lower_bounds = [2.269 0.11 0.99 1.8];
  upper_bounds = [2.270 0.13 1.01 2];
  collapse = collapse.find_best_collapse(chi_min, fit_width, initial, lower_bounds, upper_bounds);
  collapse.results
  T_crit = collapse.results.T_crit;
  beta = collapse.results.beta;
  nu = collapse.results.nu;
  kappa = collapse.results.kappa;
  % plot all points
  fit_width = 10; chi_min = 0;
  collapse.plot(chi_min, fit_width, T_crit, beta, nu, kappa)
  xlabel('$t\chi^{\kappa/\nu}$')
  ylabel('$\chi^{\kappa\beta/\nu}m(t, \chi)$')
  title(['$T_c = ' num2str(T_crit) ', \beta = ' num2str(beta) ', \nu = ' num2str(nu) ', \kappa = ' num2str(kappa) '.$'])
  make_legend(chi_values(chi_values >= chi_min), '\chi')

  % collapse.plot(Constants.T_crit_guess(q), 1/8, 1)

end
