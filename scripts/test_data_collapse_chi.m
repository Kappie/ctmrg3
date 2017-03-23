function test_data_collapse_chi
  % chi_values = [4 10 16 24 32 40 50 60 70 80];
  chi_values = [90 100 110 120 130 140];
  % chi_values = [32 40 50 60 70 80];
  % chi_values = [16, 40, 70];
  q = 4;
  tolerance = 1e-7;
  width = 0.1; number_of_points = 10;
  % RIGHT_BOUND = 1.13515;
  RIGHT_BOUND = Constants.T_crit_guess(q);
  chi_min = 32;
  fit_width = width/50;

  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    RIGHT_BOUND, number_of_points);
  temperatures_zoom = linspace(Constants.T_crit_guess(q) - width/10, ...
    RIGHT_BOUND, number_of_points);
  temperatures_super_zoom = linspace(Constants.T_crit_guess(q) - width/100, ...
    RIGHT_BOUND, number_of_points);
  % temperatures_super_duper_zoom = linspace(Constants.T_crit_guess(q) - width/1000, ...
  %   RIGHT_BOUND, number_of_points);
  % temperatures_super_duper_zoom = linspace(Constants.T_crit_guess(q) - width/100000, ...
  %   RIGHT_BOUND, number_of_points);
  % temperatures_super_duper_zoom = [];

  temperatures_super_duper_zoom = [];
  temperatures_outer = linspace(Constants.T_crit_guess(q) - 3 * width, Constants.T_crit_guess(q) - width, ...
    number_of_points);
  % temperatures_outer = [];
  temperatures = sort(unique([temperatures temperatures_zoom temperatures_super_zoom ...
  temperatures_super_duper_zoom temperatures_outer]));
  % Throw away T_crit itself; it doesn't help when fitting with a length scale for each data point.
  temperatures = temperatures(temperatures ~= Constants.T_crit_guess(q));

  collapse = DataCollapseChiMultipleLengthScales(q, chi_values, temperatures, tolerance);
  % initial = [Constants.T_crit_guess(q), 0.125, 1, 1.3];
  lower_bounds = [1.1 0.0 0.99];
  upper_bounds = [1.2 0.2 1.01];
  initial = [Constants.T_crit_guess(q), 0.125, 1];
  % lower_bounds = [2.261 0.11 0.99];
  % upper_bounds = [2.27 0.13 1.01];
  collapse = collapse.find_best_collapse(chi_min, fit_width, initial, lower_bounds, upper_bounds);

  collapse.results
  T_crit = collapse.results.T_crit;
  beta = collapse.results.beta;
  nu = collapse.results.nu;
  % kappa = collapse.results.kappa;
  % plot all points
  % fit_width = 10; chi_min = 0;
  collapse.plot(chi_min, fit_width, T_crit, beta, nu);
  xlabel('$t\xi(\chi)^{1/\nu}$')
  ylabel('$\xi(\chi)^{\beta/\nu}m(t, \chi)$')
  % xlabel('$t\chi^{\kappa/\nu}$')
  % ylabel('$\chi^{\kappa\beta/\nu}m(t, \chi)$')
  title(['$T_c = ' num2str(T_crit, 9) ', \beta = ' num2str(beta) ', \nu = ' num2str(nu) '$'])
  make_legend(chi_values(chi_values >= chi_min), '\chi')

  % plot all points
  % fit_width = 10; chi_min = 0;
  collapse.plot(chi_min, fit_width, Constants.T_crit_guess(q), 0.125, 1);
  % collapse.plot(chi_min, fit_width, T_crit, beta, nu);
  xlabel('$t\xi(\chi)^{1/\nu}$')
  ylabel('$\xi(\chi)^{\beta/\nu}m(t, \chi)$')
  % xlabel('$t\chi^{\kappa/\nu}$')
  % ylabel('$\chi^{\kappa\beta/\nu}m(t, \chi)$')
  % title(['$T_c = ' num2str(T_crit, 9) ', \beta = ' num2str(beta) ', \nu = ' num2str(nu) '$'])
  title(['Ising model. Exact values for $\beta$, $\nu$ and $T_c$.'])
  make_legend(chi_values(chi_values >= chi_min), '\chi')
end
