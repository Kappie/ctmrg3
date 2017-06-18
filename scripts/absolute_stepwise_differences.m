function diffs = absolute_stepwise_differences(quantities)
  diffs = abs(quantities - circshift(quantities, 1));
  diffs = diffs(2:end, :);
end
