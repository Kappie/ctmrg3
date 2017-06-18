function diffs = relative_diffs_with_last_element(quantities)
  % We take the error on the order parameter for fixed chi to be the difference
  % with the value obtained at the smallest tolerance.
  % diffs = (quantities - quantities(:, end)) ./ quantities(:, end);
  diffs = (quantities - quantities(:, end)) ./ quantities(:, end);
end
