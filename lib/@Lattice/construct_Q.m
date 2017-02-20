function Q = construct_Q(obj)
  K = (1/obj.temperature)*Constants.J;

  for i = 1:obj.q
    for j = 1:obj.q
      Q(i, j) = exp(K*obj.potential(i, j));
    end
  end
end
