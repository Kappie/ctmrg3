function test_parfor
  number_of_threads = 10;
  matrix_size = 2500;

  profile on
  rng(1)
  parfor i = 1:number_of_threads
    eig(rand(matrix_size));
  end

  rng(1)
  for i = 1:number_of_threads
    eig(rand(matrix_size));
  end
  profile off
  profsave(profile('info'), 'profile_results_parfor')
end
