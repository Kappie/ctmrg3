function value = corner_energy_gap(obj, C, T)
  corner_spectrum = diag(C);
  corner_energies = -4*log10(corner_spectrum);
  value = corner_energies(2) - corner_energies(1);
end
