function text = textualize_query(query, varargin)
  % replace all question marks with string format spec
  query = strrep(query, '?', '%s');
  % convert all arguments to string type (arguments that are already strings are unchanged)
  varargin = cellfun(@num2str, varargin, 'UniformOutput', false);
  % format query. {:} expands argument list
  text = sprintf(query, varargin{:});

  % force query to end in semicolon
  if ~strcmp(text(end), ';')
    text(end+1) = ';';
  end
end
