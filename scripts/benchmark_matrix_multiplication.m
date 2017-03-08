function benchmark_matrix_multiplication
  rng(1)
  maxNumCompThreads(1)
  sizes = [20 50 100 300 500 700 900 1200 1500 1800 2100 2600 3100];
  timeits_matrix_mult = zeros(1, numel(sizes));
  timeits_svd = zeros(1, numel(sizes));

  for i = 1:numel(sizes)
    A = rand(sizes(i));
    B = rand(sizes(i));
    multiplication = @() A * B;
    perform_svd = @() svd(A);
    timeits_matrix_mult(i) = timeit(multiplication);
    timeits_svd(i) = timeit(perform_svd);
  end

  save('benchmark_mult_svd_singlethread.mat', 'sizes', 'timeits_matrix_mult', 'timeits_svd');

end
