function netcon_test
  % represent C growth step
  legLinks = { [-1 1 2 3 4], [1 4 -3], [2 3 -2] };
  legCosts = [...
    -1 2 0;
    -2 1 1;
    -3 1 1;
     1 2 0;
     2 2 0;
     3 1 1;
     4 1 1
    ];
  verbosity = 3;
  costType = 2;
  muCap = 1;
  allowOPs = true;

  [sequence cost] = netcon(legLinks, verbosity, costType, muCap, allowOPs, legCosts)

end
