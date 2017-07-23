classdef FixedToleranceSimulation < Simulation
  properties
    MAX_ITERATIONS = 1e7;
    stop_if_desymmetrizes = false;
    number_of_iterations_to_check_desymmetrization = 100;
    number_of_iterations_before_checking = 0;
  end

  methods
    function obj = FixedToleranceSimulation(temperatures, chi_values, tolerances, q)
      obj = obj@Simulation(temperatures, chi_values, q);
      obj.tolerances = tolerances;
      obj = obj.after_initialization;
    end
  end
end
