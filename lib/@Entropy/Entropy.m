classdef Entropy < Quantity
  methods(Static)
    function value = value_at(~, C, ~)
      eigenvalues = diag(C);
      value = - sum(eigenvalues.^4 .* log(eigenvalues.^4));
    end
  end
end
