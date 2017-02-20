function P = construct_P(obj)
  % We need square root of a matrix here, not the square root of the elements!
  P = sqrtm(obj.construct_Q());
end
