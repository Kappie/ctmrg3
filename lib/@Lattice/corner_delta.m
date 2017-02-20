function delta = corner_delta(obj)
  delta = zeros(obj.q, obj.q);
  for i = 1:obj.q
    delta(i, i) = 1;
  end
end
