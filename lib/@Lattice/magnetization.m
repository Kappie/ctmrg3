function value = magnetization(obj, C, T)
  Z = obj.partition_function(C, T);
  unnormalized_magnetization = obj.attach_environment(obj.construct_b(), C, T);
  value = unnormalized_magnetization / Z;
end
