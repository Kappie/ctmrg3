function plot_eigenvalues_transfer_matrix
  width = -0.5;
  temperature = Constants.T_crit + width;
  % temperatures = Util.linspace_around_T_crit(width, 9);
  reduced_temperatures = Constants.reduced_Ts(temperature);
  chi_values = 18:120;
  tolerances = [1e-9];
  number_of_eigenvalues = 4;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerances).run();
  tensors = sim.tensors;
  a = sim.a_tensors(temperature);
  b = Util.construct_b(temperature);

  figure
  hold on

  spectra = zeros(numel(chi_values), number_of_eigenvalues);

  for c = 1:numel(chi_values)
    T = tensors(c).T;
    [eigenvectors, eigenvalues] = Util.largest_eigenvalues_transfer_matrix(a, T, number_of_eigenvalues);
    % transfer_matrix = Util.construct_transfer_matrix(a, T);
    % [eigenvectors, eigenvalues] = eig(transfer_matrix);
    % T_ball = Util.construct_T_ball(b, T);
    % [eigenvectors, eigenvalues] = eig(T_ball);
    % eigenvalues = sort(diag(eigenvalues), 'descend');
    spectra(c, :) = eigenvalues(1:number_of_eigenvalues);
    % markerplot(1:number_to_plot, eigenvalues(1:number_to_plot), '--')
  end

  % [chi_values' last_column]
  markerplot(1:number_of_eigenvalues, spectra, '--')

  % set(gca, 'yscale', 'log')
  hold off
  [chi_values' spectra]
  make_legend(chi_values, '\chi')
  title(['$T = T_c + ' num2str(width) '$'])


  xlabel('$i$');
  ylabel('$T_i$')
  % legend_labels = arrayfun(@(x) ['$\lambda_{' num2str(x) '}$'], 1:number_of_eigvals, 'UniformOutput', false)
  % legend(legend_labels, 'Location', 'best')
  % title('$\chi = 16$, tolerance = $10^{-7}$')
end
