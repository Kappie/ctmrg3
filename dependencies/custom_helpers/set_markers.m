function set_markers(handles, line_style)
  MARKERS = markers();
  for i = 1:numel(handles)
    marker_index = mod(i - 1, numel(MARKERS)) + 1;
    set(handles(i), 'marker', MARKERS(marker_index), 'LineStyle', line_style);
  end
end
