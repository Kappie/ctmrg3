function [C, T, Cm, Tm] = initial_tensors(temperature)
  C = Util.symmetric_initial_C(temperature);
  T = Util.symmetric_initial_T(temperature);
  Cm = initial_Cm(temperature);
  Tm = initial_Tm(temperature);
end
