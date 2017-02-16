function my_export_fig(filename, scriptname, save_to_thesis_plots_folder)
  if nargin == 2
    save_to_thesis_plots_folder = false;
  end

  full_path = fullfile(Constants.PLOTS_DIR, filename);
  export_fig(full_path);

  [~, name, extension] = fileparts(filename);
  % Also save figure as .fig so I can edit it later.
  % matlab_figure_filename = [name, '.fig'];
  % matlab_figures_path = fullfile(Constants.PLOTS_DIR, 'matlab_figures', matlab_figure_filename);
  % savefig(matlab_figures_path);

  % Also save as tikz figure
  tikz_figure_filename = [name, '.tikz'];
  tikz_figure_path = fullfile(Constants.PLOTS_DIR, 'latex_figures', tikz_figure_filename);
  % matlab2tikz(tikz_figure_path, 'height', '\figureheight', 'width', '\figurewidth');
  matlab2tikz(tikz_figure_path);

  if save_to_thesis_plots_folder
    thesis_plots_path = fullfile(Constants.THESIS_PLOTS_DIR, tikz_figure_filename);
    copyfile(tikz_figure_path, thesis_plots_path);
  end

  % also save a copy of the script that generated the plot,
  % for reproducibility later.
  script_backup_dir = fullfile(Constants.PLOTS_DIR, 'matlab_scripts');
  % The name of the script is the same as the plot that it generated
  script_backup_name = [name, '.m'];
  script_backup_path = fullfile(script_backup_dir, script_backup_name);
  script_path = fullfile(Constants.BASE_DIR, 'scripts', scriptname);
  copyfile(script_path, script_backup_path);
  append_date(script_backup_path)
end

function append_date(filename)
  % append as matlab comment. Double percent is there so that
  % fprintf writes a raw percent sign. (instead of interpreting it as some operator)
  date_string = ['%% generated plot at ' datestr(now)];

  file_id = fopen(filename, 'a');
  fprintf(file_id, date_string)
  fclose(file_id);
end
