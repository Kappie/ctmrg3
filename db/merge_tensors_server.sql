attach "tensors_server.db" as tensors_server;
insert into tensors select * from tensors_server.tensors;
