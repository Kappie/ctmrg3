function obj = calculate_a_tensors(obj)
  a_tensors = {};
  for temperature = obj.temperatures
    lattice = obj.lattices(temperature);
    a_tensors{end+1} = lattice.construct_a();
  end
  % if we have one temperature, containers.Map thinks I want to store a cell array.
  % But I want just the a-tensor in that case.
  if size(a_tensors, 2) == 1 & size(a_tensors, 1) == 1
    a_tensors = a_tensors{1};
  end
  obj.a_tensors = containers.Map(obj.temperatures, a_tensors);
end
