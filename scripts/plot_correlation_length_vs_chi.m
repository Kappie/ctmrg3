  temperatures = [Constants.T_crit];
  chi_values = 8:2:112;
  tolerances = [1e-7];
  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();

  load('correlation_lengths_chi8-112', 'chi_values', 'correlation_lengths')
  % correlation_lengths = sim.compute(CorrelationLengthAfun);
  % order_params = sim.compute(OrderParameter);

  [slope, intercept] = logfit(chi_values, correlation_lengths, 'loglog', 'skipBegin', 9)
  xlabel('$\chi$')
  ylabel('$\xi(\chi)$')
  title(['$\kappa = ' num2str(slope) '$'])
