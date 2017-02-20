function T = spin_up_initial_T(obj)
  spin_up_edge = zeros(obj.q, obj.q, obj.q);
  spin_up_edge(1, 1, 1) = 1;
  P = obj.construct_P();
  T = ncon({P, P, P, spin_up_edge}, {[-1 1], [-2 2], [-3 3], [1 2 3]});
end
