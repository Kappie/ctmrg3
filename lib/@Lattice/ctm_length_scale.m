function value = ctm_length_scale(obj, C, T)
  eigenvalues = diag(C);
  % make sure Tr(C^4) = 1.
  eigenvalues = Util.scale_by_trace_condition(eigenvalues);
  % make sure eigenvalues sorted from large to small
  eigenvalues = sort(eigenvalues, 'descend');
  value = exp(1 / log(eigenvalues(1)/eigenvalues(2)));
  % value = 1 / log(eigenvalues(1)/eigenvalues(2));
end
