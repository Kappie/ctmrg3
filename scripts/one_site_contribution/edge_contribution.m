function result = edge_contribution(edge, single_site)
  result = ncon({edge, single_site}, {[1 -2 -4], [1 -1 -5 -3]});
end
