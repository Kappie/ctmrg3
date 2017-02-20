classdef Lattice
  % Lattice class contains methods that calculate lattice-specific tensors and other quantities.
  properties
    q;
    temperature;
  end

  methods
    function obj = Lattice(q, temperature)
      obj.q = q;
      obj.temperature = temperature;
    end
  end
end
