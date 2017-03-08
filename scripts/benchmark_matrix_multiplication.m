function benchmark_matrix_multiplication
  rng(1)
  maxNumCompThreads(1)
  sizes = [25:25:400 450:50:600];
  timeits_matrix_mult = zeros(1, numel(sizes));
  timeits_matrix_mult_stds = zeros(1, numel(sizes));
  timeits_svd = zeros(1, numel(sizes));
  timeits_svd_stds = zeros(1, numel(sizes));

  for i = 1:numel(sizes)
    A = rand(sizes(i));
    B = rand(sizes(i));
    multiplication = @() A * B;
    perform_svd = @() svd(A);
    [timeits_matrix_mult(i), timeits_matrix_mult_stds(i)] = timeit2(multiplication);
    [timeits_svd(i), timeits_svd_stds(i)] = timeit2(perform_svd);
  end

  save('benchmark_mult_svd_singlethread.mat', 'sizes', ...
    'timeits_matrix_mult', 'timeits_svd', ...
    'timeits_matrix_mult_stds', 'timeits_svd_stds');

end
