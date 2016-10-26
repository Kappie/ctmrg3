classdef FreeEnergy < Quantity
  methods(Static)
    function value = value_at_old(temperature, C, T)
      Z = Util.partition_function(temperature, C, T);
      four_corners = ncon({C, C, C, C}, {[1 2], [2 3], [3 4], [4 1]});
      two_rows = ncon({C, T, C, C, T, C}, {[1 2], [3 2 4], [4 5], [5 6], [3 6 7], [7 1]});
      kappa = Z * four_corners / two_rows^2;
      value = -temperature*log(kappa);
    end

    function value = value_at(temperature, C, T)
      Z = Util.partition_function(temperature, C, T);
      four_corners = trace(C^4);
      one_row = ncon({C, T, C}, {[-1 1], [-2 1 2], [2 -3]});
      % reshape into vector
      one_row = lreshape(one_row, [1 2 3], []);
      two_rows = one_row' * one_row;
      kappa = Z * four_corners / two_rows^2;
      value = -temperature*log(kappa);
    end
  end
end
