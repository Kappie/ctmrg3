function m = magnetization(a, b, C, T, Cm, Tm)
  corners = 4 * contract_peps(Cm, C, C, C, T, T, T, T, a);
  edges =   4 * contract_peps(C, C, C, C, Tm, T, T, T, a);
  single_site = contract_peps(C, C, C, C, T, T, T, T, b);
  norm =        contract_peps(C, C, C, C, T, T, T, T, a);
  m = (corners + edges + single_site) / norm;
end
