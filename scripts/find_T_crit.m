function find_T_crit
  chi_values = [4, 6, 10, 14, 20, 24, 30, 40, 50, 60, 70, 80];
  tolerance = 1e-8;
  initial_range = Constants.T_crit + [0 0.1];
  TolX = 1e-12;

  T_pseudocrits = zeros(1, numel(chi_values));
  energy_gaps = zeros(1, numel(chi_values));
  TolXs = zeros(1, numel(chi_values));

  range = initial_range
  % initial_C = Util.spin_up_initial_C(Constants.T_crit);
  % initial_T = Util.spin_up_initial_T(Constants.T_crit);

  for c = 1:numel(chi_values)
    [T_pseudocrits(c), energy_gaps(c)] = find_T_pseudocrit(chi_values(c), tolerance, range, TolX);
    TolXs(c) = TolX;
    % Use converged C, T tensors as initial tensors to find next pseudocritical point
    % sim = FixedToleranceSimulation(T_pseudocrits(c), chi_values(c), tolerance).run();
    % initial_C = sim.tensors.C;
    % initial_T = sim.tensors.T;
    % We assume the pseudocritical temperature of a system with bigger chi
    % will be smaller than the previous pseudocritical temperature
    range = [range(1) T_pseudocrits(c)];

    save(filename(), 'chi_values', 'T_pseudocrits', 'energy_gaps', 'TolXs')
  end

  markerplot(chi_values, T_pseudocrits, '--')

end

function name = filename()
  name = ['T_pseudocrits_energy_gap' datestr(now)];
end

function [T_pseudocrit, energy_gap] = find_T_pseudocrit(chi, tolerance, range, TolX)
  function energy_gap = f_minimize(temperature)
    % We want the minimize the energy gap that is linked to the correlation length
    % of the system. First eigenvalue should be 1, so we can just maximize E2.
    % [C, T] = get_tensors(temperature, chi, tolerance, initial_C, initial_T);
    sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
    eigenvalues = diag(sim.tensors.C);
    energy_gap = eigenvalues(1) - eigenvalues(2);
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_pseudocrit, energy_gap, EXITFLAG, OUTPUT] = fminbnd(@f_minimize, range(1), range(2), options)
end

function [C, T] = get_tensors(temperature, chi, tolerance, initial_C, initial_T)
  sim = FixedToleranceSimulation(temperature, chi, tolerance);
  sim.initial_condition = 'preconverged';
  sim.db_id = sqlite3.open(sim.DATABASE);
  [C, T, convergence, N, ~, ~] = sim.calculate_environment(temperature, chi, tolerance, initial_C, initial_T);
  display(['I did ' num2str(N) ' iterations for the last run.'])
  sim.save_to_db(temperature, chi, -1, tolerance, C, T);
end
