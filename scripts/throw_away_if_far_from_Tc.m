function temperatures = throw_away_if_far_from_Tc(temperatures, width)
  indices_to_keep = temperatures >= Constants.T_crit - width & temperatures <= Constants.T_crit + width;
  temperatures = temperatures(indices_to_keep);
end
