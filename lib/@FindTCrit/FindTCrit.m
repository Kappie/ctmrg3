classdef (Abstract) FindTCrit
  properties
    db_id;
    LOAD_FROM_DB = true;
    SAVE_TO_DB = true;
    q_values;
    TolX;
    initial_condition = 'spin-up'
    significant_digits = 13;
    T_crit_bounds = containers.Map({2, 4, 6}, {[2.0 2.5], [1.0 1.3], [0.8 1.3]});
    tensors = struct('C', {}, 'T', {});
    T_pseudocrits = [];
  end

  methods
    function obj = FindTCrit(q_values, TolX)
      obj.q_values = q_values;
      obj.TolX = TolX;
    end
  end
end
