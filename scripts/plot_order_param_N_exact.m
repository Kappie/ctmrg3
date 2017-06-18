function plot_order_param_N_exact
  q = 2;
  width_left = 1;
  width_right = 1;
  number_of_points = 21;
  temperatures = linspace(Constants.T_crit_guess(q) - width_left, Constants.T_crit_guess(q) + width_right, ...
    number_of_points);
  chi = 2 ^ 24;
  N_values = [8 16 24];

  sim = FixedNSimulation(temperatures, chi, N_values, q);
  sim.initial_condition = 'spin-up';
  sim.SAVE_TO_DB = false;
  sim = sim.run();


  order_params = sim.compute('order_parameter');
  [temperatures_exact, exact_values] = order_param_exact_values(Constants.T_crit_guess(q) - width_left, ...
    Constants.T_crit_guess(q) + width_right);

  figure
  hold on
  markerplot(temperatures, order_params, '--')
  plot(temperatures_exact, exact_values, 'Color', 'black')
  vline(Constants.T_crit_guess(q), '--')
  make_legend(N_values, 'N')
  xlabel('$T$')
  ylabel('$M(T, N)$')
  title('Order parameter of the 2D Ising model')

end

function [temperatures, order_parameters] = order_param_exact_values(T_min, T_max)
  temperatures = linspace(T_min, T_max, 101);
  order_parameters = arrayfun(@(T) Constants.order_parameter(T), temperatures);
end
