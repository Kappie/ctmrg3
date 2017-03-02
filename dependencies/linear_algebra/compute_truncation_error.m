function truncation_error = compute_truncation_error(singular_values, n)
% truncation_error: computes truncation error that results from truncating
% a singular value decomposition.
% singular_values: singular values from svd, ordered from large to small.
% n: number of singular values to keep.

  s_throw_away = singular_values(n+1:end);
  truncation_error = sum(s_throw_away .^ 2) / sum(singular_values .^ 2);
end
