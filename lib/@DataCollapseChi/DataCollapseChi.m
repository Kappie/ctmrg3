classdef DataCollapseChi < DataCollapse
  properties
    chi_values;
    tolerance = 1e-7;
    initial_kappa = 1.9;
  end

  methods
    function obj = DataCollapseChi(q, chi_values, temperatures, tolerance)
      obj = obj@DataCollapse(q, temperatures);
      obj.chi_values = chi_values;
      obj.tolerance = tolerance;
      obj = obj.post_initialize();
    end
  end
end
