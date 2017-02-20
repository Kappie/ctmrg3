function obj = initialize_lattices(obj)
  lattices = {};
  for i = 1:numel(obj.temperatures)
    lattices{end+1} = Lattice(obj.q, obj.temperatures(i));
  end

  % if we have one temperature, containers.Map thinks I want to store a cell array.
  % But I want just the lattice in that case.
  if size(lattices, 2) == 1 & size(lattices, 1) == 1
    lattices = lattices{1};
  end
  obj.lattices = containers.Map(obj.temperatures, lattices);

end
