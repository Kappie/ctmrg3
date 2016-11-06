function [C, T, singular_values, truncation_error, full_singular_values] = grow_lattice(temperature, chi, C, T)
  a = Util.construct_a(temperature);
  % Final order is specified so that the new tensor is ordered according to
  % [d, chi, d, chi], with the pairs of d, chi corresponding to what will be the reshaped
  % legs of the new C.
  C = ncon({C, T, T, a}, {[1, 2], [3, 1, -1], [4, 2, -2], [3, -3, -4, 4]}, ...
  [1, 2, 3, 4], [-3 -1 -4 -2]);
  [U, s, U_transpose, truncation_error, full_singular_values] = tensorsvd(C, [1 2], [3 4], chi, 'n');
  % Here, we only take the chi most relevant eigenvectors.
  C = ncon({C, U_transpose, U}, {[1 2 3 4], [1 2 -1], [3 4 -2]});

  % Again, final order is chosen such that we have [d, chi, d, chi, d], i.e.
  % left legs, right legs, middle physical leg.
  T = ncon({T, a}, {[1, -1, -2], [1, -3, -4, -5]}, [1], [-3 -1 -4 -2 -5]);
  % Again, keeping only chi most relevant eigenvectors, and being careful
  % to attach U first, so that U.U_transpose becomes a unity in the relevant
  % subspace when we construct the lattice later.
  T = ncon({T, U, U_transpose}, {[1 2 3 4 -1], [1 2 -2], [3 4 -3]});

  % Scale elements to prevent values from diverging when performing numerous growth steps.
  % Resymmetrize to prevent numerical errors adding up to unsymmetrize tensors.
  C = Util.scale_by_largest_element(C);
  C = Util.symmetrize_C(C);
  T = Util.scale_by_largest_element(T);
  T = Util.symmetrize_T(T);
  singular_values = Util.scale_singular_values(diag(s));
end
