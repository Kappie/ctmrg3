create table scaling_function (x numeric, temperature numeric, correlation_length numeric, chi numeric, error numeric);

create index x_index on scaling_function (chi, x);
