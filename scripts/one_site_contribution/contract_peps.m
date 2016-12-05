function result = contract_peps(c1, c2, c3, c4, t1, t2, t3, t4, single_site)
  tensors = {c1, c2, c3, c4, t1, t2, t3, t4, single_site};
  leg_links = {[11 12], [5 6], [7 8], [9 10], [1 5 12], [2 6 7], [3 8 9], [4 10 11], [1 2 3 4]};
  sequence = [5 6 8 11 10 9 7 12 1 2 3 4];
  result = ncon(tensors, leg_links, sequence);
end
