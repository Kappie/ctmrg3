function [C, T, convergence, N, converged, truncation_error] = calculate_environment(obj, temperature, chi, tolerance, initial_C, initial_T)
  % if size(initial_C, 1) == 2
  %   boundary = 'spin-up';
  % else
  %   boundary = 'manual';
  % end
  C = initial_C;
  T = initial_T;
  a = obj.a_tensors(temperature);
  singular_values = obj.initial_singular_values(chi);
  converged = false;

  % added
  % display(['starting with ' num2str(temperature) ' chi = ' num2str(chi)])
  % minimum_iterations = 1000;
  % iterations_new_boundary_conditions = 60000;
  % boundary_conditions_changed = false;
  % lowest_convergence = 1;
  % machine_precision = 1e-15;
  % end added

  for N = 1:obj.MAX_ITERATIONS
    singular_values_old = singular_values;
    [C, T, singular_values, truncation_error] = obj.grow_lattice(chi, a, C, T);
    convergence = obj.calculate_convergence(singular_values, singular_values_old, chi);

    % added
    % if N > minimum_iterations
    %   if convergence < machine_precision | (convergence < tolerance & convergence < lowest_convergence)
    %     converged = true;
    %     break
    %   end
    % end
    %
    % if convergence < lowest_convergence
    %   lowest_convergence = convergence;
    % end
    %
    % if mod(N, 300) == 0
    %   display(['at iteration ' num2str(N) ' convergence ' num2str(convergence) ' lowest convergence ' num2str(lowest_convergence) ' boundary ' boundary])
    % end
    %
    % if N > iterations_new_boundary_conditions && ~boundary_conditions_changed
    %   display(['exceeded ' num2str(iterations_new_boundary_conditions) ' iterations. Starting over with default boundary conditions.'])
    %   [C, T] = obj.initial_tensors(temperature);
    %   boundary_conditions_changed = true;
    % end
    % end added
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
