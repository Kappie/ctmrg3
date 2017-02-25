function C = symmetric_initial_C(obj)
  corner = obj.corner_delta();
  P = obj.construct_P();
  C = ncon({P, P, corner}, {[-1 1], [-2 2], [1 2]});
end
