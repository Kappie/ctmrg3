function value = energy_gap(obj, C, T)
  eigenvalues = diag(C);
  % make sure eigenvalues are normalized.
  eigenvalues = eigenvalues ./ norm(eigenvalues);
  % make sure eigenvalues sorted from large to small
  eigenvalues = sort(eigenvalues, 'descend');
  value = eigenvalues(1) - eigenvalues(2);
end
