function [T_pseudocrit, tensors]  = find_T_pseudocrit(obj, q, chi)
  function neg_entropy = negative_entropy(temperature)
    % We maximize the entropy to find the pseudocritical point.
    sim = FixedToleranceSimulation(temperature, chi, obj.tolerance, q);
    sim.initial_condition = obj.initial_condition;
    sim = sim.run();
    neg_entropy = -sim.compute('entropy');
  end

  range = obj.T_crit_range;
  options = optimset('Display', 'iter', 'TolX', obj.TolX);
  [T_pseudocrit, neg_entropy, EXITFLAG, OUTPUT] = fminbnd(@negative_entropy, ...
    range(1), range(2), options);

  sim = FixedToleranceSimulation(T_pseudocrit, chi, obj.tolerance, q);
  sim.initial_condition = obj.initial_condition;
  sim = sim.run();
  tensors = struct('C', sim.tensors.C, 'T', sim.tensors.T);
end
