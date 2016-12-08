function [C, T, Cm, Tm] = initial_tensors_converged_environment(temperature, chi, tolerance)
  sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
  C = sim.tensors.C;
  T = sim.tensors.T;
  a = Util.construct_a(temperature);
  b = Util.construct_b(temperature);

  % construct Cm and Tm by inserting one expectation value of a site
  Cm = corner_contribution(C, T, T, b);
  C = corner_contribution(C, T, T, a);
  Tm = edge_contribution(T, b);
  T = edge_contribution(T, a);

  % obtain isometries by performing an svd on C
  % keep exact by taking 2 * chi
  [U, s, U_transpose, truncation_error, full_singular_values] = tensorsvd(C, [1 2], [3 4], 2*chi, 'n');
  singular_values = Util.scale_singular_values(diag(s));

  % renormalization step
  C = s;
  Cm = truncate_corner(Cm, U, U_transpose);
  T = truncate_edge(T, U, U_transpose);
  Tm = truncate_edge(Tm, U, U_transpose);
end
