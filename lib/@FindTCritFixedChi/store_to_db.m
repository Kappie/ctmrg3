function store_to_db(obj, T_pseudocrit, q, chi, tensors)
  query = ['insert into t_pseudocrits (t_pseudocrit, q, chi, c, t, tol_x, tolerance, method) ' ...
    'values (?, ?, ?, ?, ?, ?, ?, ?)'];
  [bytesC, bytesT] = Util.serialize_tensors(tensors.C, tensors.T);

  sqlite3.execute(obj.db_id, query, T_pseudocrit, q, chi, bytesC, bytesT, obj.TolX, obj.tolerance, obj.method);
end
