function correlation_boundary
  width = 0.01;
  temperatures = [Constants.T_crit + width];
  % temperatures = Util.linspace_around_T_crit(width, 5);
  % temperatures = [Constants.T_crit + width/10, Constants.T_crit + width];
  % temperatures = [Constants.T_crit - width, Constants.T_crit, Constants.T_crit + width];
  % temperatures = Constants.inverse_reduced_Ts([0.01]);
  % temperatures = linspace(Constants.T_crit, Constants.T_crit + width, 5);
  % temperatures = temperatures(2:end);
  % chi_values = [4, 8, 12, 16, 24, 32];
  % chi_values = [4 8 12 16 32];
  chi_values = [16 24 32 40 48 64];
  % chi_values = [4, 16]
  tolerance = 1e-8;
  steps = 50;

  magnetizations = zeros(numel(temperatures), numel(chi_values), steps);
  correlation_lengths_fit = zeros(numel(temperatures), numel(chi_values));
  % sim = FixedToleranceSimulation([], [], []);
  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  correlation_lengths = sim.compute(CorrelationLength2);
  % sim.initial_condition = 'symmetric';

  for t = 1:numel(temperatures)
    for c = 1:numel(chi_values)
      sim = FixedToleranceSimulation(temperatures(t), chi_values(c), tolerance).run()
      C = sim.tensors.C;
      T = sim.tensors.T;
      % [C, T] = sim.initial_tensors(temperatures(t));
      for n = 1:steps
        [C, T, singular_values, truncation_error, full_singular_values] = ...
          sim.grow_lattice(temperatures(t), chi_values(c), C, T);
        magnetizations(t, c, n) = Magnetization.value_at(temperatures(t), C, T);
      end

      % fit asymptotic behavior of correlator to obtain correlation length
      % points_used = steps/2;
      % % cancel effects from subtracting value of last step
      % skip_end = 0;
      % magnetizations_diff = magnetizations(t, c, :) - magnetizations(t, c, end);
      % [slope, intercept] = logfit(1:steps, magnetizations(t, c, :), 'logy', 'skipBegin', steps/2)
      [slope, intercept] = logfit(1:steps, magnetizations(t, c, :), 'logy')
      % [slope, intercept] = logfit(1:steps, magnetizations_diff, 'logy', 'skipBegin', steps-points_used-skip_end, 'skipEnd', skip_end);


      correlation_lengths_fit(t, c) = -1/slope;
    end
  end

  % diffs = magnetizations - magnetizations_infinite;
  % magnetizations(:, :, end)
  magnetizations_diff = magnetizations - magnetizations(:, :, end);
  % diffs = Util.relative_error(correlation_lengths, correlation_lengths_fit)
  % correlation_lengths_fit

  subplot(2, 1, 1)
  correlation_lengths
  correlation_lengths_fit
  markerplot(chi_values, [correlation_lengths' squeeze(correlation_lengths_fit)'], '--')
  hline(Constants.correlation_length(temperatures(1)), '--')
  legend({'from transfer matrix', 'from fit to correlator'}, 'Location', 'best')
  % vline(Constants.T_crit, '--', '')
  xlabel('$\chi$');
  ylabel('$\xi$');

  subplot(2, 1, 2)
  semilogy(1:steps, squeeze(magnetizations))
  % semilogy(1:steps, squeeze(magnetizations))
  make_legend(chi_values, '\chi')
  xlabel('$N$')
  ylabel('$\left< s_0 \right>$')
  % ylabel()
  % xlim([0 steps-skip_end])
  % subplot(3, 1, 3)
  % loglog(1:steps, squeeze(magnetizations))



  % semilogy(1:steps, squeeze(diffs))
  % markerplot(1:steps, squeeze(diffs), 'none', 'semilogy')
  % make_legend(Constants.reduced_Ts(temperatures), 't')
  % make_legend(chi_values, '\chi')
  % title('$T = T_c + 0.01$')
end
