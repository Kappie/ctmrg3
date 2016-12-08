function result = truncate_corner(corner, U, U_transpose)
  result = ncon({corner, U_transpose, U}, {[1 2 3 4], [1 2 -1], [3 4 -2]});
end
