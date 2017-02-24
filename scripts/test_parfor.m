function test_parfor
  number_of_threads = 10;
  matrix_size = 3000;

  profile on
  rng(1)
  parfor_svd(number_of_threads, matrix_size);
  rng(1)
  for_svd(number_of_threads, matrix_size);
  profile off
  profsave(profile('info'), 'profile_results_parfor')
end

function parfor_svd(number_of_threads, matrix_size)
  parfor i = 1:number_of_threads
    eig(rand(matrix_size));
  end
end

function for_svd(number_of_times, matrix_size)
  for i = 1:number_of_times
    eig(rand(matrix_size));
  end
end
