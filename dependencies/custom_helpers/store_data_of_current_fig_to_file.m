function store_data_of_current_fig_to_file(filename)
  % Get data vectors of current figure
  lines = findobj(gca,'Type','line')
  file_id = fopen(filename, 'w');

  for line = lines'
    x = line.XData;
    y = line.YData;
    fprintf(file_id, '%3g %3g\n', [x; y]);
    % Write two blank lines for gnuplot to recognize the next plot as separate.
    fprintf(file_id, '\n\n');
  end

  fclose(file_id);

  type(filename)
end
