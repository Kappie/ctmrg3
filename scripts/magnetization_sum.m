function magnetization_sum(temperature, chi, tolerance)
  [C, T, Cm, Tm] = initial_tensors(temperature);
  a = Util.construct_a(temperature);
  b = Util.construct_b(temperature);

  for i = 1:5
    [C, T, Cm, Tm] = growth_step(chi, a, b, C, T, Cm, Tm)
  end
end

function [C, T, Cm, Tm] = growth_step(chi, a, b, C, T, Cm, Tm)
  Cm = grow_Cm(a, b, C, T, Cm, Tm);
  C = corner_contribution(C, T, T, a);
  Tm = grow_Tm(a, b, T, Tm);
  T = corner_contribution(T, a);

  
end

function result = grow_Cm(a, b, C, T, Cm, Tm)
  % we have to sum over four contributions, see Philippe's paper
  result = corner_contribution(Cm, T, T, a);
  % this contribution has a factor 2, coming from the symmetry of the left and right edge.
  result = result + 2 * corner_contribution(C, T, Tm, a);
  result = result + corner_contribution(C, T, T, b);
end

function result = grow_Tm(a, b, T, Tm)
  result = edge_contribution(Tm, a);
  result = result + edge_contribution(T, b);
end

function result = corner_contribution(corner, edge1, edge2, single_site)
  % Contracts 4 tensors (1 corner, 2 edges and 1 single-site tensor).
  % Used to contract different corner contributions.
  sequence = [2 3 1 4];
  result = ncon({single_site, edge1, corner, edge2}, {[-1 1 4 -3], [1 2 -2], [2 3], [4 3 -4]}, sequence);
end

function result = edge_contribution(edge, single_site)
  result = ncon({edge, single_site}, {[1 -2 -4], [1 -1 -5 -3]});
end

function [C, T, Cm, Tm] = initial_tensors(temperature);
  C = Util.symmetric_initial_C(temperature);
  T = Util.symmetric_initial_T(temperature);
  Cm = initial_Cm(temperature);
  Tm = initial_Tm(temperature);
end

function Cm = initial_Cm(temperature)
  weighted_corner_delta = [1 0; 0 -1];
  P = Util.construct_P(temperature);
  Cm = P * weighted_corner_delta * P;
end

function Tm = initial_Tm(temperature)
  weighted_edge_delta = Util.edge_delta()
  weighted_edge_delta(2, 2, 2) = -1;
  P = Util.construct_P(temperature);
  Tm = ncon({weighted_edge_delta, P, P, P}, {[1 2 3], [1 -1], [2 -2], [3 -3]});
end
