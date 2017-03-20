function my_test(x1, y1, z1, varargin)
  if exist('x1', 'var')
    display('x bestaat')
  end
  if exist('z1', 'var')
    display('z bestaat')
  end

  display(varargin(1:end))
end
