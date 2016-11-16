function plot_eigenvalues_transfer_matrix
  width = 1;
  temperatures = Constants.T_crit + width;
  % temperatures = Util.linspace_around_T_crit(width, 9);
  reduced_temperatures = Constants.reduced_Ts(temperatures);
  chi_values = 6:1:38;
  tolerances = [1e-7];
  number_of_eigenvalues = 6;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  tensors = sim.tensors;

  figure
  hold on

  spectra = zeros(numel(chi_values), number_of_eigenvalues);

  for c = 1:numel(chi_values)
    T = tensors(c).T;
    transfer_matrix = Util.construct_transfer_matrix2(T);
    [eigenvectors, eigenvalues] = eig(transfer_matrix);
    eigenvalues = sort(diag(eigenvalues), 'descend');
    spectra(c, :) = eigenvalues(1:number_of_eigenvalues);
    % markerplot(1:number_to_plot, eigenvalues(1:number_to_plot), '--')
  end

  last_column = 100 .* mod(100.* round(spectra(:, 1), 8), 202)
  [chi_values' last_column]

  % set(gca, 'yscale', 'log')
  hold off
  make_legend(chi_values, '\chi')
  title(['$T = T_c + ' num2str(width) '$'])


  xlabel('$i$');
  ylabel('$T_i$')
  % legend_labels = arrayfun(@(x) ['$\lambda_{' num2str(x) '}$'], 1:number_of_eigvals, 'UniformOutput', false)
  % legend(legend_labels, 'Location', 'best')
  % title('$\chi = 16$, tolerance = $10^{-7}$')
end
