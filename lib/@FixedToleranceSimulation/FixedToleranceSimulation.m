classdef FixedToleranceSimulation < Simulation
  properties
    MAX_ITERATIONS = 1e7;
  end

  methods
    function obj = FixedToleranceSimulation(temperatures, chi_values, tolerances, q)
      obj = obj@Simulation(temperatures, chi_values, q);
      obj.tolerances = tolerances;
      obj = obj.after_initialization;
    end
  end
end
