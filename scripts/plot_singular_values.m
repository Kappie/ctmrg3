function plot_singular_values
  width = 0.0001;
  % temperatures = [Constants.T_crit + width, Constants.T_crit + width/10, Constants.T_crit + width/100];
  temperatures = [Constants.T_crit - width, Constants.T_crit - width/10, Constants.T_crit + width, Constants.T_crit + width/10];
  % temperatures = Constants.T_crit - width;
  chi = 120;
  tolerance = 1e-8;

  sim = FixedToleranceSimulation(temperatures, chi, tolerance).run();
  tensors = sim.tensors;
  singular_values = zeros(numel(temperatures), chi);
  for t = 1:numel(temperatures)
    [~, ~, singular_values_t, ~, ~] = sim.grow_lattice(temperatures(t), ...
      chi, tensors(t).C, tensors(t).T);
    singular_values(t, :) = singular_values_t;
  end

  [groups, step_numbers] = partition(singular_values(1,:))

  markerplot(1:chi, singular_values, 'none', 'semilogy')
  make_legend(Constants.reduced_Ts(temperatures), 't')
  xlabel('$i$')
  ylabel('$C_i$')
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
