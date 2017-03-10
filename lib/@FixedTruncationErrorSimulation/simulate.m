function [obj, tensors, truncation_error] = simulate(obj, temperature, N)
  done = false;

  while done == false
    sim = FixedNSimulation(temperature, obj.chi, N, obj.q);
    sim.SAVE_TO_DB = obj.SAVE_TO_DB;
    sim.LOAD_FROM_DB = obj.LOAD_FROM_DB;
    sim.initial_condition = obj.initial_condition;
    sim = sim.run();

    truncation_error  = sim.tensors.truncation_error;
    if truncation_error < obj.max_truncation_error
      done = true;
    else
      obj.chi = new_chi(obj.chi, obj.max_truncation_error);
    end
  end

  tensors = struct('C', sim.tensors.C, 'T', sim.tensors.T, 'convergence', [], 'truncation_error', []);
end

function chi = new_chi(chi, max_truncation_error)
  % I don't know exactly how to choose this...
  chi = chi + 20;
  display(['set chi to ' num2str(chi)])
end
