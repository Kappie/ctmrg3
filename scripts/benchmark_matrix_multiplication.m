function benchmark_matrix_multiplication
  rng(1)
  sizes = [20 50 100 200 500 800 1000 1250 1500 2000 3000];
  timeits = zeros(1, numel(sizes));
  for i = 1:numel(sizes)
    A = rand(sizes(i));
    B = rand(sizes(i));
    f = @() A * B;
    timeits(i) = timeit(f);
  end

  markerplot(sizes, timeits, '--', 'loglog')
end
