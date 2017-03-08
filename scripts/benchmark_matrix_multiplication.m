function benchmark_matrix_multiplication
  rng(1)
  maxNumCompThreads(7)
  sizes = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 400 500 700 900 1200 1500];
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

  save('benchmark_mult_svd_multithread.mat', 'sizes', 'timeits_matrix_mult', 'timeits_svd');

end
