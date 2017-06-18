function obj = set_length_scales(obj)
  obj.length_scales = zeros(numel(obj.q_values), numel(obj.chi_values))

  for q_index = 1:numel(obj.q_values)
    for chi_index = 1:numel(obj.chi_values)
      % temperature doesn't matter?
      lattice = Lattice(obj.q_values(q_index), 1);
      tensors = obj.tensors(q_index, chi_index);
      C = tensors.C;
      T = tensors.T;
      % obj.length_scales(q_index, chi_index) = lattice.ctm_length_scale(C, T);
      % obj.length_scales(q_index, chi_index) = lattice.correlation_length(C, T);
      % obj.length_scales(q_index, chi_index) = calculate_correlation_length(...
      %   Constants.T_crit_guess(obj.q_values(q_index)), obj.chi_values(chi_index), 1e-8, obj.q_values(q_index), ...
      %   'spin-up');
      % obj.length_scales(q_index, chi_index) = obj.chi_values(chi_index);
      % obj.length_scales(q_index, chi_index) = 1./lattice.corner_energy_gap(C, T);
      % 12 = c / 6 for ising model
      obj.length_scales(q_index, chi_index) = 10.^(12.*lattice.entropy(C, T));
  end
end
