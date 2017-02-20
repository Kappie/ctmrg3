function g = construct_g(obj)
  g = obj.construct_delta();
  for i = 1:obj.q
    g(i, i, i, i) = cos(obj.clock_angle(i));
  end
end
