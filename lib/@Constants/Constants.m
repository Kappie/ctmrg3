classdef Constants
  properties(Constant)
    J = 1;
    T_crit = 2.269185314213022;
    BASE_DIR = fullfile(fileparts(mfilename('fullpath')), '..', '..');
    DB_DIR = fullfile(Constants.BASE_DIR, 'db');
    DB_QUERY_DIR = fullfile(Constants.BASE_DIR, 'db_queries');
    PLOTS_DIR = '~/Dropbox/Plots';
    THESIS_PLOTS_DATA_DIR = '~/Documents/Natuurkunde/Scriptie/LatexFiles/plots/data/';
  end

  methods(Static)
    function T = T_pseudocrit(chi)
      pseudocritical_temps = [2.326643757577982, ...
       2.281132673943244, ...
       2.274369278752719, ...
       2.273518850874524, ...
       2.270977771936769, ...
       2.270884098490101, ...
       2.270172625973289, ...
       2.269902619868271, ...
       2.269503832589511, ...
       2.269407789655612];
      chi_values = [2, 4, 6, 8, 10, 12, 14, 16, 24, 32];
      map = containers.Map(chi_values, pseudocritical_temps);
      T = map(chi);
    end

    function T = T_crit_guess(q)
      if q == 4
        T = 1 / (log(1 + sqrt(2)));
      elseif q == 2
        T = Constants.T_crit;
      else
        error('I do not know that value of q')
      end
    end

    function t = reduced_T_dot(T, T_pseudocrit)
      t = (T - T_pseudocrit) / T_pseudocrit;
    end

    % Infinite system case
    function t = reduced_T(T)
      t = Constants.reduced_T_dot(T, Constants.T_crit);
    end

    function ts = reduced_Ts(temperatures)
      ts = arrayfun(@Constants.reduced_T, temperatures);
    end

    function Ts = inverse_reduced_Ts(reduced_ts)
      Ts = Constants.T_crit * reduced_ts + Constants.T_crit;
    end

    function k = kappa()
      c = 1/2;
      k = 6 / (c*(1 + sqrt(12/c)));
    end

    function xi = correlation_length(T)
      if T >= Constants.T_crit
        xi = -1 / (log(sinh(2*(1/T))));
      else
        error('dont know that yet');
      end
    end

    function m = order_parameter(temperature)
      if temperature < Constants.T_crit
        m = (1 - sinh(2*(1/temperature)).^-4).^(1/8);
      else
        m = 0;
      end
    end

    function ms = order_parameters(temperatures)
      ms = arrayfun(@Constants.order_parameter, temperatures);
    end

    function f = free_energy_per_site(temperature)
      J = 1;
      k = sinh(2*(1/temperature)*J)^-2;

      function int = integrand(theta)
        int = log( cosh(2*(1/temperature)*J)^2 + (1/k)*sqrt(1+k^2-2*k*cos(2*theta)) );
      end

      f = (-1/(1/temperature))*( log(2)/2 + (1/(2*pi))*integral(@integrand, 0, pi) );
    end

    function fs = free_energy_per_sites(temperatures)
      fs = arrayfun(@Constants.free_energy_per_site, temperatures);
      % to comply with dimension of other quantities that I compute often.
      fs = fs';
    end
  end
end
