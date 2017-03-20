function tensor_struct = find_or_calculate_environment(obj, temperature, chi, tolerance)
  % I look for all records with the same temperature, same chi and greater or equal tolerance.
  % If I find an exact match (same temperature, chi, tolerance as I'm trying to simulate)
  % I do not simulate again.
  % If I find a record with matching temperature and chi and higher tolerance
  % I select the C, T from that record to use as initial C, T for the new simulation.
  query = ['SELECT * ' ...
    'FROM tensors ' ...
    'WHERE temperature = ? AND chi = ? AND convergence >= ? AND initial = ? AND q = ? ' ...
    'ORDER BY convergence ASC ' ...
    'LIMIT 1'];
  if obj.LOAD_FROM_DB
    query_result = sqlite3.execute(obj.db_id, query, temperature, chi, ...
      tolerance, obj.initial_condition, obj.q);
  else
    query_result = [];
  end

  if isempty(query_result)
    fprintf(['Did not find record for:\n' ...
      'chi = ' num2str(chi) ', temperature = ' num2str(temperature) ...
      ', tolerance = ' num2str(tolerance) ', q = ' num2str(obj.q) '.\n'])
    [initial_C, initial_T] = obj.initial_tensors(temperature);
    [C, T, convergence, N, converged, truncation_error] = obj.calculate_environment(temperature, chi, tolerance, initial_C, initial_T);
    simulated = true;
  else
    if query_result.chi == chi && query_result.convergence == tolerance
      [C, T] = Util.deserialize_tensors(query_result);
      if isempty(query_result.truncation_error)
        display('Found empty truncation error. Updating...')
        % Do one additional iteration to recalculate truncation_error.
        sim = FixedNSimulation(temperature, chi, 1, obj.q);
        [~, ~, ~, truncation_error] = sim.calculate_environment(...
          temperature, chi, 1, C, T);
        query = ['update tensors set truncation_error = ? ' ...
          'where temperature = ? AND chi = ? AND convergence = ? AND initial = ? AND q = ?'];
        sqlite3.execute(obj.db_id, query, truncation_error, temperature, ...
          chi, tolerance, obj.initial_condition, obj.q);
      else
        truncation_error = query_result.truncation_error;
      end
      convergence = query_result.convergence;
      simulated = false;
    else
      fprintf(['Found a record with higher tolerance to use as initial condition\n' ...
        'chi = ' num2str(query_result.chi) ...
        ', convergence = ' num2str(query_result.convergence) ...
        ', N = ' num2str(query_result.n) '\n'])
      [initial_C, initial_T] = Util.deserialize_tensors(query_result);
      [C, T, convergence, additional_N, converged, truncation_error] = obj.calculate_environment(temperature, chi, ...
        tolerance, initial_C, initial_T);
      fprintf(['I did an additional ' num2str(additional_N) ' steps.\n'])
      N = query_result.n + additional_N;
      simulated = true;
    end
  end

  if simulated && converged
    obj.save_to_db(temperature, chi, N, tolerance, C, T, truncation_error);
  end

  tensor_struct = struct('C', C, 'T', T, 'convergence', convergence, 'truncation_error', truncation_error);
end
