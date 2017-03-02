create table t_pseudocrits (
  t_pseudocrit numeric,
  q numeric,
  n numeric,
  truncation_error numeric,
  tol_x numeric,
  chi numeric,
  c blob,
  t blob,
  UNIQUE(q, n, tol_x, chi) ON CONFLICT IGNORE
);

create index index_1 ON t_pseudocrits (q, n, truncation_error, tol_x);
