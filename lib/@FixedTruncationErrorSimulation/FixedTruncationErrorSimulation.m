classdef FixedTruncationErrorSimulation < Simulation
  properties
    max_truncation_error;
    truncation_errors;
    chi_start = 20;
    chi;
  end

  methods
    function obj = FixedTruncationErrorSimulation(temperatures, N_values, max_truncation_error, q)
      obj = obj@Simulation(temperatures, [], q);
      obj.N_values = N_values;
      obj.max_truncation_error = max_truncation_error;
    end
  end
end
