function Cm = initial_Cm(temperature)
  weighted_corner_delta = [1 0; 0 -1];
  P = Util.construct_P(temperature);
  Cm = P * weighted_corner_delta * P;
end
