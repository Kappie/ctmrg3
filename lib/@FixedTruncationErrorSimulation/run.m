function obj = run(obj)
  for t = 1:numel(obj.temperatures)
    obj.chi = obj.chi_start;
    for n = 1:numel(obj.N_values)
      [obj, tensors, truncation_error] = obj.simulate(obj.temperatures(t), obj.N_values(n));
      obj.tensors(t, n) = tensors;
      obj.chi_values(t, n) = obj.chi;
      obj.truncation_errors(t, n) = truncation_error;
    end
  end
end
