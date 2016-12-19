function plot_ctm
  width = -0.000;
  temperatures = Constants.T_crit + width;
  chi_values = [10, 20, 40] ;
  tolerances = [1e-8];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  % sim.LOAD_FROM_DB = false; sim.SAVE_TO_DB = false;
  sim = sim.run();
  tensors = sim.tensors;
  a = sim.a_tensors(temperatures(1));

  figure
  hold on
  MARKERS = markers();
  line_handles = zeros(1, numel(chi_values));
  sizes = zeros(1, numel(chi_values))

  for c = 1:numel(chi_values)
    [C, T, singular_values, truncation_error, full_singular_values] = sim.grow_lattice( ...
      chi_values(c), a, tensors(c).C, tensors(c).T);
    included_singular_values = full_singular_values(1:chi_values(c));
    thrown_away_singular_values = full_singular_values(chi_values(c) + 1:end);
    number_of_eigenvalues = 10;
    line_handles(c) = plot(1:number_of_eigenvalues, included_singular_values(1:number_of_eigenvalues), 'o--');
    % line_handles(c) = plot(1:chi_values(c), included_singular_values, 'o--');

    level_difference = included_singular_values(1) - included_singular_values(2);
    sizes(c) = exp(0.5*pi^2/level_difference);
  end

  sizes

  hold off

  legend_labels = arrayfun(@(value) ['$' '\chi' ' = ' num2str(value) '$'], chi_values, 'UniformOutput', false);
  legend(line_handles, legend_labels)
  set(gca, 'YScale', 'log')
  xlabel('$i$')
  ylabel('$C_i$')
end
