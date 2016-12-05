function [a, b, C, T, Cm, Tm, iterations, convergence, converged] = calculate_environment_tensors_m_at_each_site(temperature, chi, tolerance)
  max_iterations = 5e3;
  min_iterations = 0;
  converged = false;

  [C, T, Cm, Tm] = initial_tensors(temperature);
  a = Util.construct_a(temperature);
  b = Util.construct_b(temperature);
  singular_values = Util.initial_singular_values(chi);

  spacing = 500;
  measurements = max_iterations / spacing;

  magnetizations = zeros(measurements, 2);
  magnetizations_squared = zeros(measurements, 1);

  for i = 1:max_iterations
    if mod(i, spacing) == 0
      disp(['at iteration ' num2str(i) '.'])
      magnetizations(i/spacing, 1) = magnetization(a, b, C, T, Cm, Tm) / (2 * i + 1)^2;
      magnetizations(i/spacing, 2) = contract_peps(C, C, C, C, T, T, T, T, b) / ...
        contract_peps(C, C, C, C, T, T, T, T, a);
      magnetizations_squared(i/spacing) = magnetization_squared(a, b, C, T, Cm, Tm) / (2 * i + 1)^2;

    end

    singular_values_old = singular_values;
    [C, T, Cm, Tm, singular_values] = growth_step(chi, a, b, C, T, Cm, Tm);
    convergence = Util.calculate_convergence(singular_values, singular_values_old, chi);



    % if convergence < tolerance & i > min_iterations
    %   converged = true;
    %   break
    % end
  end

  diffs = magnetizations(:, 1) - magnetizations(:, 2);

  % markerplot(spacing:spacing:max_iterations, diffs, '--', 'loglog')
  % ylabel('$N^{-1}\sum_i \langle \sigma_i \rangle - \langle \sigma_0 \rangle$')
  cumulants = magnetizations(:, 1).^2 ./ magnetizations_squared;

  markerplot(spacing:spacing:max_iterations, cumulants - 1, '--' , 'loglog')
  ylabel('$\langle \sigma_0 \rangle^2 / N^{-1}\sum_i \langle \sigma_0 \sigma_i \rangle - 1$')
  xlabel('iteration')
  title(['$\chi = ' num2str(chi) '$, $t = ' num2str(Constants.reduced_T(temperature)) '$'])
  % legend({'$N^{-1}\sum_i \langle \sigma_i \rangle$', '$\langle \sigma_0 \rangle$'})
  % legend({'$\langle \sigma_0 \rangle^2$', '$N^{-1}\sum_i \langle \sigma_0 \sigma_i \rangle$'}, 'Location', 'best')

  iterations = i;
end
% function m = magnetization_sum(temperature, chi, tolerance)
%   max_iterations = 2e3;
%
%   [C, T, Cm, Tm] = initial_tensors(temperature);
%   a = Util.construct_a(temperature);
%   b = Util.construct_b(temperature);
%
%   singular_values = Util.initial_singular_values(chi);
%   m_old = 0;
%
%   spacing = 50;
%   index = 1;
%   measurements = max_iterations / spacing;
%   ms = zeros(1, measurements);
%   ms_single_site = zeros(1, measurements);
%   m_exact = Constants.order_parameter(temperature);
%
%   for i = 1:max_iterations
%     if mod(i, spacing) == 0
%       disp(['at iteration ' num2str(i)])
%       m_sum = order_parameter(a, b, C, T, Cm, Tm);
%       m_per_site = m_sum / (2 * i + 1)^2;
%       ms(index) = m_per_site;
%       ms_single_site(index) = OrderParameter.value_at(temperature, C, T);
%       index = index + 1;
%     end
%
%     singular_values_old = singular_values;
%     [C, T, Cm, Tm, singular_values] = growth_step(chi, a, b, C, T, Cm, Tm);
%     convergence = Util.calculate_convergence(singular_values, singular_values_old, chi);
%
%     % if convergence < tolerance
%     %   break
%     % end
%   end
%
%   % semilogy(1:max_iterations, [abs(ms)-m_exact; abs(ms_single_site)-m_exact], '--o')
%   diffs = ms - ms_single_site;
%   markerplot(spacing:spacing:max_iterations, diffs, '--', 'loglog')
%   % markerplot(spacing:spacing:max_iterations, [ms; ms_single_site], '--')
%   % legend({'$N^{-1} \sum_i \langle \sigma_i \rangle$', '$\langle \sigma_0 \rangle$'})
%   xlabel('iteration')
%   ylabel('$N^{-1}\sum_i |\langle \sigma_i \rangle| - |\langle \sigma_0 \rangle|$')
%   title(['$ \chi = ' num2str(chi) '$, $t = ' num2str(Constants.reduced_T(temperature)) '$'])
%   % semilogy(spacing:spacing:max_iterations, ms-ms_single_site, '--o')
%   % xlabel('iteration ($N$)')
%   % ylabel('$(2N + 1)^{-2}\sum_{i}\langle \sigma_i \rangle - m_{\mathrm{exact}}$')
%   % m = magnetization(a, b, C, T, Cm, Tm);
%   m = 1;
% end

function [C, T, Cm, Tm, singular_values] = growth_step(chi, a, b, C, T, Cm, Tm)
  % grow all tensors
  Cm = grow_Cm(a, b, C, T, Cm, Tm);
  C = corner_contribution(C, T, T, a);
  Tm = grow_Tm(a, b, T, Tm);
  T = edge_contribution(T, a);

  % obtain isometries by performing an svd on C
  [U, s, U_transpose, truncation_error, full_singular_values] = tensorsvd(C, [1 2], [3 4], chi, 'n');
  singular_values = Util.scale_singular_values(diag(s));

  % renormalization step
  C = s;
  Cm = truncate_corner(Cm, U, U_transpose);
  T = truncate_edge(T, U, U_transpose);
  Tm = truncate_edge(Tm, U, U_transpose);

  % scale matrix elements to prevent numbers from becoming huge.
  % It's important to scale with the same scale factor because doing otherwise would
  % result in a final network (which should represent the expectation value) that makes no sense.
  [C, scale_factor] = Util.scale_by_largest_element(C);
  Cm = Cm / scale_factor;
  T = T / scale_factor;
  Tm = Tm / scale_factor;
end

function result = truncate_corner(corner, U, U_transpose)
  result = ncon({corner, U_transpose, U}, {[1 2 3 4], [1 2 -1], [3 4 -2]});
end

function result = truncate_edge(edge, U, U_transpose)
  result = ncon({edge, U, U_transpose}, {[2 3 1 4 -1], [2 3 -2], [1 4 -3]}, [1 4 2 3]);
end

function result = grow_Cm(a, b, C, T, Cm, Tm)
  % we have to sum over four contributions, see Philippe's paper
  result = corner_contribution(Cm, T, T, a);
  % this contribution has a factor 2, coming from the symmetry of the left and right edge.
  result = result + 2 * corner_contribution(C, T, Tm, a);
  result = result + corner_contribution(C, T, T, b);
end

function result = grow_Tm(a, b, T, Tm)
  result = edge_contribution(Tm, a);
  result = result + edge_contribution(T, b);
end

function result = corner_contribution(corner, edge1, edge2, single_site)
  % Contracts 4 tensors (1 corner, 2 edges and 1 single-site tensor).
  % Used to contract different corner contributions.
  sequence = [2 3 1 4];
  result = ncon({single_site, edge1, corner, edge2}, {[-1 1 4 -3], [1 2 -2], [2 3], [4 3 -4]}, sequence);
end

function result = edge_contribution(edge, single_site)
  result = ncon({edge, single_site}, {[1 -2 -4], [1 -1 -5 -3]});
end

function [C, T, Cm, Tm] = initial_tensors(temperature);
  C = Util.symmetric_initial_C(temperature);
  T = Util.symmetric_initial_T(temperature);
  Cm = initial_Cm(temperature);
  Tm = initial_Tm(temperature);
end

function Cm = initial_Cm(temperature)
  weighted_corner_delta = [1 0; 0 -1];
  P = Util.construct_P(temperature);
  Cm = P * weighted_corner_delta * P;
end

function Tm = initial_Tm(temperature)
  weighted_edge_delta = Util.edge_delta();
  weighted_edge_delta(2, 2, 2) = -1;
  P = Util.construct_P(temperature);
  Tm = ncon({weighted_edge_delta, P, P, P}, {[1 2 3], [1 -1], [2 -2], [3 -3]});
end
