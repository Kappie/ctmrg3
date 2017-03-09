function plot_timeit_results
  load('benchmark_mult_svd_multithread_small.mat', 'sizes', 'timeits_matrix_mult', ...
    'timeits_svd', 'timeits_matrix_mult_stds', 'timeits_svd_stds')
  timeits_matrix_mult_multithread = timeits_matrix_mult;
  timeits_matrix_mult_stds_multithread = timeits_matrix_mult_stds;
  timeits_svd_multithread = timeits_svd;
  timeits_svd_stds_multithread = timeits_svd_stds;
  load('benchmark_mult_svd_singlethread_small.mat', 'sizes', 'timeits_matrix_mult', ...
    'timeits_svd', 'timeits_matrix_mult_stds', 'timeits_svd_stds')
  timeits_matrix_mult_singlethread = timeits_matrix_mult;
  timeits_matrix_mult_stds_singlethread = timeits_matrix_mult_stds;
  timeits_svd_singlethread = timeits_svd;
  timeits_svd_stds_singlethread = timeits_svd_stds;

  hold on
  errorbar(sizes, timeits_svd_multithread, ...
    timeits_svd_stds_multithread, 'o')
  errorbar(sizes, timeits_svd_singlethread, ...
    timeits_svd_stds_singlethread, 'o')
  hold off

  % plot(sizes, [timeits_matrix_mult_multithread; timeits_matrix_mult_singlethread], ...
      % '--o')
  set(gca, 'XScale', 'log')
  set(gca, 'YScale', 'log')
  % markerplot(sizes, [timeits_svd_multithread; timeits_svd_singlethread], '--', 'loglog')
  legend({'7 cores', '1 core'});
  xlabel('Matrix size')
  ylabel('Time')
  title('Singular value decomposition')
end
