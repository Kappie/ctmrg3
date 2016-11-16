function netcon_test
  % represent C growth step
  legLinks = {[1 -1 2], [1 3 4 -2], [4 5 -3], [2 3 5]}
  legCosts = [...
    -1 1 1;
    -2 2 0;
    -3 1 1;
     1 2 0;
     2 1 1;
     3 2 0;
     4 2 0;
     5 1 1
    ];
  verbosity = 3;
  costType = 2;
  muCap = 1;
  allowOPs = true;

  [sequence cost] = netcon(legLinks, verbosity, costType, muCap, allowOPs, legCosts)

end
