function values = compute_for_every_combination(obj, quantity, temperatures, values1, values2)
  values = zeros(numel(temperatures), numel(values1), numel(values2));

  for T_index = 1:numel(temperatures)
    for i1 = 1:numel(values1)
      for i2 = 1:numel(values2)
        C = obj.tensors(T_index, i1, i2).C;
        T = obj.tensors(T_index, i1, i2).T;

        % string specified should match a function of the Lattice class
        quantity_func = str2func(quantity);
        lattice = obj.lattices(temperatures(T_index));
        values(T_index, i1, i2) = quantity_func(lattice, C, T);
      end
    end
  end

  % automatically squeeze out singleton dimensions for convenience
  values = squeeze(values);
end
