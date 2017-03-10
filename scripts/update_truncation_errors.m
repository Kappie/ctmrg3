function update_truncation_errors
  db_path = fullfile(Constants.DB_DIR, 'tensors.db');
  db_id = sqlite3.open(db_path);

  % Don't do this, it will crash everything XD
  % query = 'select * from tensors'
  % query_result = sqlite3.execute(db_id, query)
end
