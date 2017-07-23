function [C, T, convergence, N, converged, truncation_error] = calculate_environment(obj, temperature, chi, tolerance, initial_C, initial_T)
  C = initial_C;
  T = initial_T;
  a = obj.a_tensors(temperature);
  singular_values = obj.initial_singular_values(chi);
  converged = false;
  current_entropy = 0;

  for N = 1:obj.MAX_ITERATIONS

    singular_values_old = singular_values;
    [C, T, singular_values, truncation_error] = obj.grow_lattice(chi, a, C, T);
    convergence = obj.calculate_convergence(singular_values, singular_values_old, chi);

    % If entropy falls, this means the tensors are desymmetrizing, at least in the
    % temperature region for which this extra check is necessary.
    % If this happens, there is no use in finishing the simulation. It may take 10^6 iterations or more
    % and gives wrongly converged tensors.
    if obj.stop_if_desymmetrizes & N >= obj.number_of_iterations_before_checking & mod(N, obj.number_of_iterations_to_check_desymmetrization) == 0
      old_entropy = current_entropy;
      current_entropy = Lattice(obj.q, temperature).entropy(C, T);

      if current_entropy < old_entropy
        display(['Entropy decreasing. Quitting simulation after ' num2str(N) ' steps. Current convergence = ' ...
          num2str(convergence) '.'])
        break
      end
    end

    if convergence < tolerance
      converged = true;
      break;
    end
  end

  if ~converged
    log_to_file(temperature, chi, tolerance, obj.MAX_ITERATIONS);
  end
end

function log_to_file(temperature, chi, tolerance, N)
  fileID = fopen('not_converged.log', 'a');
  fprintf(fileID, 'temperature = %f, chi = %f, tolerance = %g, max iterations = %f at %s.\n', temperature, chi, tolerance, N, datestr(now));
  fclose(fileID);
end
