function obj = set_length_scales(obj)
  obj.length_scales = zeros(1, numel(obj.tensors))
  % Initialize lattice; q and temperature don't matter.
  lattice = Lattice(2, 1);
  for i = 1:numel(obj.tensors)
    C = obj.tensors(i).C;
    T = obj.tensors(i).T;
    obj.length_scales(i) = lattice.ctm_length_scale(C, T);
  end
end
