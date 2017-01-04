function plot_free_energy
  width = 0.1; number_of_points = 5;
  temperatures = Util.linspace_around_T_crit(width, number_of_points);
  chi_values = [4, 8];
  tolerances = [1e-7];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  sim = sim.run();
  free_energies = sim.compute(FreeEnergy);

  exact_free_energies = Constants.free_energy_per_sites(temperatures);
  diffs = free_energies - exact_free_energies;

  % markerplot(temperatures, [free_energies exact_free_energies]);
  markerplot(temperatures, diffs, '--', 'semilogy');
  make_legend(chi_values, '\chi');

end

function f = free_energy_serina(temperature, a, T)
  largest_eig = Util.largest_eigenvalues_transfer_matrix(a, T, 1);
  f = -temperature * log(largest_eig);
end
