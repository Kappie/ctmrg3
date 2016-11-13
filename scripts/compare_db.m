function compare_db
  db_without_index = 'db/test.db';
  db_with_index = 'db/test_with_index.db';

  id_without_index = sqlite3.open(db_without_index);
  id_with_index = sqlite3.open(db_with_index);

  number_of_queries = 2000;

  query = ['SELECT * ' ...
  'FROM tensors ' ...
  'WHERE temperature = ? AND chi = ? AND n <= ? AND initial = ?' ...
  'ORDER BY n DESC ' ...
  'LIMIT 1'];


  profile on
  for i = 1:number_of_queries
    random_query(id_without_index, query)
    random_query(id_with_index, query)
  end
  profile viewer

end

function random_query(db_id, query)
  temperature = rand;
  chi = randi([4 128]);
  initial = random_initial;
  n = randi([1 30]) * 100;

  sqlite3.execute(db_id, query, temperature, chi, initial, n);
end

function value = random_initial
  value = randsample({'spin-up', 'symmetric'}, 1);
  value = value{1};
end
