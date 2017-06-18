function rel_diffs = relative_stepwise_differences(quantities)
  % rel_diffs = abs(quantities - circshift(quantities, 1))
  rel_diffs = abs((quantities - circshift(quantities, 1)) ./ quantities(end, :))
  rel_diffs = rel_diffs(2:end, :);
end
