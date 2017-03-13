classdef DataCollapseN < DataCollapse
  properties
    truncation_error = 1e-6;
  end

  methods
    function obj = DataCollapseN(q, N_values, temperatures, truncation_error)
      obj = obj@DataCollapse(q, temperatures);
      obj.N_values = N_values;
      obj.truncation_error = truncation_error;
      obj = obj.post_initialize();
    end
  end
end
