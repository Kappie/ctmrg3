classdef DataCollapseN
  properties
    q;
    N_values;
    temperatures;
    chi_max = 100;
    scaling_quantities;
    initial_T_crit = Constants.T_crit;
    initial_beta = 1/8;
    initial_nu = 1;
    results;
  end

  methods
    function obj = DataCollapseN(q, N_values, temperatures)
      obj.q = q;
      obj.N_values = N_values;
      obj.temperatures = temperatures;
      obj = obj.calculate_scaling_quantities();
    end
  end
end
