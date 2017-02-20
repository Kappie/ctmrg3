function b = construct_b(obj)
  g = obj.construct_g();
  P = obj.construct_P();
  b = ncon({P, P, P, P, g}, {[-1, 1], [-2, 2], [-3, 3], [-4, 4], [1, 2, 3, 4]});
end
