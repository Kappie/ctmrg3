function plot_free_energy
  temperatures = Util.linspace_around_T_crit(1, 9);
  chi_values = [4, 8];
  tolerances = [1e-7];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  sim.LOAD_FROM_DB = false; sim.SAVE_TO_DB = false;
  sim = sim.run();
  free_energies = sim.compute(FreeEnergy);

  exact_free_energies = Constants.free_energy_per_sites(temperatures);
  diffs = free_energies - exact_free_energies;

  % markerplot(temperatures, [free_energies exact_free_energies]);
  markerplot(temperatures, diffs, '--', 'semilogy');
  make_legend(chi_values, '\chi');

end
