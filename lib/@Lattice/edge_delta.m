function delta = edge_delta(obj)
  delta = zeros(obj.q, obj.q, obj.q);
  for i = 1:obj.q
    delta(i, i, i) = 1;
  end
end
