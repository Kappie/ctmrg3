CREATE TABLE tensors (
  C BLOB,
  T BLOB,
  temperature NUMERIC,
  chi NUMERIC,
  convergence NUMERIC,
  n NUMERIC,
  initial string,
  q NUMERIC,
  UNIQUE(temperature, chi, initial, q, convergence) ON CONFLICT IGNORE
);

CREATE INDEX index_n ON tensors (temperature, chi, initial, q, n);
CREATE INDEX index_convergence ON tensors (temperature, chi, initial, q, convergence);
