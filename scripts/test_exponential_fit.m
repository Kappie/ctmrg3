function test_exponential_fit
  a = 3; b = 2;
  x = linspace(1, 10)';
  y = a * exp(b .* x);
  plot(x, y)
  % [fit_object, goodness] = fit(x, y, 'lolfun')
  % plot(fit_object, x, y)
end
