function benchmark_parallelisation
  rng(1)

  matrix_size = 200;
  repeats = 100000;
  A = rand(matrix_size);
  B = rand(matrix_size);

  profile on
  do_multiplication(A, B, repeats);
  profile off
  profsave(profile('info'), 'matrix_multiplication_workstation')
end

function do_multiplication(A, B, repeats)
  for i = 1:repeats
    A * B;
  end
end
