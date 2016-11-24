function plot_spectrum_T_ball
  width = 0.5;
  temperature = Constants.T_crit + width;
  chi_values = 4:1:14;
  tolerance = 1e-9;
  

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance).run();
  tensors = sim.tensors;




end
