function benchmark
  temperature = Constants.T_crit + [1];
  chi = 64;
  N = 1000;

  sim = FixedNSimulation(temperature, chi, N);
  sim.LOAD_FROM_DB = false; sim.SAVE_TO_DB = false;


  profile on
  sim = sim.run();
  disp('done')
  profile viewer

  IsNear(sim.compute(OrderParameter), Constants.order_parameter(temperature), 1e-12)

end
