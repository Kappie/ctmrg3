function plot_entropy_at_T_crit
  temperature = Constants.T_crit;
  chi_values = 8:2:112;
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance).run()
  entropies = sim.compute(Entropy);
  load('correlation_lengths_chi8-112.mat', 'correlation_lengths')

  logfit(correlation_lengths, entropies, 'logx')
  % true_value = 0.5/6;
  % best = 10;
  % for skip_begin = 1:20
  %   for skip_end = 1:20
  %     [slope, intercept] = logfit(correlation_lengths, entropies, 'logx', 'skipBegin', skip_begin, 'skipEnd', skip_end);
  %
  %     if abs(true_value - slope) < best
  %       best = abs(true_value - slope);
  %       best_skip_begin = skip_begin;
  %       best_skip_end = skip_end;
  %     end
  %   end
  % end
  %
  % best_skip_end
  % best_skip_begin
  % [slope, intercept] = logfit(correlation_lengths, entropies, 'logx', 'skipBegin', ...
  %   best_skip_begin, 'skipEnd', best_skip_end)
end

function entropy(CTM)
end
