function T = symmetric_initial_T(obj)
  delta = obj.edge_delta();
  P = obj.construct_P();
  T = ncon({P, P, P, delta}, {[-1, 1], [-2, 2], [-3, 3], [1, 2, 3]});
end
