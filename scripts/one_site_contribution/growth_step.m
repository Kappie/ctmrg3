function [C, T, Cm, Tm, singular_values] = growth_step(chi, a, b, C, T, Cm, Tm)
  % grow all tensors
  Cm = grow_Cm(a, b, C, T, Cm, Tm);
  C = corner_contribution(C, T, T, a);
  Tm = grow_Tm(a, b, T, Tm);
  T = edge_contribution(T, a);

  % obtain isometries by performing an svd on C
  [U, s, U_transpose, truncation_error, full_singular_values] = tensorsvd(C, [1 2], [3 4], chi, 'n');
  singular_values = Util.scale_singular_values(diag(s));

  % renormalization step
  C = s;
  Cm = truncate_corner(Cm, U, U_transpose);
  T = truncate_edge(T, U, U_transpose);
  Tm = truncate_edge(Tm, U, U_transpose);

  % scale matrix elements to prevent numbers from becoming huge.
  % It's important to scale with the same scale factor because doing otherwise would
  % result in a final network (which should represent the expectation value) that makes no sense.
  [C, scale_factor] = Util.scale_by_largest_element(C);
  Cm = Cm / scale_factor;
  T = T / scale_factor;
  Tm = Tm / scale_factor;

  % symmetrize
  C = Util.symmetrize_C(C);
  Cm = Util.symmetrize_C(Cm);
  T = Util.symmetrize_T(T);
  Tm = Util.symmetrize_T(Tm);
end
