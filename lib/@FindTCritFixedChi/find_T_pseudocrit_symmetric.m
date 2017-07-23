function [T_pseudocrit, tensors] = find_T_pseudocrit_symmetric(obj, q, chi)
  function entropy = calculate_entropy(temperature)
    sim = FixedToleranceSimulation(temperature, chi, obj.tolerance, q);
    sim.initial_condition = obj.initial_condition;
    sim.stop_if_desymmetrizes = true;
    sim.number_of_iterations_to_check_desymmetrization = 100;
    sim = sim.run();

    if sim.tensors.converged
      entropy = sim.compute('entropy');
    else
      entropy = 'undefined';
    end
  end

  [max_entropy, T_pseudocrit] = golden_section_search_with_undefined_points(@calculate_entropy, ...
    obj.T_crit_range(1), obj.T_crit_range(2), obj.TolX);

  sim = FixedToleranceSimulation(T_pseudocrit, chi, obj.tolerance, q);
  sim.initial_condition = obj.initial_condition;
  sim = sim.run();
  tensors = struct('C', sim.tensors.C, 'T', sim.tensors.T);
end
