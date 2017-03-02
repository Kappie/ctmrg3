classdef FindTCritFixedN < FindTCrit
  properties
    DATABASE = fullfile(Constants.DB_DIR, 't_pseudocrits_n.db');
    N_values;
    max_truncation_error = 1e-6;
    truncation_errors = [];
    chi_start = 100;
  end

  methods
    function obj = FindTCritFixedN(q, TolX, N_values)
      obj = obj@FindTCrit(q, TolX);
      obj.N_values = N_values;
    end
  end
end
