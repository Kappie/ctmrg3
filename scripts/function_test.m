function function_test
  function y = add_one(x)
    y = x + 1;
  end

  mijn_functie = @add_one;
  mijn_functie(1)
  mijn_andere_functie = @mijn_functie
end
