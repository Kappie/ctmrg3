function test_texual_queries
  q = 4;
  temperature = 2.02023;
  chi = 10;
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperature, chi, tolerance, q);
  sim.LOAD_FROM_DB = false;
  sim.STORE_DB_QUERIES_TO_FILE = true;
  sim = sim.run();
end
