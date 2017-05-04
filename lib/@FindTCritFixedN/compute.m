function values = compute(obj, quantity)
  values = zeros(numel(obj.q_values), numel(obj.N_values));

  for q_index = 1:numel(obj.q_values)
    for N_index = 1:numel(obj.N_values)
      lattice = Lattice(obj.q_values(q_index), obj.N_values(N_index));
      C = obj.tensors(q_index, N_index).C;
      T = obj.tensors(q_index, N_index).T;
      quantity_func = str2func(quantity);
      values(q_index, N_index) = quantity_func(lattice, C, T);
    end
  end

  values = squeeze(values);
end
