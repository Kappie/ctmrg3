function result = grow_Tm(a, b, T, Tm)
  result = edge_contribution(Tm, a);
  result = result + edge_contribution(T, b);
end
