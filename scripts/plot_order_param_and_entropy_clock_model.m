function plot_order_param_and_entropy_clock_model
  q = 5;
  chi_values = [20 40 60 80];
  % chi_values = [20];
  left_bound = 0.8;
  right_bound = 1.05;
  tolerance = 1e-7;
  initial = 'spin-up';

  DATABASE = FixedToleranceSimulation(1, 1, 1, 2).DATABASE;
  db_id = sqlite3.open(DATABASE);

  sims = {};

  for chi = chi_values
    query = ['select * from tensors where q = ? and chi = ? and temperature >= ? and temperature <= ? ' ...
      'and convergence = ? and initial = ?;'];
    query_result = sqlite3.execute(db_id, query, q, chi, left_bound, right_bound, ...
      tolerance, initial);

    temperatures = arrayfun(@(result_struct) result_struct.temperature, query_result);
    sims{end+1} = FixedToleranceSimulation(temperatures, chi, tolerance, q).run();
  end

  sqlite3.close(DATABASE);

  save('q5_all_temperatures_chi20-80.mat', 'sims')
end
