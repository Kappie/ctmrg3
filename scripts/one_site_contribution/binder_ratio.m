function b = binder_ratio(a, b, C, T, Cm, Tm, iterations)
  m = contract_peps(C, C, C, C, T, T, T, T, b) / ...
        contract_peps(C, C, C, C, T, T, T, T, a);
  m2 = magnetization_squared(a, b, C, T, Cm, Tm) / (2 * iterations + 1)^2;
  b = m^2 / m2;

  % gives same thing in converged boundary conditions:
  
  % m = magnetization(a, b, C, T, Cm, Tm);
  % m2 = magnetization_squared(a, b, C, T, Cm, Tm);
  % b = (1/(2*iterations+1)^2) * (m^2/m2);

end
