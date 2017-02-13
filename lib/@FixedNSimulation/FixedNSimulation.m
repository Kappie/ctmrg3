classdef FixedNSimulation < Simulation
  properties
    convergences = [];
  end
  methods
    function obj = FixedNSimulation(temperatures, chi_values, N_values)
      obj = obj@Simulation(temperatures, chi_values);
      obj.N_values = N_values;
      obj = obj.after_initialization();
    end
  end
end
