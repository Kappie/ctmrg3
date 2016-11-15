function free_energy_spin_up_symmetric
  chi = 2;
  width = 0.00001; number_of_points = 5;
  temperatures = linspace_around(Constants.T_pseudocrit(chi), width, number_of_points);
  % temperatures = Constants.T_pseudocrit(chi) + 0.1;
  tolerance = 1e-8;

  spin_up_sim = FixedToleranceSimulation(temperatures, chi, tolerance).run();
  symmetric_sim = FixedToleranceSimulation(temperatures, chi, tolerance);
  symmetric_sim.initial_condition = 'symmetric';
  symmetric_sim = symmetric_sim.run();

  free_energies_spin_up = spin_up_sim.compute(FreeEnergy)
  free_energies_symmetric = symmetric_sim.compute(FreeEnergy)


  diffs = free_energies_spin_up - free_energies_symmetric
  subplot(2, 1, 1)
  markerplot(temperatures, sign(diffs), '--')
  vline(Constants.T_pseudocrit(chi), '--')

  subplot(2, 1, 2)
  vline(Constants.T_pseudocrit(chi), '--')
  markerplot(temperatures, sign(diffs) .* -1 .* log10(abs(diffs)), '--');
  hline(0, '--')
end
