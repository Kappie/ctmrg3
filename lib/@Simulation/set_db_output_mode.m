function obj = set_db_output_mode(obj)
  % We're not on my laptop!!
  if ~strcmp(computer, 'MACI64') | obj.STORE_DB_QUERIES_TO_FILE
    obj.STORE_DB_QUERIES_TO_FILE = true;
    obj.SAVE_TO_DB = false;
    obj.DB_QUERY_FILE = query_file();
  end
end

function path = query_file()
  ISO_DATEFORMAT_NUMBER = 30
  filename = ['queries_' datestr(now, ISO_DATEFORMAT_NUMBER) '.sqlite3'];
  path = fullfile(Constants.DB_QUERY_DIR, filename);
end
