function function_test
  global getal
  getal = 1;

  function y = plus_een(x)
    global getal
    getal = 2;
    y = x + 1;
  end

  display(getal)
end
