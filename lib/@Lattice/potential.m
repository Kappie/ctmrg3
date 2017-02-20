function E = potential(obj, i, j)
  E = cos(obj.clock_angle(i) - obj.clock_angle(j));
end
