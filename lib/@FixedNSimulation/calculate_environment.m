function [C, T, convergence, truncation_error] = calculate_environment(obj, temperature, chi, N, initial_C, initial_T)
  C = initial_C;
  T = initial_T;
  singular_values = obj.initial_singular_values(chi);
  a = obj.a_tensors(temperature);

  % Temporary addition
  % tolerance = 1e-15;
  % data_points = 500;
  % step_size = fix(N/data_points);
  % convergences = zeros(1, N/step_size);
  % order_parameters = zeros(1, N/step_size);
  % hickups_in_a_row = 0;
  % end addition

  for iteration = 1:N
    singular_values_old = singular_values;
    [C, T, singular_values, truncation_error] = obj.grow_lattice(chi, a, C, T);

    % Addition to inspect tolerance behaviour
    % if mod(iteration, step_size) == 0
    %   index = iteration/step_size;
    %   convergences(index) = obj.calculate_convergence(singular_values, singular_values_old, chi);
    %   lattice = obj.lattices(temperature);
    %   order_parameters(index) = lattice.order_parameter(C, T);
    %   if index > 1
    %     difference = convergences(index) - convergences(index - 1);
    %     if difference > 0
    %       display(['we have a problem: diff = ' num2str(difference), ' iteration: ' num2str(iteration), 'convergence = ' num2str(convergences(index))])
    %       hickups_in_a_row = hickups_in_a_row + 1;
    %     else
    %       if hickups_in_a_row ~= 0
    %         display(['hickups in a row: ' num2str(hickups_in_a_row)])
    %       end
    %       hickups_in_a_row = 0;
    %     end
    %
    %     if convergences(index) < tolerance
    %       display(['reached tolerance at iteration ' num2str(iteration)]);
    %       break;
    %     end
    %   end
    % end
    % end addition

  end

  % semilogy(1:step_size:N, convergences)
  % semilogy(1:step_size:N, order_parameters)

  % This does NOT belong to the temporary code and should STAY.
  convergence = obj.calculate_convergence(singular_values, singular_values_old, chi);
end
