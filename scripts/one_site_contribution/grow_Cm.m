function result = grow_Cm(a, b, C, T, Cm, Tm)
  % we have to sum over four contributions, see Philippe's paper
  result = corner_contribution(Cm, T, T, a);
  % this contribution has a factor 2, coming from the symmetry of the left and right edge.
  result = result + 2 * corner_contribution(C, T, Tm, a);
  result = result + corner_contribution(C, T, T, b);
end
