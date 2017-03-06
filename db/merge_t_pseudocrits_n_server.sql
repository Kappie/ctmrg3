attach "t_pseudocrits_n_server.db" as t_pseudocrits_n_server;
insert into t_pseudocrits select * from t_pseudocrits_n_server.t_pseudocrits;
