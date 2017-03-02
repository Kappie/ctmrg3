function obj = run(obj)
  obj.db_id = sqlite3.open(obj.DATABASE);

  for q_index = 1:numel(obj.q_values)
    for N_index = 1:numel(obj.N_values)
      [T_pseudocrit, tensors, truncation_error] = obj.find_T_pseudocrit_if_not_in_db(obj.q_values(q_index), ...
        obj.N_values(N_index));
      obj.T_pseudocrits(q_index, N_index) = T_pseudocrit;
      obj.tensors(q_index, N_index) = tensors;
      obj.truncation_errors(q_index, N_index) = truncation_error;
    end
  end
end
