% Implements golden section search, with f unimodal, but possibly being undefined at certain points.
function [f_max, x_max] = golden_section_search_with_undefined_points(f, a, b, tol_x)
  golden_ratio = (sqrt(5) + 1) / 2;

  c = b - (b - a)/golden_ratio;
  d = a + (b - a)/golden_ratio;

  while abs(c - d) > tol_x
    [f_c, c] = evaluate_at_nearby_defined_point(f, c, tol_x);
    [f_d, d] = evaluate_at_nearby_defined_point(f, d, tol_x);
    if f_c > f_d
      b = d;
    else
      a = c;
    end

    % Recompute c and d to avoid loss of precision
    c = b - (b - a)/golden_ratio;
    d = a + (b - a)/golden_ratio;
  end

  [f_max, x_max] = evaluate_at_nearby_defined_point(f, (b + a) / 2, tol_x);
end

function [f_x, x_eval] = evaluate_at_nearby_defined_point(f, x_start, tol_x)
  x_eval = x_start;
  f_x = f(x_start);

  while strcmp(f_x, 'undefined')
    x_eval = x_start + uniform_random_within_range(-tol_x, tol_x);
    f_x = f(x_eval);
  end
end

function r = uniform_random_within_range(a, b)
  r = (b-a).*rand + a;
end
