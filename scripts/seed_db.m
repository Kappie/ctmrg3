function seed_db
  database = 'db/test.db';
  n_rows = 1e5;
  db_id = sqlite3.open(database);

  insert_random_rows(db_id, n_rows);
end

function insert_random_rows(db_id, n)
  for i = 1:n
    insert_random_row(db_id)
  end
end

function insert_random_row(db_id)
  temperature = rand;
  chi = randi([4 128]);
  initial = random_initial;
  n = randi([1 30]) * 100;

  query = 'insert into tensors (temperature, chi, initial, n) values (?, ?, ?, ?);';
  sqlite3.execute(db_id, query, temperature, chi, initial, n);
end

function value = random_initial
  value = randsample({'spin-up', 'symmetric'}, 1);
  value = value{1};
end
