function test_data_collapse_chi
  % chi_values = [10, 14, 19, 25, 33, 43, 55];
  chi_values = [8 12 16 20];
  q = 2;
  tolerance = 1e-7;
  width = 0.1; number_of_points = 19;
  RIGHT_BOUND = Constants.T_crit_guess(q);
  chi_min = 0;
  fit_width = width/10;

  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    RIGHT_BOUND, number_of_points);
  temperatures_zoom = linspace(Constants.T_crit_guess(q) - width/10, ...
    RIGHT_BOUND, 3*number_of_points);
  temperatures = sort(unique([temperatures temperatures_zoom]));
  temperatures = temperatures(temperatures ~= Constants.T_crit_guess(q));
  % numel(temperatures)

  % collapse = DataCollapseChiMultipleLengthScales(q, chi_values, temperatures, tolerance);
  collapse = DataCollapseChi(q, chi_values, temperatures, tolerance);
  initial = [2.269, 0.124, 1.01 1.9];

  if q == 2
    % lower_bounds = [2.269 0.1244 0.98];
    % upper_bounds = [2.270 0.1256 1.02];
    lower_bounds = [Constants.T_crit 0.125 1 1.88];
    upper_bounds = [Constants.T_crit 0.125 1 2.1];
  elseif q == 4
    lower_bounds = [1.13 0.11 0.99];
    upper_bounds = [1.14 0.13 1.01];
  end
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
  fit_width = width; chi_min = 0;
  collapse.plot(chi_min, fit_width, Constants.T_crit_guess(q), 0.125, 1);
  title(['Ising model. Exact values for $\beta$, $\nu$ and $T_c$.'])
  make_legend(chi_values, '\chi')
  % collapse.plot(chi_min, fit_width, T_crit, beta, nu);
  % xlabel('$t\xi(\chi)^{1/\nu}$')
  % ylabel('$\xi(\chi)^{\beta/\nu}m(t, \chi)$')
  % xlabel('$t\chi^{\kappa/\nu}$')
  % ylabel('$\chi^{\kappa\beta/\nu}m(t, \chi)$')
  % title(['$T_c = ' num2str(T_crit, 9) ', \beta = ' num2str(beta) ', \nu = ' num2str(nu) '$'])
  % make_legend(chi_values(chi_values >= chi_min), '\chi')
end
