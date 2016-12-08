function [a, b, C, T, Cm, Tm, iterations, convergence, converged] = calculate_environment_tensors_m_at_each_site(temperature, chi, tolerance)

  % chi = 16;
  % tolerance = 1e-7;
  % width = 0.001;
  % N1 = 25;
  % N2 = 50;
  %
  % minimize_fun = @(temperature) abs(1 - cumulant_ratio(temperature, chi, tolerance, N1, N2));
  % options = optimset('PlotFcns',@optimplotfval, 'TolX', 1e-6);
  %
  % fminbnd(minimize_fun, Constants.T_crit, Constants.T_crit + width, options)




  max_iterations = 100;
  min_iterations = 0;
  converged = false;

  % [C, T, Cm, Tm] = initial_tensors(temperature);
  chi_init = chi;
  [C, T, Cm, Tm] = initial_tensors_converged_environment(temperature, chi_init, tolerance);
  a = Util.construct_a(temperature);
  b = Util.construct_b(temperature);
  singular_values = Util.initial_singular_values(chi);

  spacing = 1;
  measurements = max_iterations / spacing;

  magnetizations = zeros(measurements, 2);
  magnetizations_squared = zeros(measurements, 1);
  binder_ratios = zeros(measurements, 1);

  for i = 1:max_iterations
    if mod(i, spacing) == 0
      disp(['at iteration ' num2str(i) '.'])
      % magnetizations(i/spacing, 1) = magnetization(a, b, C, T, Cm, Tm) / (2 * i + 1)^2;
      % magnetizations(i/spacing, 2) = contract_peps(C, C, C, C, T, T, T, T, b) / ...
      %   contract_peps(C, C, C, C, T, T, T, T, a);
      % magnetizations_squared(i/spacing) = magnetization_squared(a, b, C, T, Cm, Tm) / (2 * i + 1)^2;
      binder_ratios(i/spacing) = binder_ratio(a, b, C, T, Cm, Tm, i);

    end

    singular_values_old = singular_values;
    [C, T, Cm, Tm, singular_values] = growth_step(chi, a, b, C, T, Cm, Tm);
    convergence = Util.calculate_convergence(singular_values, singular_values_old, chi);


    % if convergence < tolerance & i > min_iterations
    %   converged = true;
    %   break
    % end
  end

  % cumulants = magnetizations(:, 2).^2 ./ magnetizations_squared;
  % markerplot(spacing:spacing:max_iterations, magnetizations, '--')
  % markerplot(spacing:spacing:max_iterations, magnetizations(:,1) - magnetizations(:,2), '--', 'semilogy')
  % markerplot(spacing:spacing:max_iterations, cumulants, '--')
  % hline(Constants.order_parameter(temperature), '--')

  % diffs = magnetizations(:, 1) - magnetizations(:, 2);
  %
  % % markerplot(spacing:spacing:max_iterations, diffs, '--', 'loglog')
  % ylabel('$N^{-1}\sum_i \langle \sigma_i \rangle - \langle \sigma_0 \rangle$')
  %
  % markerplot(spacing:spacing:max_iterations, cumulants - 1, '--' , 'loglog')
  % ylabel('$\langle \sigma_0 \rangle^2 / N^{-1}\sum_i \langle \sigma_0 \sigma_i \rangle - 1$')
  % xlabel('iteration')
  % legend({'$N^{-1}\sum_i \langle \sigma_i \rangle$', '$\langle \sigma_0 \rangle$'})
  % legend({'$\langle \sigma_0 \rangle^2$', '$N^{-1}\sum_i \langle \sigma_0 \sigma_i \rangle$'}, 'Location', 'best')
  markerplot(spacing:spacing:max_iterations, binder_ratios, '--')
  xlabel('iterations')
  ylabel('$\langle \sigma_0 \rangle / N^{-1}\sum_i \langle \sigma_0 \sigma_i \rangle$')
  title(['$\chi = ' num2str(chi) '$, $t = ' num2str(Constants.reduced_T(temperature)) '$'])

  correlation_length = calculate_correlation_length(temperature, chi, tolerance);
  % vline(correlation_length, '--', '$\xi$')

  iterations = i;
end
