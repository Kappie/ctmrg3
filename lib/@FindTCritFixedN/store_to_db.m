function store_to_db(obj, T_pseudocrit, q, N, tensors, truncation_error)
  query = ['insert into t_pseudocrits (t_pseudocrit, q, n, c, t, truncation_error, chi, tol_x) ' ...
    'values (?, ?, ?, ?, ?, ?, ?, ?)'];
  [bytesC, bytesT] = serialize_tensors(tensors.C, tensors.T);
  chi = size(tensors.C, 1);

  sqlite3.execute(obj.db_id, query, T_pseudocrit, q, N, bytesC, bytesT, truncation_error, chi, obj.TolX);
end

function [bytesC, bytesT] = serialize_tensors(C, T)
  bytesC = getByteStreamFromArray(C);
  bytesT = getByteStreamFromArray(T);
end
