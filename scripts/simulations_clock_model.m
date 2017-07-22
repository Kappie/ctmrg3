function simulations_clock_model
  q = 6;
  number_of_points = 10;
  % number_of_points = 5;
  % left_bound_T1 = 0.9; right_bound_T1 = 0.92;
  % left_bound_T2 = 0.93; right_bound_T2 = 0.95;
  % left_bound_T1 = 0.89; right_bound_T1 = 0.90;
  % left_bound_T2 = 0.95; right_bound_T2 = 0.96;
  left_bound_T1 = 0.69; right_bound_T1 = 0.71;
  left_bound_T2 = 0.88; right_bound_T2 = 0.92;
  temperatures_zoom_T1 = linspace(left_bound_T1, right_bound_T1, number_of_points);
  temperatures_zoom_T2 = linspace(left_bound_T2, right_bound_T2, number_of_points);
  temperatures = [temperatures_zoom_T1 temperatures_zoom_T2];
  % number_of_points = 25; left_bound = 0.80; right_bound = 1.05;
  % number_of_points = 50; left_bound = 0.6; right_bound = 1.1;

  % temperatures = linspace(left_bound, right_bound, number_of_points);
  % chi_values = 10:10:120;
  % chi_values = 10:10:100;
  chi_values = 10:10:80;
  % tolerances = [8e-7 4e-7 2e-7 1e-7 5e-8 2.5e-8 1.25e-8];
  % tolerances = [8e-7 4e-7 2e-7 1e-7 5e-8 2.5e-8];
  % tolerances = [8e-7 4e-7 2e-7 1e-7 5e-8];
  tolerances = [8e-7 4e-7 2e-7 1e-7];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances, q).run();
  save('q6_chi10-80_tol1e-7_zoom.mat', 'sim')
  % order_params = sim.compute('order_parameter');
  % entropies = sim.compute('entropy');
  % corr_lengths = sim.compute('correlation_length')
  % corr_lengths_via_entropy = 10.^((6/1) .* entropies);
  % eigenvalues = spectrum(sim.tensors(end));

  % figure
  % markerplot(temperature, order_params, '--')
  % title('order param')
  % figure
  % markerplot(temperature, entropies, '--')
  % title('entropy')
  % make_legend(chi_values, '\chi')
  % markerplot(tolerance, corr_lengths, '--', 'semilogx')
  % figure
  % [slope, intercept, mse] = logfit(corr_lengths_via_entropy, order_params, 'loglog', 'skipBegin', 0)
  % title('via entropy')
  % figure
  % [slope, intercept, mse] = logfit(corr_lengths, order_params, 'loglog', 'skipBegin', 0)
  % title('via transfer matrix')
  % [slope, intercept, mse] = logfit(corr_lengths, entropies, 'logx', 'skipBegin', 0)
  % 6 * slope
  % eigenvalues_to_plot = 133;
  % markerplot(1:eigenvalues_to_plot, eigenvalues(1:eigenvalues_to_plot), '--', 'semilogy')




end

function eigenvalues = spectrum(tensor_struct)
  C = tensor_struct.C;
  eigenvalues = diag(C);
end
