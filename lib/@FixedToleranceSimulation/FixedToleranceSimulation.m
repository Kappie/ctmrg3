classdef FixedToleranceSimulation < Simulation
  properties
    MAX_ITERATIONS = 1e5;
  end

  methods
    function obj = FixedToleranceSimulation(temperatures, chi_values, tolerances)
      obj = obj@Simulation(temperatures, chi_values);
      obj.tolerances = tolerances;
      obj = obj.after_initialization;
    end
  end
end
