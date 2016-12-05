function m_squared = magnetization_squared(a, b, C, T, Cm, Tm)
  norm = contract_peps(C, C, C, C, T, T, T, T, a);

  corners = 4 * contract_peps(Cm, C, C, C, T, T, T, T, b);
  edges =   4 * contract_peps(C, C, C, C, Tm, T, T, T, b);
  single_site = norm;

  m_squared = (corners + edges + single_site) / norm;
end
