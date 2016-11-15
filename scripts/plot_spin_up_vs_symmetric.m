function plot_spin_up_vs_symmetric
  chi = 4;
  temperature = Constants.T_pseudocrit(chi);
  N = 100000;

  measurements = 100;
  step_size = N / measurements;

  spin_up_sim = FixedNSimulation([], [], []);
  spin_up_sim.LOAD_FROM_DB = false; spin_up_sim.SAVE_TO_DB = false;
  symmetric_sim = FixedNSimulation([], [], []);
  symmetric_sim.initial_condition = 'symmetric';
  symmetric_sim.LOAD_FROM_DB = false; symmetric_sim.SAVE_TO_DB = false;

  [order_params_spin_up, free_energies_spin_up] = calculate_at_every_nth_step(spin_up_sim, temperature, chi, N, step_size);
  [order_params_symmetric, free_energies_symmetric] = calculate_at_every_nth_step(symmetric_sim, temperature, chi, N, step_size);

  order_params_spin_up - order_params_symmetric
  subplot(2, 1, 1)
  markerplot(1:step_size:N, sign(order_params_spin_up - order_params_symmetric), 'none')
  xlabel('$N$')
  ylabel('$\Delta m$')

  free_energies_spin_up - free_energies_symmetric
  subplot(2, 1, 2)
  markerplot(1:step_size:N, sign(free_energies_spin_up - free_energies_symmetric), 'none');
  xlabel('$N$')
  ylabel('$\Delta f$')
end

function [order_params, free_energies] = calculate_at_every_nth_step(sim, temperature, chi, steps, step_size)
  order_params = zeros(1, steps);
  free_energies = zeros(1, steps);

  [C, T] = sim.initial_tensors(temperature);
  sim.temperatures = temperature;
  sim = sim.calculate_a_tensors;

  for n = 1:step_size:steps
    [C, T] = sim.calculate_environment(temperature, chi, step_size, C, T);
    order_params(n) = OrderParameter.value_at(temperature, C, T);
    free_energies(n) = FreeEnergy.value_at(temperature, C, T);
  end

  order_params = nonzeros(order_params);
  free_energies = nonzeros(free_energies);
end
