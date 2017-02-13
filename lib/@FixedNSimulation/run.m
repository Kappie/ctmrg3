function obj = run(obj)
  obj = obj.find_or_calculate_environment_for_every_combination(obj.temperatures, obj.chi_values, obj.N_values);
  obj.convergences = squeeze(arrayfun(@(tensor) tensor.convergence, obj.tensors));
end
