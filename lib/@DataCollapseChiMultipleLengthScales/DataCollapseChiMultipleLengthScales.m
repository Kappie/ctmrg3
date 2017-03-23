classdef DataCollapseChiMultipleLengthScales < DataCollapse
  properties
    chi_values;
    tolerance = 1e-7;
  end

  methods
    function obj = DataCollapseChiMultipleLengthScales(q, chi_values, temperatures, tolerance)
      obj = obj@DataCollapse(q, temperatures);
      obj.chi_values = chi_values;
      obj.tolerance = tolerance;
      obj = obj.post_initialize();
      % obj.N_values = obj.simulation.compute('correlation_length');
      obj.N_values = repmat(obj.correlation_lengths(), numel(temperatures), 1);
      % obj.N_values
    end
  end
end
