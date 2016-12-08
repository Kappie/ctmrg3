% find t * xi(chi, t) ^ (1/v) that equals x
% Used for finding equally spaced values for making a nice data collapse.
function calculate_corresponding_temperatures(x_values, chi_values, tolerance_correlation_length, max_x_err, db)
  db_id = sqlite3.open(db);

  % round to 5 decimal places; the x coordinate doesn't matter to high precision
  % in a data collapse.
  x_values = arrayfun(@(x) round(x, 5), x_values);
  temperatures = zeros(1, numel(x_values));
  width = 0.20;

  function stop = outfun(chi, temperature, optimValues, state)
    % if strcmp(state, 'done') | optimValues.fval < max_x_err
    %   stop = true;
    % elseif strcmp(state, 'init')
    %   stop = false;
    % else
    %   correlation_length = calculate_correlation_length(temperature, chi, tolerance_correlation_length);
    %   x_value = Constants.reduced_T(temperature) * correlation_length;
    %   store_to_db(x_value, correlation_length, temperature, chi, 0, max_x_err, db_id);
    %   stop = false;
    % end
    stop = false;

    if strcmp(state, 'done') | optimValues.fval < max_x_err
      stop = true;
    end

    if ~strcmp(state, 'init')
      correlation_length = calculate_correlation_length(temperature, chi, tolerance_correlation_length);
      x_value = Constants.reduced_T(temperature) * correlation_length;
      store_to_db(x_value, correlation_length, temperature, chi, 0, max_x_err, db_id);
    end
  end

  for x_index = 1:numel(x_values)
    for chi_index = 1:numel(chi_values)
      %
      % outfun_chi = @(temperature, optimValues, state) outfun(chi_values(chi_index), temperature, optimValues, state);
      options = optimset('Display', 'iter', 'TolX', 1e-8, 'OutputFcn', @(temperature, optimValues, state) outfun(chi_values(chi_index), temperature, optimValues, state));

      if ~isempty(query_db(x_values(x_index), chi_values(chi_index), db_id))
        display(['Already in DB: ' num2str(x_values(x_index))])
        continue
      else
        f = @(temperature) (abs(Constants.reduced_T(temperature) * calculate_correlation_length(temperature, chi_values(chi_index), tolerance_correlation_length) - x_values(x_index)));
        [temperature, err] = fminbnd(f, Constants.T_crit - width, Constants.T_crit + width, options)
        correlation_length = calculate_correlation_length(temperature, chi_values(chi_index), tolerance_correlation_length);
        store_to_db(x_values(x_index), correlation_length, temperature, chi_values(chi_index), err, max_x_err, db_id)
      end
    end
  end

  sqlite3.close(db);
end

function store_to_db(x, correlation_length, temperature, chi, err, max_x_err, db_id)
  x = round(x, 5);
  if err > max_x_err
    warning(['could not converge on x value of ' num2str(x) ' . Error is ' num2str(err) '.'])
  else
    query = 'insert into scaling_function (x, correlation_length, temperature, chi, error) values (?, ?, ?, ?, ?);';
    sqlite3.execute(db_id, query, x, correlation_length, temperature, chi, err);
  end

  % try to prevent matlab from crashing :(
  fclose('all');
end
