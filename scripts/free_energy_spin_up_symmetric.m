function free_energy_spin_up_symmetric
  offset = 1e-2;
  width = 1e-10;
  number_of_points = 5;
  temperatures = linspace(Constants.T_crit + offset - width, Constants.T_crit + offset + width, number_of_points);
  % temperatures = Constants.T_crit + offset;
  chi_values = 22:24;
  tolerance = 1e-7;

  spin_up_sim = sim_with_boundary(temperatures, chi_values, tolerance, 'spin-up');
  symmetric_sim = sim_with_boundary(temperatures, chi_values, tolerance, 'symmetric');

  free_energy_spin_up = spin_up_sim.compute(FreeEnergy);
  free_energy_symmetric = symmetric_sim.compute(FreeEnergy);

  order_params_spin_up = spin_up_sim.compute(OrderParameter);
  order_params_symmetric = symmetric_sim.compute(OrderParameter);

  rel_diffs = Util.relative_error(free_energy_symmetric, free_energy_spin_up)
  Util.relative_error(order_params_symmetric, order_params_spin_up)
  markerplot(chi_values, rel_diffs, '--')





end

function sim = sim_with_boundary(temperatures, chi_values, tolerance, initial_condition)
  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance);
  sim.initial_condition = initial_condition;
  sim.SAVE_TO_DB = false; sim.LOAD_FROM_DB = false;
  sim = sim.run();
end
