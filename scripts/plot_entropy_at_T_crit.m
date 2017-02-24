function plot_entropy_at_T_crit
  q = 2;
  temperature = Constants.T_crit_guess(q);
  chi_values = 8:2:112;
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance, q).run();
  entropies = sim.compute('entropy');
  load('correlation_lengths_chi8-112.mat', 'correlation_lengths')

  markerplot(correlation_lengths, entropies, '--')
  true_value = 0.5/6;
  best = 10;
  for skip_begin = 1:20
    for skip_end = 1:20
      [slope, intercept] = logfit(correlation_lengths, entropies, 'logx', 'skipBegin', skip_begin, 'skipEnd', skip_end);

      if abs(true_value - slope) < best
        best = abs(true_value - slope);
        best_skip_begin = skip_begin;
        best_skip_end = skip_end;
      end
    end
  end

  best_skip_end
  best_skip_begin
  [slope, intercept] = logfit(correlation_lengths, entropies, 'logx', 'skipBegin', ...
    best_skip_begin, 'skipEnd', best_skip_end)
  % [slope, intercept] = logfit(correlation_lengths, entropies, 'logx', 'skipBegin', 20, ...
  %   'skipEnd', 0)
  central_charge = 6 * slope;
  ylabel('$S(\chi)$')
  xlabel('$\xi(\chi)$')
  title(['Entropy scaling at $T_c$ for the Ising model. Best fit gives $c = ' num2str(central_charge, 6) '$'])
end

function entropy(CTM)
end
