function my_export_fig(filename, scriptname)
  full_path = fullfile(Constants.PLOTS_DIR, filename);
  export_fig(full_path);

  % Also save figure as .fig so I can edit it later.
  [~, name, extension] = fileparts(filename);
  matlab_figure_filename = [name, '.fig'];
  matlab_figures_path = fullfile(Constants.PLOTS_DIR, 'matlab_figures', matlab_figure_filename);
  savefig(matlab_figures_path);

  % Also save as tikz figure
  tikz_figure_filename = [name, '.tex'];
  tikz_figures_path = fullfile(Constants.PLOTS_DIR, 'latex_figures', tikz_figure_filename);
  matlab2tikz(tikz_figures_path, 'height', '\fheight', 'width', '\fwidth');
  % matlab2tikz(tikz_figures_path);

  % also save a copy of the script that generated the plot,
  % for reproducibility later.
  script_backup_dir = fullfile(Constants.PLOTS_DIR, 'matlab_scripts');
  script_path = fullfile(Constants.BASE_DIR, 'scripts', scriptname);
  copyfile(script_path, script_backup_dir);
end
