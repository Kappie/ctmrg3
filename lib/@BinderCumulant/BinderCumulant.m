classdef BinderCumulant < Quantity
  methods(Static)
    function value = value_at(temperature, C, T)

    end
  end
end

function m = moment(k, temperature, C, T)
  % calculates kth moment of magnetization

  % construct row of k edge tensors T
  edge_tensors = T;
  for i = 1:k-1
    % TODO: alles
    edge_tensors = ncon({edge_tensors, T}, [])
  end
end
