classdef FixedNSimulation < Simulation
  properties
    convergences = [];
    truncation_errors = [];
  end
  methods
    function obj = FixedNSimulation(temperatures, chi_values, N_values, q)
      obj = obj@Simulation(temperatures, chi_values, q);
      obj.N_values = N_values;
      obj = obj.after_initialization();
    end
  end
end
