attach "tensors_server.db" as tensors_server;
attach "tensors.db" as tensors;
attach "t_pseudocrits_server.db" as t_pseudocrits_server;
attach "t_pseudocrits.db" as t_pseudocrits;

insert into tensors.tensors select * from tensors_server.tensors;
insert into t_pseudocrits.t_pseudocrits select * from t_pseudocrits_server.t_pseudocrits;
