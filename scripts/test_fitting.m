function test_fitting
  a = 3; b = -2;
  sigma = 1/2;
  T_crit = 0.9;
  noise_size = 0.0;
  number_of_points = 100;
  TolX = 1e-8;
  search_width = 5e-1;
  T_pseudocrits = linspace(1, 0.95, number_of_points);
  % length_scales = exp_model(T_pseudocrits, a, b, sigma, T_crit, noise_size)
  length_scales = power_model(T_pseudocrits, a, b, T_crit, noise_size)
  exclude = length_scales < -Inf;
  markerplot(T_pseudocrits, length_scales, '--')

  fit_power_law3(length_scales, T_pseudocrits, exclude, search_width, TolX)
  fit_kosterlitz_transition2(T_pseudocrits, length_scales, exclude, search_width, TolX)
end

function y = exp_model(T_pseudocrits, a, b, sigma, T_crit, noise_size)
  noise = random_noise(noise_size, numel(T_pseudocrits));
  y = a*exp(b*(T_pseudocrits-T_crit).^(-sigma)) + noise;
end

function y = power_model(T_pseudocrits, a, b, T_crit, noise_size)
  noise = random_noise(noise_size, numel(T_pseudocrits));
  y = a.*(T_pseudocrits - T_crit).^b + noise;
end

function ans = random_noise(noise_size, N)
  ans = (-1 + 2*rand(1, N)) * noise_size;
end
