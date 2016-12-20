function fit_power_law_T_pseudocrit
  load('T_pseudocrits_energy_gap20-Dec-2016 13:20:06');
  second_eigenvalues = 1 - energy_gaps;
  length_scales = exp(1./(log(1./second_eigenvalues)));

  % [slope, intersect, mse] = logfit(1./length_scales, T_pseudocrits - Constants.T_crit, 'loglog', 'skipBegin', 2)
  % xlabel('$\exp(-1/\log(C_1/C_2)) = 1/N_{\mathrm{CTM}}$')
  % ylabel('$T^{\star}(\chi) - T_c$')
  % title('tolerance = $10^{-7}$')
  % hline(Constants.T_crit, '--')
  fit_power_law(T_pseudocrits, length_scales)
end

function fit_power_law(T_pseudocrits, length_scales)
  search_width = 0.0005;
  TolX = 1e-15;

  function mse = f_minimize(T_crit)
    t_pseudocrits = T_pseudocrits - T_crit;
    [slope, intercept, mse] = logfit(1./length_scales, t_pseudocrits, 'loglog', 'skipBegin', 2);
    slope
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_crit, mse, exitflag] = fminbnd(@f_minimize, Constants.T_crit - search_width, Constants.T_crit + search_width, options)

  disp(Constants.T_crit - T_crit)
end
