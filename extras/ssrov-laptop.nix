{pkgs, ...}: {
  users.users.tao.packages = with pkgs; [
    (python311Full.withPackages (ps:
      with ps; [
        # bokeh
        # datashader
        # hvplot
        # ipywidgets
        # ipywidgets
        # jupyter
        # linkify-it-py
        # markdown-it-py
        # mdit-py-plugins
        # nbclient
        # numpy
        # pandas
        # panel
        # plotly
        # pyparsing
        # pyserial
        # scikit-learn
        # scipy
        # streamz
        # tkinter
        jupyter

        # pyserial
        bokeh
        datashader
        hvplot
        # ipython_blocking
        ipywidgets
        nbclient
        numpy
        pandas
        panel
        plotly
        pyparsing
        scikit-learn
        scipy
        streamz

        tkinter
        linkify-it-py
        markdown-it-py
        mdit-py-plugins
      ]))
  ];
}
