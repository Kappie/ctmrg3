function benchmark_matrix_operations
  rng(1)
  matrix_size = 200;
  vector_size = 10000;
  repeats = 100000;
  A = rand(matrix_size);
  B = rand(matrix_size);
  a = rand(vector_size, 1);
  b = rand(vector_size, 1);

  profile on
  display('starting with multiplication')
  multiplication(A, B, repeats);
  display('starting with svd')
  singular_value_decomposition(A, repeats/20);
  display('starting with vector addition')
  vector_addition(a, b, repeats * 20);
  profile off
  profsave(profile('info'), 'matrix_operations_workstation')
end

function multiplication(A, B, repeats)
  for i = 1:repeats
    A * B;
  end
end

function singular_value_decomposition(A, repeats)
  for i = 1:repeats
    svd(A);
  end
end

function vector_addition(a, b, repeats)
  for i = 1:repeats
    a + b;
  end
end
