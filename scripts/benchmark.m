function benchmark
  temperature = Constants.T_crit + [0];
  chi = 32;
  N = 100;

  sim = FixedNSimulation(temperature, chi, N);
  sim.LOAD_FROM_DB = false; sim.SAVE_TO_DB = false;

  profile on
  sim = sim.run();
  profile viewer

end
