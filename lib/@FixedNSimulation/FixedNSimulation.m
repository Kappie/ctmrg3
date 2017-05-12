classdef FixedNSimulation < Simulation
  properties
    MIN_CONVERGENCE = 1e-11;
    % check every STEP_SIZE steps if MIN_CONVERGENCE is reached.
    STEP_SIZE = 20;
    convergences = [];
  end
  methods
    function obj = FixedNSimulation(temperatures, chi_values, N_values, q)
      obj = obj@Simulation(temperatures, chi_values, q);
      obj.N_values = N_values;
      obj = obj.after_initialization();
    end
  end
end
