function fit_power_law_T_pseudocrit
  q = 2;
  TolX = 1e-6;
  tolerances = [1e-7];
  method = 'energy gap';

  figure

  for tolerance = tolerances
    [T_pseudocrits, chi_values] = load_T_pseudocrits_from_db(tolerance, q, TolX, method);
    % indices_to_fit = [];
    % T_pseudocrits(indices_to_throw_away) = [];
    % chi_values(indices_to_throw_away) = [];

    [eigenvalues] = load_eigenvalues_ctm(T_pseudocrits, chi_values, tolerance, q);
    [length_scales, energy_gaps] = calculate_length_scales(eigenvalues);
    entropies = calculate_entropies(eigenvalues);

    chi_values
    % hold on
    % semilogy(eigenvalues{end}, '--o')
    markerplot(chi_values, T_pseudocrits, '--')
    % hline(Constants.T_crit, '--')
    % diffs = T_pseudocrits - Constants.T_crit
  end


  % make_legend_tolerances(tolerances)
  % hold off

  % markerplot(length_scales, T_pseudocrits, '--')

  T_pseudocrits - Constants.T_crit_guess(q)

  % for c = 1:numel(chi_values)
  %   length_scales(c) = calculate_correlation_length(T_pseudocrits(c), chi_values(c), tolerance, q);
  % end
  if strcmp(method, 'energy gap')
    [T_crit, mse] = fit_power_law(T_pseudocrits, length_scales)
  elseif strcmp(method, 'entropy')
    [T_crit, mse] = fit_power_law(T_pseudocrits, entropies)
  end
  Constants.T_crit_guess(q) - T_crit
  % fit_kosterlitz_transition(T_pseudocrits, entropies, T_crit_guess)
end


function [T_crit, mse, exitflag] = fit_power_law(T_pseudocrits, length_scales)
  search_width = 0.01;
  TolX = 1e-14;
  T_crit_guess = T_pseudocrits(end);

  function mse = f_minimize(T_crit)
    t_pseudocrits = T_pseudocrits - T_crit;
    [slope, intercept, mse] = logfit(1./length_scales, t_pseudocrits, ...
      'loglog', 'skipBegin', 0, 'skipEnd', 0);
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_crit, mse, exitflag] = fminbnd(@f_minimize, ...
    T_crit_guess - search_width, T_crit_guess, options);
end

% function fit_kosterlitz_transition(T_pseudocrits, length_scales, T_crit_guess)
%   search_width = 0.20;
%   TolX = 1e-6;
%   T_crit_guess = T_pseudocrits(end);
%
%   function mse = f_minimize(T_crit)
%     [graphtype, slope, intercept, mse] = logfit(length_scales, ...
%       (T_pseudocrits - T_crit), 'skipBegin', 4, 'skipEnd', 0)
%   end
%
%   options = optimset('Display', 'iter', 'TolX', TolX);
%   [T_crit, mse, exitflag] = fminbnd(@f_minimize, ...
%     T_crit_guess - search_width, T_crit_guess, options)
% end

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
