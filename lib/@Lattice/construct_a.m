function a = construct_a(obj)
  delta = obj.construct_delta();
  P = obj.construct_P();
  a = ncon({P, P, P, P, delta}, {[-1, 1], [-2, 2], [-3, 3], [-4, 4], [1, 2, 3, 4]});
end
