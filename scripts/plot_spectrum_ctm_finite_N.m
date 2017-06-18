function plot_spectrum_ctm_finite_N
  q = 2;
  temperatures = [2, Constants.T_crit_guess(q) 2.6];
  % temperatures = Constants.T_crit;
  % temperatures = 0.1;
  % N_values = [200 600 1000 2200];
  N_values = [1000];
  chi = 250;
  % chi = 300;
  initial_condition = 'symmetric';
  sim = FixedNSimulation(temperatures, chi, N_values, q);
  sim.initial_condition = initial_condition;
  sim = sim.run();

  y_scale = 'log';
  x_scale = 'linear';
  eigenvalues_to_plot = 100;

  figure
  hold on
  % for i = 1:numel(N_values)
  for i = 1:numel(temperatures)
    spectrum = diag(sim.tensors(i).C).^4;
    markerplot(1:eigenvalues_to_plot, spectrum(1:eigenvalues_to_plot), '--')
  end
  hold off
  make_legend(temperatures, 'T')

  title(initial_condition)
  set(gca, 'XScale', x_scale)
  set(gca, 'YScale', y_scale)

  xlabel('$i$')
  ylabel('$A_i$')
end
