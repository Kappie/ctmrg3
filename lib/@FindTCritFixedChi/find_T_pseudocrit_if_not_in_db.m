function [T_pseudocrit, tensors] = find_T_pseudocrit_if_not_in_db(obj, q, chi)
  if obj.LOAD_FROM_DB
    query = ['select * from t_pseudocrits where ' ...
      'q = ? AND tol_x = ? AND chi = ? AND tolerance = ? AND method = ?'];
    query_result = sqlite3.execute(obj.db_id, query, q, obj.TolX, chi, obj.tolerance, obj.method);
  else
    query_result = [];
  end

  if ~isempty(query_result)
    % T_pseudocrit already known.
    T_pseudocrit = query_result.t_pseudocrit;
    % If tensors are not already in database, recalculate them.
    if isempty(query_result.c)
      sim = FixedToleranceSimulation(query_result.t_pseudocrit, ...
        query_result.chi, query_result.tolerance, query_result.q).run()
      C = sim.tensors.C; T = sim.tensors.T;
      [bytes_C, bytes_T] = Util.serialize_tensors(C, T);
      query = [
        'update t_pseudocrits set c = ?, t = ? where ' ...
        't_pseudocrit = ? AND q = ? AND tol_x = ? AND chi = ? AND tolerance = ? AND method = ?'
      ];
      sqlite3.execute(obj.db_id, query, bytes_C, bytes_T, query_result.t_pseudocrit, ...
        query_result.q, query_result.tol_x, query_result.chi, query_result.tolerance, query_result.method);
      display(['updated C, T tensors for chi = ' num2str(chi)])
    else
      [C, T] = Util.deserialize_tensors(query_result);
    end
    tensors = struct('C', C, 'T', T);
    display(['Found record in database for q = ' num2str(q) ' chi = ' num2str(chi)])
  else
    % T_pseudocrit not known: run simulations
    [T_pseudocrit, tensors] = obj.find_T_pseudocrit(q, chi);
    obj.store_to_db(T_pseudocrit, q, chi, tensors);
  end
end
