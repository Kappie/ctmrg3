function profile_ctm
  temperature = Constants.T_crit;
  chi = 30;
  tolerance = 1e-6;
  q = 2;

  sim = FixedToleranceSimulation(temperature, chi, tolerance, q);
  sim.SAVE_TO_DB = false; sim.LOAD_FROM_DB = false;

  profile on
    sim = sim.run();
  profile off
  profsave(profile('info'), 'profile_results_server')
end
