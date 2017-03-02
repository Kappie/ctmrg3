function [T_pseudocrit, tensors, truncation_error]  = find_T_pseudocrit(obj, q, N)
  function neg_entropy = negative_entropy(temperature)
    % We maximize the entropy to find the pseudocritical point.
    set_chi(obj.chi_start);
    done = false;

    while done == false;
      sim = FixedNSimulation(temperature, get_chi(), N, q).run();
      truncation_error = sim.compute('truncation_error');
      if truncation_error > obj.max_truncation_error
        set_chi(get_chi() + 40);
      else
        done = true;
      end
    end

    neg_entropy = -sim.compute('entropy');
  end

  range = obj.T_crit_bounds(q);
  options = optimset('Display', 'iter', 'TolX', obj.TolX);
  [T_pseudocrit, neg_entropy, EXITFLAG, OUTPUT] = fminbnd(@negative_entropy, ...
    range(1), range(2), options);

  sim = FixedNSimulation(T_pseudocrit, get_chi(), N, q).run();
  tensors = struct('C', sim.tensors.C, 'T', sim.tensors.T);
  truncation_error = sim.compute('truncation_error');
end

function set_chi(value)
  global chi;
  chi = value;
  display(['set chi to ' num2str(chi)])
end

function value = get_chi()
  global chi;
  value = chi;
end
