function value = entropy(obj, C, T)
  eigenvalues = diag(C);
  % make sure Tr(C^4) = 1.
  eigenvalues = Util.scale_by_trace_condition(eigenvalues);
  value = - sum(eigenvalues.^4 .* log10(eigenvalues.^4));
end
