function plot_singular_values
  width = 0.0001;
  % temperatures = [Constants.T_crit + width, Constants.T_crit + width/10, Constants.T_crit + width/100];
  % temperatures = [Constants.T_crit - width, Constants.T_crit - width/10, Constants.T_crit + width, Constants.T_crit + width/10];
  % temperatures = Constants.T_crit - width;
  temperatures = Constants.inverse_reduced_Ts(0.00);
  chi_values = [10 12];
  tolerance = 1e-8;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  tensors = sim.tensors;
  singular_values = zeros(numel(chi_values), max(chi_values));

  for t = 1:numel(temperatures)
    for c = 1:numel(chi_values)
      [~, ~, singular_values_chi, ~, ~] = sim.grow_lattice(temperatures(t), ...
        chi_values(c), tensors(t, c).C, tensors(t, c).T);
        % plot(1:chi_values(c), singular_values, 'marker', MARKERS(c), 'LineStyle', '--')
      singular_values(c, 1:chi_values(c)) = singular_values_chi;
    end
  end

  [groups, step_numbers] = partition(singular_values(1,:))


  subplot(2, 1, 1)
  markerplot(1:max(chi_values), singular_values, 'none', 'semilogy')
  % make_legend(Constants.reduced_Ts(temperatures), 't')
  make_legend(chi_values, '\chi')
  xlabel('$i$')
  ylabel('$C_i$')

  subplot(2, 1, 2)
  diffs = singular_values(1, 1:min(chi_values)) - singular_values(2, 1:min(chi_values));
  % Is normalization sum(s) = 1 OK?
  sum(singular_values(1,:).^2)
  sum(singular_values(2,:).^2)
  markerplot(1:min(chi_values), diffs, 'none')
  hline(0,'-')
  xlabel('$i$')
  ylabel('$C_i^{10} - C_i^{12}$')
end

function [groups, step_numbers] = partition(singular_values)
  relative_differences = zeros(1, numel(singular_values));
  % if relative difference goes above this number, start a new group.
  % The value of a new 'step' in the staircase of singular values
  % seems to start with a relative error of ~0.66 each time.
  threshold = 0.1;

  step_numbers = [];
  groups = {};
  current_group = [];
  s_old = singular_values(1);

  for i = 1:numel(singular_values)
    s = singular_values(i);
    % I throw away the sign of the relative difference, but it should
    % be always negative, so it just makes comparison easier.
    relative_differences(i) = abs( (s - s_old) / s_old );
    s_old = s;
    if relative_differences(i) < threshold
      current_group(end + 1) = s;
    else
      if isempty(step_numbers)
        step_numbers(1) = size(current_group, 2);
      else
        step_numbers(end + 1) = step_numbers(end) + size(current_group, 2);
      end

      groups{end + 1} = current_group;
      current_group = [s];
    end
  end

  % markerplot(1:numel(relative_differences), relative_differences, 'semilogy')
end
