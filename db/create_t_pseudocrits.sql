create table t_pseudocrits (
  t_pseudocrit numeric,
  energy_gap numeric,
  chi numeric,
  tolerance numeric,
  tol_x numeric,
  entropy numeric,
  q numeric,
  method string,
  UNIQUE(t_pseudocrit, chi, tolerance, tol_x, q, method) ON CONFLICT IGNORE
);

create index index_1 ON t_pseudocrits (chi, tolerance, tol_x, q, method);
