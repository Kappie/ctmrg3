function plot_timeit_results
  load('benchmark_mult_svd_multithread.mat', 'sizes', 'timeits_matrix_mult', 'timeits_svd')
  timeits_matrix_mult_multithread = timeits_matrix_mult;
  timeits_svd_multithread = timeits_svd;
  load('benchmark_mult_svd_singlethread.mat', 'timeits_matrix_mult', 'timeits_svd')
  timeits_matrix_mult_singlethread = timeits_matrix_mult;
  timeits_svd_singlethread = timeits_svd;
  markerplot(sizes, [timeits_matrix_mult_multithread; timeits_matrix_mult_singlethread], '--', 'loglog')
  % markerplot(sizes, [timeits_svd_multithread; timeits_svd_singlethread], '--', 'loglog')
  legend({'7 cores', '1 core'});
  xlabel('Matrix size')
  ylabel('Time')
end
