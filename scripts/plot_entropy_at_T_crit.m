function plot_entropy_at_T_crit
  q = 2;
  temperature = Constants.T_crit_guess(q);
  chi_values = 8:1:70;
  % chi_values = [22 32 38 46 54 64]
  N_values = 50:50:2500;
  numel(N_values)
  % chi_values = [24, 28, 33, 38, 43, 49, 56, 64, 72];
  tolerance = [1e-9];
  max_truncation_error = 1e-7;
  skip_begin = 0;

  % exclude_chi_values = [28 40 42];
  exclude_chi_values = [];

  chi_values = setdiff(chi_values, exclude_chi_values)


  sim_chi = FixedToleranceSimulation(temperature, chi_values, tolerance, q)
  sim_chi.initial_condition = 'spin-up';
  sim_chi = sim_chi.run();

  entropies = sim_chi.compute('entropy')
  corr_lengths = sim_chi.compute('correlation_length')
  % sim_N = FixedTruncationErrorSimulation(temperature, N_values, max_truncation_error, q).run();
  % entropies = sim_N.compute('entropy');
  % [slope, intercept] = logfit(N_values, entropies, 'logx', 'skipBegin', skip_begin)
  % central_charge = 6 * slope
  % [slope, intercept] = logfit(N_values, sim_N.compute('entropy'), 'logx', 'skipBegin', skip_begin)
  % entropies = sim_chi.compute('entropy');

  [slope, intercept, mse] = logfit(corr_lengths, entropies, 'logx', 'skipBegin', skip_begin)
  % [slope, intercept, mse] = logfit(corr_lengths, entropies, 'logx', 'skipBegin', skip_begin)

  % central charge equals 0.5
  % kappa = slope * (6 / 0.5)
  central_charge = 6 * slope
  % slope
  % intercept
  % correlation_lengths = sim_chi.compute('correlation_length');
  % load('correlation_lengths_chi8-112.mat', 'correlation_lengths')

  % markerplot(correlation_lengths, entropies, '--')
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
  %   skip_begin)
  % [slope, intercept] = logfit(correlation_lengths, entropies, 'logx', 'skipBegin', 20, ...
  %   'skipEnd', 0)

  % ylabel('$S(\chi)$')
  % xlabel('$\xi(\chi)$')
  % title(['Entropy scaling at $T_c$ for the Ising model. Best fit gives $c = ' num2str(central_charge, 6) '$'])
end

function entropy(CTM)
end
