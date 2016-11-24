function obj = calculate_a_tensors(obj)
  a_tensors = arrayfun(@Util.construct_a, obj.temperatures, 'UniformOutput', false);
  % if we have one temperature, containers.Map thinks I want to store a cell array.
  % But I want just the a-tensor in that case.
  if size(a_tensors, 2) == 1 & size(a_tensors, 1) == 1
    a_tensors = a_tensors{1};
  end
  obj.a_tensors = containers.Map(obj.temperatures, a_tensors);
end
