function [T_pseudocrit, tensors, truncation_error] = find_T_pseudocrit_if_not_in_db(obj, q, N)
  if obj.LOAD_FROM_DB
    query = ['select * from t_pseudocrits where ' ...
      'q = ? AND tol_x = ? AND n = ? AND truncation_error <= ? ' ...
      'order by truncation_error asc limit 1'];
    query_result = sqlite3.execute(obj.db_id, query, q, obj.TolX, N, obj.max_truncation_error);
  else
    query_result = [];
  end

  if ~isempty(query_result)
    % T_pseudocrit already known.
    T_pseudocrit = query_result.t_pseudocrit;
    [C, T] = Util.deserialize_tensors(query_result);
    tensors = struct('C', C, 'T', T);
    truncation_error = query_result.truncation_error;

    display(['Found record in database for q = ' num2str(q) ' N = ' num2str(N) ...
      ' max_truncation_error = ' num2str(obj.max_truncation_error)])
  else
    % T_pseudocrit not known: run simulations
    [T_pseudocrit, tensors, truncation_error] = obj.find_T_pseudocrit(q, N);
    obj.store_to_db(T_pseudocrit, q, N, tensors, truncation_error);
  end
end
