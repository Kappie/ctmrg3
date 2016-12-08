function result = truncate_edge(edge, U, U_transpose)
  result = ncon({edge, U, U_transpose}, {[2 3 1 4 -1], [2 3 -2], [1 4 -3]}, [1 4 2 3]);
end
