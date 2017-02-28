function fit_power_law_T_pseudocrit
  q = 2;
  TolX = 1e-6;
  tolerances = [1e-7];
  method = 'energy gap';

  figure

  for tolerance = tolerances
    [T_pseudocrits, chi_values] = load_T_pseudocrits_from_db(tolerance, q, TolX, method);
    % indices_to_throw_away = [1 2 3 8 9 10 11];
    indices_to_throw_away = [];
    T_pseudocrits(indices_to_throw_away) = [];
    chi_values(indices_to_throw_away) = [];

    [eigenvalues] = load_eigenvalues_ctm(T_pseudocrits, chi_values, tolerance, q);
    [length_scales, energy_gaps] = calculate_length_scales(eigenvalues);
    entropies = calculate_entropies(eigenvalues);

    chi_values
    % markerplot(exp(entropies), T_pseudocrits, '--')
    % for c = 1:numel(chi_values)
    %   display(['doing chi = ' num2str(chi_values(c))]);
    %   correlation_lengths(c) = calculate_correlation_length(T_pseudocrits(c), ...
    %     chi_values(c), tolerance, q);
    %
    % end
    % load('correlation_lengths_q5_chi10-80.mat', 'correlation_lengths')
    % hold on
    % semilogy(eigenvalues{end}, '--o')
    % markerplot(length_scales, T_pseudocrits, '--')
    % plot(chi_values, T_pseudocrits, '--o')
    model_name = 'power2'
    x = length_scales;
    y = T_pseudocrits;
    fit_options = fitoptions(model_name, 'Lower', [0 -10 2.25], ...
      'Upper', [Inf 0 2.27], 'Startpoint', [1 -1 Constants.T_crit], 'Exclude', x < 0);
    [fit_obj, goodness] = fit(x', y', model_name, fit_options)
    plot(fit_obj, x, y)
    % xlabel('$\chi$')
    % ylabel('$T^{*}(\chi)$')
    % title('5-state clock model. $T^{*}(\chi)$ as point of maximum entropy.')
    % hline(Constants.T_crit, '--')
    % diffs = T_pseudocrits - Constants.T_crit
  end


  % make_legend_tolerances(tolerances)
  % hold off


  % T_pseudocrits - Constants.T_crit_guess(q)

  % if strcmp(method, 'energy gap')
  %   [T_crit, mse] = fit_power_law(T_pseudocrits, length_scales)
  % elseif strcmp(method, 'entropy')
  %   [T_crit, mse] = fit_power_law(T_pseudocrits, chi_values)
  % end

  % x = abs(T_pseudocrits' - Constants.T_crit_guess(q)).^(-0.5);
  % y = length_scales'
  % [f, goodness] = fit(x, y, 'exp1', 'Exclude', [1])
  % plot(f, x, y)
  % xlabel('$|T^{\star}(\chi) - T_c|^{-1/2}$')
  % ylabel('$N_{\mathrm{CTM}}$')
  % title('Kosterlitz-Thouless divergence near $T_{c}^{\mathrm{high}}$ in 5-state clock model')


  % [T_crit, mse, exitflag] = fit_kosterlitz_transition(...
  %   T_pseudocrits, length_scales, Constants.T_crit_guess(q));
  % xlabel('$\log(N_{\mathrm{CTM}}) = 1 / \log(\frac{C_1}{C_2})$')
  % ylabel('$T^{\star}(\chi) - T_c$')
  % title(['Estimation of $T_c = ' num2str(T_crit, 4) '$ for 5-state clock model'])
  % [T_crit, mse] = fit_power_law(T_pseudocrits, exp(entropies))
  % T_crit - Constants.T_crit_guess(q)
end


function [T_crit, mse, exitflag] = fit_power_law(T_pseudocrits, length_scales)
  search_width = 0.20;
  TolX = 1e-14;
  T_crit_guess = T_pseudocrits(end);

  function mse = f_minimize(T_crit)
    t_pseudocrits = abs(T_pseudocrits - T_crit);
    [slope, intercept, mse] = logfit(1./length_scales, t_pseudocrits, ...
      'loglog', 'skipBegin', 0, 'skipEnd', 0);
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_crit, mse, exitflag] = fminbnd(@f_minimize, ...
    T_crit_guess - search_width, T_crit_guess, options);
end

function [T_crit, mse, exitflag] = fit_kosterlitz_transition(T_pseudocrits, length_scales, T_crit_guess)
  search_width = 0.05;
  TolX = 1e-10;
  sigma = 0.5;

  function mse = f_minimize(T_crit)
    [fit_object, goodness] = fit((T_pseudocrits' - T_crit).^(-sigma), length_scales', 'exp1')
    plot(fit_object, length_scales, (T_pseudocrits - T_crit))
    mse = goodness.rmse;
    % [slope, intercept, mse] = logfit(length_scales, ...
    %   (T_pseudocrits - T_crit).^(-0.5), 'logy', 'skipBegin', 4, 'skipEnd', 0)
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_crit, mse, exitflag] = fminbnd(@f_minimize, ...
    T_crit_guess - search_width, T_crit_guess + search_width, options)
end

function [T_pseudocrits, chi_values] = load_T_pseudocrits_from_db(tolerance, q, TolX, method)
  db_path = fullfile(Constants.DB_DIR, 't_pseudocrits.db');
  db_id = sqlite3.open(db_path);
  query = [
    'select t_pseudocrit, chi from t_pseudocrits ' ...
    'where tolerance = ? AND q = ? AND tol_x = ? AND method = ? ' ...
    'order by chi asc;'
  ];
  query_result = sqlite3.execute(db_id, query, tolerance, q, TolX, method);
  T_pseudocrits = arrayfun(@(result) result.t_pseudocrit, query_result);
  chi_values = arrayfun(@(result) result.chi, query_result);
end

function eigenvalues = load_eigenvalues_ctm(T_pseudocrits, chi_values, tolerance, q)
  % all tensors should be in db, since they were already calculated during maximization of entropy
  eigenvalues = {};
  for i = 1:numel(T_pseudocrits)
    sim = FixedToleranceSimulation(T_pseudocrits(i), chi_values(i), tolerance, q).run();
    % We still need to normalize the eigenvalues!
    eigenvalues_chi = diag(sim.tensors.C);
    eigenvalues{end+1} = Util.scale_by_trace_condition(eigenvalues_chi);
  end
end

function [length_scales, energy_gaps] = calculate_length_scales(eigenvalues)
  length_scales = zeros(1, length(eigenvalues));
  energy_gaps = zeros(1, length(eigenvalues));
  for i = 1:length(eigenvalues)
    eigenvalues_chi = eigenvalues{i};
    energy_gaps(i) = eigenvalues_chi(1) - eigenvalues_chi(2);
    length_scales(i) = exp(1/(log(eigenvalues_chi(1)/eigenvalues_chi(2))));
  end
end

function entropies = calculate_entropies(eigenvalues)
  entropies = zeros(1, length(eigenvalues));
  for i = 1:length(eigenvalues)
    eigenvalues_chi = eigenvalues{i};
    entropies(i) = -sum(log2(eigenvalues_chi.^4).*eigenvalues_chi.^4);
  end
end

function corr_lengths = calculate_correlation_length(T, chi, tolerance, q)
  sim = FixedToleranceSimulation(T, chi, tolerance, q).run();
  corr_lengths = sim.compute('correlation_length');
end
