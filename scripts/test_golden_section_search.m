function test_golden_section_search
  function y = f(x)
    p_undefined = 0.7;
    if rand < p_undefined
      y = 'undefined';
    else
      y = -x * (x - 1);
    end
  end

  [f_max, x_max] = golden_section_search_with_undefined_points(@f, 0, 1, 1e-7)
end
