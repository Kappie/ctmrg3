attach "t_pseudocrits_server.db" as t_pseudocrits_server;
insert into t_pseudocrits select * from t_pseudocrits_server.t_pseudocrits;
