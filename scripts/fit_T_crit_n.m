function fit_T_crit_n
  q = 6;
  truncation_error = 1e-6;
  TolX = 1e-6;
  minimum_N = 45;

  records = retrieve_records(q, truncation_error, TolX);
  T_pseudocrits = extract_T_pseudocrits(records);
  N_values = extract_N_values(records)

  [fit_object, goodness] = fit_kosterlitz(T_pseudocrits, N_values, minimum_N)
  show_kosterlitz_fit(fit_object, T_pseudocrits, N_values);

  fit_object.T_crit;
end

function show_kosterlitz_fit(fit_obj, T_pseudocrits, N_values)
  % reduced length variable l = 1/log(N/a)^2, in which
  % T_pseudocrit becomes linear.
  l_values = 1./log(N_values ./ fit_obj.a).^2;

  figure
  hold on
  markerplot(l_values, T_pseudocrits, 'None')
  l_values_to_plot = linspace(0, l_values(1));
  T_pseudocrits_fit = fit_obj.b^2 .* l_values_to_plot + fit_obj.T_crit;
  plot(l_values_to_plot, T_pseudocrits_fit);
  hold off
  xlabel('$l = 1 / \log(\frac{N}{a})^2$')
  ylabel('$T^{\star}(N)$')
  title('Fit to $N = a \exp(\frac{b}{\sqrt{T^{\star}-T_c}})$ for 6-state clock model. $T_c = 0.88$.')
end

function [fit_obj, goodness] = fit_kosterlitz(T_pseudocrits, N_values, minimum_N)
  % N = a * exp(b(T_star - T_crit)^(-1/2))
  correlation_length_func = @(a, b, T_crit, T_pseudocrit) a.*exp(b.*abs(T_pseudocrit-T_crit).^(-1/2));
  fit_type = fittype(correlation_length_func, 'independent', 'T_pseudocrit');
  default_options = fitoptions(fit_type);

  bounds_a = [0 Inf];
  bounds_b = [0 Inf];
  bounds_T_crit = [0.8 1.02];
  a_start = 1;
  b_start = 1;
  T_crit_start = 0.9;
  fit_options = fitoptions(default_options, ...
    'Lower', [bounds_a(1) bounds_b(1) bounds_T_crit(1)], ...
    'Upper', [bounds_a(2) bounds_b(2) bounds_T_crit(2)], ...
    'Startpoint', [a_start b_start T_crit_start], ...
    'Exclude', N_values < minimum_N);
  [fit_obj, goodness] = fit(T_pseudocrits', N_values', fit_type, fit_options);
end

function show_powerlaw_fit(fit_object, T_pseudocrits, N_values)
  markerplot(N_values, T_pseudocrits - fit_object.c, 'None')
  hold on
  values_to_plot = linspace(N_values(1), N_values(end));
  plot(values_to_plot, fit_object.a.*values_to_plot.^fit_object.b)
  hold off
  set(gca, 'XScale', 'log')
  set(gca, 'YScale', 'log')
  xlabel('$N$')
  ylabel('$T^{\star}(N) - T_c$')
  % title(['$T_c$ for 4-state clock model by max. entropy. $T_c \approx 1.135$. $\nu \approx 1.002$'])
end

function [fit_obj, goodness] = fit_power_law(T_pseudocrits, N_values, minimum_N)
  % T_pseudocrit = a * N^b + c
  model_name = 'power2';
  bounds_a = [0 Inf];
  bounds_b = [-10 0];
  bounds_c = [1.12 1.14];
  start_a = 1;
  start_b = -1;
  start_c = Constants.T_crit_guess(4);
  fit_options = fitoptions(model_name, 'Lower', [bounds_a(1) bounds_b(1) bounds_c(1)], ...
    'Upper', [bounds_a(2) bounds_b(2) bounds_c(2)], 'Startpoint', ...
    [start_a start_b start_c], 'Exclude', N_values < minimum_N);
  [fit_obj, goodness] = fit(N_values', T_pseudocrits', model_name, fit_options);
end

function Ts = extract_T_pseudocrits(records)
  Ts = arrayfun(@(s) s.t_pseudocrit, records);
end

function N_values = extract_N_values(records)
  N_values = arrayfun(@(s) s.n, records);
end

function records = retrieve_records(q, truncation_error, TolX)
  db = fullfile(Constants.DB_DIR, 't_pseudocrits_n.db');
  db_id = sqlite3.open(db);
  query = ['select * from t_pseudocrits where ' ...
    'q = ? AND truncation_error <= ? AND tol_x <= ?'];
  records = sqlite3.execute(db_id, query, q, truncation_error, TolX);
end
