classdef Entropy < Quantity
  methods(Static)
    function value = value_at(~, C, ~)
      eigenvalues = diag(C);
      % make sure eigenvalues are normalized.
      eigenvalues = eigenvalues ./ norm(eigenvalues);
      value = - sum(eigenvalues.^4 .* log(eigenvalues.^4));
    end
  end
end
