function value = corner_energy_gap(obj, C, T)
  corner_spectrum = diag(C);
  corner_energies = -log(corner_spectrum .^ 4);
  value = corner_energies(2) - corner_energies(1);
end
