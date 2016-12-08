function result = corner_contribution(corner, edge1, edge2, single_site)
  % Contracts 4 tensors (1 corner, 2 edges and 1 single-site tensor).
  % Used to contract different corner contributions.
  sequence = [2 3 1 4];
  result = ncon({single_site, edge1, corner, edge2}, {[-1 1 4 -3], [1 2 -2], [2 3], [4 3 -4]}, sequence);
end
