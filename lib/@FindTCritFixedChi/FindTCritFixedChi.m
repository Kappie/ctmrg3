classdef FindTCritFixedChi < FindTCrit
  properties
    DATABASE = fullfile(Constants.DB_DIR, 't_pseudocrits.db');
    chi_values;
    tolerance = 1e-7;
    length_scales = [];
    method = 'entropy';
  end

  methods
    function obj = FindTCritFixedChi(q, TolX, chi_values)
      obj = obj@FindTCrit(q, TolX);
      obj.chi_values = chi_values;
    end
  end
end
