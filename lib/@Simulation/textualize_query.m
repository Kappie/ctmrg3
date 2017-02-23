function text = textualize_query(obj, query, varargin)
  % replace all question marks with string format spec
  query = strrep(query, '?', '%s');
  % convert all arguments to string type (arguments that are already strings are unchanged)
  varargin = cellfun(@(argument) convert_argument_to_text(argument, obj.significant_digits), varargin, 'UniformOutput', false);
  % format query. {:} expands argument list
  text = sprintf(query, varargin{:});

  % force query to end in semicolon
  if ~strcmp(text(end), ';')
    text(end+1) = ';';
  end
end

function text = convert_argument_to_text(argument, precision)
  % If argument is numeric, just convert to string
  if isnumeric(argument)
    text = num2str(argument, precision);
  % If argument is already a string, it needs to be wrapped in double quotes
  % to be valid sqlite.
  elseif ischar(argument)
    text = ['"' argument '"'];
  else
    display(['Cannot guess type of argument' num2str(argument)]);
    text = num2str(argument, precision);
  end
end
