function Z = partition_function(obj, C, T)
  Z = obj.attach_environment(obj.construct_a(), C, T);
end
