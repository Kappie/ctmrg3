function [C, T, singular_values, truncation_error, full_singular_values] = grow_lattice(obj, chi, a, C, T)
    [C, T, singular_values, truncation_error, full_singular_values, U, U_transpose] = ...
      Util.grow_lattice(chi, a, C, T);

  % Scale elements to prevent values from diverging when performing numerous growth steps.
  % Resymmetrize to prevent numerical errors adding up to unsymmetrize tensors.
  % C is already normalized
  % [C, largest_element] = Util.scale_by_largest_element(C);
  C = Util.symmetrize_C(C);
  T = Util.scale_by_largest_element(T);
  T = Util.symmetrize_T(T);
end
