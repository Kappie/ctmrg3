function values = compute(obj, quantity)
  % We insert a single element array because we only have to compute a quantity for
  % every combination of temperature and N value.
  values = obj.compute_for_every_combination(quantity, obj.temperatures, obj.N_values, [1]);
end
