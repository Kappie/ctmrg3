function result = attach_environment(obj, tensor, C, T)
  env = obj.environment(C, T);
  result = ncon({tensor, env}, {[1 2 3 4], [1 2 3 4]});
end
