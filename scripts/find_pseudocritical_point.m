function find_pseudocritical_point
  % chi_values = [2, 4, 6, 8, 10, 12, 14, 16, 24, 32];
  chi_values = [2];
  tolerance = 1e-7;
  TolX = 1e-5;
  initial_conditions = {'spin-up', 'symmetric'};
  t_width = 0.5;


  t_stars = zeros(numel(initial_conditions), numel(chi_values));
  corr_lengths = zeros(numel(initial_conditions), numel(chi_values));
  negative_xi = @(temperature, chi, tolerance, initial) -1 * calculate_correlation_length(temperature, chi, tolerance, initial);
  options = optimset('Display', 'iter', 'TolX', TolX);

  for c = 1:numel(chi_values)
    for i = 1:numel(initial_conditions)
      optim_func = @(temperature) negative_xi(temperature, chi_values(c), tolerance, initial_conditions{i});
      [t_star, corr_length] = fminbnd(optim_func, ...
        Constants.T_crit - t_width, Constants.T_crit + t_width, options);

      t_stars(i, c) = t_star;
      corr_lengths(i, c) = corr_length;
      save('t_stars_chi2_tol1e-7_TolX1e-5_corr2_spin-up_symmetric.mat', 'chi_values', 'initial_conditions', 't_stars', 'corr_lengths')
    end
  end


end

function xi = calculate_correlation_length(temperature, chi, tolerance, initial)
  if temperature < 0
    xi = 0;
  elseif temperature > 20
    error('hou maar op')
  else
    sim = FixedToleranceSimulation(temperature, chi, tolerance);
    sim.initial_condition = initial;
    sim = sim.run();
    xi = sim.compute(CorrelationLength2);
  end
end

function filename = filename(chi)
  filename = ['t_stars_chi' num2str(chi) '_tol1e-8_TolX1e-5.mat']
end
