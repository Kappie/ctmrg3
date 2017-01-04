function fit_power_law_T_pseudocrit
  load('T_pseudocrits_energy_gap20-Dec-2016 13:20:06');
  T_pseudocrits
  Constants.T_pseudocrit(4)
  Constants.T_pseudocrit(32)
  % load('T_pseudocrits_energy_gap21-Dec-2016 08:08:49')
  second_eigenvalues = 1 - energy_gaps;
  indices_to_use = 3:6
  length_scales = exp(1./(log(1./second_eigenvalues)));
  % length_scales = zeros(1, numel(chi_values));

  % for c = indices_to_use
  %   length_scales(c) = calculate_correlation_length(T_pseudocrits(c), chi_values(c), 1e-7)
  % end

  length_scales = length_scales(indices_to_use)
  T_pseudocrits = T_pseudocrits(indices_to_use)
  chi_values = chi_values(indices_to_use)



  % [slope, intersect, mse] = logfit(1./length_scales, T_pseudocrits - Constants.T_crit, 'loglog')
  % xlabel('$\exp(-1/\log(C_1/C_2)) = 1/N_{\mathrm{CTM}}$')
  % ylabel('$T^{\star}(\chi) - T_c$')
  % title('tolerance = $10^{-7}$')
  % hline(Constants.T_crit, '--')
  fit_power_law(T_pseudocrits, length_scales)
end

function fit_power_law(T_pseudocrits, length_scales)
  search_width = 0.0010;
  TolX = 1e-12;

  function mse = f_minimize(T_crit)
    t_pseudocrits = T_pseudocrits - T_crit;
    [slope, intercept, mse] = logfit(1./length_scales, t_pseudocrits, 'loglog');
    slope
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_crit, mse, exitflag] = fminbnd(@f_minimize, Constants.T_crit - search_width, Constants.T_crit + search_width, options)

  disp(Constants.T_crit - T_crit)
end
