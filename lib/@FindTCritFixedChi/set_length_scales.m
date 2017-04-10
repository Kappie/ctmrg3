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
      obj.length_scales(q_index, chi_index) = 1./lattice.corner_energy_gap(C, T);
      % obj.length_scales(q_index, chi_index) = -log(lattice.entropy(C, T));
      % obj.length_scales(q_index, chi_index) = lattice.entropy(C, T);
  end
end
