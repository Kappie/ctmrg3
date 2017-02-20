classdef EnergyGap < Quantity
  methods(Static)
    function value = value_at(~, C, ~)
      eigenvalues = diag(C);
      % make sure eigenvalues are normalized.
      eigenvalues = eigenvalues ./ norm(eigenvalues);
      % make sure eigenvalues sorted from large to small
      eigenvalues = sort(eigenvalues, 'descend');
      value = eigenvalues(1) - eigenvalues(2);
    end
  end
end
