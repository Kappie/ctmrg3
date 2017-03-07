function benchmark_parallelisation
  rng(1)

  matrix_size = 200;
  repeats = 100000;
  A = rand(matrix_size);
  B = rand(matrix_size);

  profile on
  for i = 1:repeats
    A * B;
  end
  profile off
  profile viewer
end
