function corr_lengths = calculate_correlation_lengths(temperature, chi_values, tolerance, q, initial_condition)
  corr_lengths = zeros(1, numel(chi_values));
  for i = 1:numel(corr_lengths)
    corr_lengths(i) = calculate_correlation_length(temperature, chi_values(i), tolerance, q, initial_condition);
  end
end
