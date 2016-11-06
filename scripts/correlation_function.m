function correlation_function
  temperature = Constants.T_crit + 0.5;
  chi = 8;
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
  converged_tensors = sim.tensors;

  grow_lattice_Tb(temperature, chi, converged_tensors.C, converged_tensors.T)
end

% grow lattice function which also returns Tb, a transfer matrix with a b-tensor,
% i.e. a boltzmann weight times spin value at a particular site.
% Requires converged C, T tensors to work properly.
function grow_lattice_Tb(temperature, chi, C, T)
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

  % Now, we construct a T-tensor with an added b-tensor.
  % the b-tensor represents an operator that measures the spin at that site.
  % Again, we choose the order such that [d, chi, d, chi, d], where the final
  % d represents the middle physical leg (is this optimal???)
  T_b = ncon({T, Util.construct_b(temperature)}, {[1 -2 -4], [1 -1 -5 -3]});
  % Keeping chi most relevant eigenvectors
  T_b = ncon({T_b, U, U_transpose}, {[1 2 3 4 -1], [1 2 -2], [3 4 -3]});



  % Scale elements to prevent values from diverging when performing numerous growth steps.
  % Resymmetrize to prevent numerical errors adding up to unsymmetrize tensors.
  % Take care to scale T_b with the same value as T! Otherwise we do not have a valid
  % expectation value later.
  C = scale_by_largest_element(C);
  C = symmetrize_C(C);
  [T, scale_factor] = scale_by_largest_element(T);
  T = symmetrize_T(T);
  T_b = T_b / scale_factor;
  T_b = symmetrize_T(T_b);

  singular_values = scale_singular_values(diag(s));
end
