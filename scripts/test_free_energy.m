function test_free_energy
  q = 2;
  chi = 20;
  width = 0.1;
  temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, 10);
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi, tolerance, q).run();
  free_energies = sim.compute('free_energy');

  diffs = free_energies - Constants.free_energy_per_sites(temperatures)
  markerplot(temperatures, diffs, '--', 'semilogy')


end
