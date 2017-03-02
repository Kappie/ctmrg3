function chi = sufficient_chi(full_singular_values, max_truncation_error)
  for chi = 1:numel(full_singular_values)
    error = compute_truncation_error(full_singular_values, chi);
    if error < max_truncation_error
      break
    end
  end
end
