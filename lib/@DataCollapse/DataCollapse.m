classdef (Abstract) DataCollapse
  properties
    q;
    temperatures;
    scaling_quantities;
    N_values;

    simulation;
    initial_T_crit;
    initial_beta = 0.125;
    initial_nu = 1;
    results;
  end

  methods
    function obj = DataCollapse(q, temperatures)
      obj.q = q;
      obj.temperatures = temperatures;
      obj.initial_T_crit = Constants.T_crit_guess(obj.q);
    end

    function obj = post_initialize(obj)
      obj = obj.calculate_scaling_quantities();
    end
  end
end
