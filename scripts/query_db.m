function result = query_db(x, chi, db_id)
  x = round(x, 5);
  query = 'select * from scaling_function where x = ? AND chi = ?;';
  result = sqlite3.execute(db_id, query, x, chi);
end
