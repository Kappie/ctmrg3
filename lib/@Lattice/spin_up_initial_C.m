function C = spin_up_initial_C(obj)
  spin_up_corner = zeros(obj.q, obj.q);
  spin_up_corner(1, 1) = 1;
  P = obj.construct_P();
  C = ncon({P, P, spin_up_corner}, {[-1 1], [-2 2], [1 2]});
end
