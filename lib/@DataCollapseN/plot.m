function plot(obj, varargin)
  if ~exist('T_crit', 'var')
    T_crit = obj.results.T_crit;
  end
  if ~exist('beta', 'var')
    beta = obj.results.beta;
  end
  if ~exist('nu', 'var')
    nu = obj.results.nu;
  end
  [x_values, scaling_function_values] = obj.collapse(...
    T_crit, ...
    beta, ...
    nu);

  figure
  for N_i = 1:numel(obj.N_values)
    hold on
    plot(x_values(:, N_i), scaling_function_values(:, N_i), 'LineStyle', 'None', 'marker', 'o')
  end
  hold off

  make_legend(obj.N_values, 'N')
end
