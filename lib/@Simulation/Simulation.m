classdef (Abstract) Simulation
% SIMULATION Abstract base class.
% See also FixedNSimulation, FixedToleranceSimulation.

  properties
    DATABASE = fullfile(Constants.DB_DIR, 'tensors.db');
    db_id;
    LOAD_FROM_DB = true;
    SAVE_TO_DB = true;
    temperatures;
    chi_values;
    N_values;
    tolerances;
    q;
    tensors;
    a_tensors;
    initial_condition = 'spin-up';
    significant_digits = 13;
    lattices;
  end

  methods
    function obj = Simulation(temperatures, chi_values, q)
      obj.temperatures = arrayfun(@(temp) round(temp, obj.significant_digits), temperatures);
      obj.chi_values   = chi_values;
      obj.q            = q;
      % create empty array of structs that I can fill with C, T tensors.
      obj.tensors = struct('C', {}, 'T', {}, 'convergence', {});
      % initialize lattice objects that contain all physical information
      obj = obj.initialize_lattices();
      % precalculate a-tensors for each temperature
      obj = obj.calculate_a_tensors();
    end

    function obj = after_initialization(obj)
    end

    function [C, T] = initial_tensors(obj, temperature)
      lattice = obj.lattices(temperature);
      if strcmp(obj.initial_condition, 'spin-up')
        C = lattice.spin_up_initial_C();
        T = lattice.spin_up_initial_T();
      elseif strcmp(obj.initial_condition, 'symmetric')
        error('I do not know these boundary conditions yet.')
      end
    end
  end

  methods(Abstract)
    run(obj)
  end

  methods(Static)
    % I put grow_lattice in a separate file grow_lattice.m with helper functions, so I have
    % to declare it here in order to make it Static (otherwise it would be public).
    % [C, T, singular_values, truncation_error, full_singular_values] = grow_lattice(temperature, chi, C, T);

    function s = initial_singular_values(chi)
      s = ones(chi, 1) / chi;
    end

    function c = calculate_convergence(singular_values, singular_values_old, chi)
      % TODO: something weird happened last time: when calculating correlation length
      % for T >> Tc, I found that the T tensor did not have the right dimension.

      % Sometimes it happens that the current singular values vector is smaller
      % than the old one, because MATLAB's svd procedure throws away excessively
      % small singular values. The code below adds zeros to singular_values to match
      % the dimension of singular_values_old.
      if size(singular_values, 1) < chi
        singular_values(chi) = 0;
      end

      % If chi_init is small enough, the bond dimension of C and T will not exceed
      % chi for the first few steps.
      if size(singular_values_old, 1) < chi
        singular_values_old(chi) = 0;
      end

      c = sum(abs(singular_values - singular_values_old));
    end

    function truncation_error = truncation_error()
      truncation_error = 42;
    end
  end
end
