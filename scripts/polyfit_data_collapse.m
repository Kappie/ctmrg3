function [norm_of_residuals] = polyfit_data_collapse(x_values, y_values, L_values)
  % We assume (up to corrections to scaling) a universal scaling function
  % of the form
  % f(t * L^(1/nu)) = L^(-a) * m(t, L)
  %
  % We assess the goodness of fit of the data collapse by fitting a k-th order
  % polynomial (k = 3 - 8, see lecture notes by Anders Sandvik) through the data
  % and computing the norm of the residuals.

  % x_values: map from double to array (sorted in ascending order)
  % y_values: map from double to array (corresponding y values)
  % L_values: array of L values. Assumption: L_values is sorted in ascending order.

  % order of polynomial to fit
  order = 0;
  skip_L_values = 0;

  total_x_values = [];
  total_y_values = [];

  for L = L_values(skip_L_values + 1 : end)
    total_x_values = [total_x_values x_values(L)];
    total_y_values = [total_y_values y_values(L)];
  end

  [polynomial, error_struct] = polyfit(total_x_values, total_y_values, order);
  norm_of_residuals = error_struct.normr;
  norm_of_residuals = norm_of_residuals / total_y_values(end);

end
