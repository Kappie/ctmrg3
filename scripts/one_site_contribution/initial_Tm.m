function Tm = initial_Tm(temperature)
  weighted_edge_delta = Util.edge_delta();
  weighted_edge_delta(2, 2, 2) = -1;
  P = Util.construct_P(temperature);
  Tm = ncon({weighted_edge_delta, P, P, P}, {[1 2 3], [1 -1], [2 -2], [3 -3]});
end
