classdef PartitionFunction < Quantity
  methods(Static)
    function value = value_at(temperature, C, T)
      value = Util.partition_function(temperature, C, T);
    end
  end
end
