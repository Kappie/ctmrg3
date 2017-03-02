CREATE INDEX index_n ON tensors (temperature, chi, initial, q, n);
CREATE INDEX index_convergence ON tensors (temperature, chi, initial, q, convergence);
