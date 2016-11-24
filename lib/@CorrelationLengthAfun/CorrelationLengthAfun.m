classdef CorrelationLengthAfun < Quantity
  methods(Static)
    function value = value_at(temperature, ~, T)
      a = Util.construct_a(temperature);

      number_of_eigenvalues = 2;
      [~, eigenvalues] = Util.largest_eigenvalues_transfer_matrix(a, T, number_of_eigenvalues);

      value = 1 / log(eigenvalues(1) / eigenvalues(2));
    end
  end
end
