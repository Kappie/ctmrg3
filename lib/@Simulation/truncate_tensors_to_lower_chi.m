function obj = truncate_tensors_to_lower_chi(obj, chi_lower, extra_steps)
  % assume the tensors are for a single chi value and tolerance for now.
  for t = 1:numel(obj.temperatures)
    C = obj.tensors(t,1,1).C;
    T = obj.tensors(t,1,1).T;
    [truncated_C, truncated_T] = truncate(obj.temperatures(t), C, T, chi_lower, extra_steps);
    obj.tensors(t, 1, 1) = struct('C', truncated_C, 'T', truncated_T);
  end
end

function [truncated_C, truncated_T] = truncate(temperature, C, T, chi, extra_steps)
  sim = FixedNSimulation([], [], []);
  [truncated_C, truncated_T, ~] = sim.calculate_environment(temperature, chi, extra_steps, C, T);
end
