function truncate_from_higher_chi
  width = 0.005;
  number_of_points = 19;
  temperatures = Util.linspace_around_T_crit(width, number_of_points);
  % temperatures = [Constants.T_crit];
  chi_max = 48;
  chi_lower = 8;
  extra_steps = 1000;
  tolerance = 1e-7;

  %%% calculate m from truncated tensors.
  sim_chi_max = FixedToleranceSimulation(temperatures, [chi_max], [tolerance]).run();
  order_params_chi_max = sim_chi_max.compute(OrderParameter);

  sim_truncated = sim_chi_max.truncate_tensors_to_lower_chi(chi_lower, 1);
  order_params_truncated = sim_truncated.compute(OrderParameter);
  free_energy_truncated = sim_truncated.compute(FreeEnergy);

  sim_truncated_plus_extra_steps = sim_chi_max.truncate_tensors_to_lower_chi(chi_lower, extra_steps);
  order_params_truncated_plus_extra_steps = sim_truncated_plus_extra_steps.compute(OrderParameter);
  free_energy_truncated_plus_extra_steps = sim_truncated_plus_extra_steps.compute(FreeEnergy);


  %%% calculate m from regularly converged tensors
  sim = FixedToleranceSimulation(temperatures, [chi_lower], [tolerance]).run();
  order_params = sim.compute(OrderParameter);
  free_energy = sim.compute(FreeEnergy);

  subplot(2, 1, 1)
  order_params_truncated
  order_params_chi_max
  order_params_truncated - order_params_chi_max
  markerplot(temperatures, [order_params order_params_truncated_plus_extra_steps order_params_chi_max])
  % markerplot(temperatures, order_params_truncated - order_params_chi_max)
  vline(Constants.T_crit, '--')
  title(['$\chi = ' num2str(chi_lower) '$'])
  legend({'regularly converged',  ...
    ['truncated from $\chi = ' num2str(chi_max) '$ + ' num2str(extra_steps) ' steps'], ['$\chi = ' num2str(chi_max) '$']}, 'Location', 'best')
  xlabel('$T$')
  ylabel('$m$')

  subplot(2, 1, 2)
  markerplot(temperatures, abs(free_energy - free_energy_truncated_plus_extra_steps), 'semilogy')
  free_energy - free_energy_truncated_plus_extra_steps

  vline(Constants.T_crit, '--')
  % legend({'regularly converged', ['truncated from $\chi = ' num2str(chi_max) '$']}, ...
  %   'Location', 'best')
  xlabel('$T$')
  ylabel('$|f_{\mathrm{regular}} - f_{\mathrm{truncated}}|$')

end
