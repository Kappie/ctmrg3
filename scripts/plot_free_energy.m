function plot_free_energy
  temperatures = Util.linspace_around_T_crit(0.1, 9);
  chi_values = [4, 8];
  tolerances = [1e-7];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  free_energies = sim.compute(FreeEnergy);

  exact_free_energies = Constants.free_energy_per_sites(temperatures);
  diffs = free_energies - exact_free_energies;

  % markerplot(temperatures, [free_energies exact_free_energies]);
  markerplot(temperatures, free_energies);
  make_legend(chi_values, '\chi');

end
