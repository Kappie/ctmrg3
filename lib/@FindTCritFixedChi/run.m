function obj = run(obj)
  obj.db_id = sqlite3.open(obj.DATABASE);

  for q_index = 1:numel(obj.q_values)
    for chi_index = 1:numel(obj.chi_values)
      [T_pseudocrit, tensors] = obj.find_T_pseudocrit_if_not_in_db(obj.q_values(q_index), ...
        obj.chi_values(chi_index));
      obj.T_pseudocrits(q_index, chi_index) = T_pseudocrit;
      obj.tensors(q_index, chi_index) = tensors;
    end
  end

  obj = obj.set_length_scales();
end
