function find_T_crit
  chi_values = [4, 6, 10, 14, 20, 30, 40, 50, 60, 70, 80];
  tolerance = 1e-7;
  initial_range = Constants.T_crit + [0 0.1];
  initial_TolX = 1e-4;
  filename = ['T_pseudocrits_energy_gap' datestr(now) '.mat'];

  T_pseudocrits = zeros(1, numel(chi_values));

  range = initial_range
  TolX = initial_TolX

  for c = 1:numel(chi_values)
    T_pseudocrits(c) = find_T_pseudocrit(chi_values(c), tolerance, range, TolX);
    % We assume the pseudocritical temperature of a system with bigger chi
    % will be smaller than the previous pseudocritical temperature
    range = [range(1) T_pseudocrits(c)];
    if c >= 2
      TolX = abs((T_pseudocrits(c) - T_pseudocrits(c - 1))) / 50;
    end
  end

  markerplot(chi_values, T_pseudocrits, '--')

  save(filename, 'chi_values', 'T_pseudocrits')
end

function T_pseudocrit = find_T_pseudocrit(chi, tolerance, range, TolX)
  function energy_gap = f_minimize(temperature)
    % We want the minimize the energy gap that is linked to the correlation length
    % of the system. First eigenvalue should be 1, so we can just maximize E2.
    sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
    eigenvalues = diag(sim.tensors(1, 1).C);
    energy_gap = eigenvalues(1) - eigenvalues(2);
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_pseudocrit, energy_gap, EXITFLAG, OUTPUT] = fminbnd(@f_minimize, range(1), range(2), options)
end

% function calculate_C(temperature, chi, tolerance)
%   sim = FixedToleranceSimulation([], [], [])
%   [C, T] = FixedToleranceSimulation([], [], []).initial_tensors(temperature);
%
%
% end
