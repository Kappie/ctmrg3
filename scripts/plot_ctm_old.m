function plot_ctm
  width = +0.001;
  temperatures = 3.2;
  chi_values = [150];
  % chi_values = [10, 20, 40];
  tolerances = [1e-7];
  q = 4;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances, q).run;
  tensors = sim.tensors;
  line_handles = zeros(1, numel(chi_values));
  sizes = zeros(1, numel(chi_values));

  for c = 1:numel(chi_values)
    [C, T, singular_values, truncation_error, full_singular_values] = sim.grow_lattice( ...
      chi_values(c), a, tensors(c).C, tensors(c).T);
    number_of_eigenvalues = min(chi_values);
    spectrum = diag(C);
    line_handles(c) = plot(1:number_of_eigenvalues, spectrum(1:number_of_eigenvalues), 'o--');
    % line_handles(c) = plot(1:chi_values(c), included_singular_values, 'o--');
  end

  hold off

  legend_labels = arrayfun(@(value) ['$' '\chi' ' = ' num2str(value) '$'], chi_values, 'UniformOutput', false);
  legend(line_handles, legend_labels)
  set(gca, 'YScale', 'log')
  xlabel('$i$')
  ylabel('$C_i$')
end
