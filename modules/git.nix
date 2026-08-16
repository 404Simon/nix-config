{
  pkgs-unstable,
  ...
}:

{
  programs.git = {
    enable = true;

    signing = {
      key = "s.wi@mail.de";
      signByDefault = true;
    };

    settings = {

      user = {
        name = "404Simon";
        email = "s.wi@mail.de";
      };

      core = {
        editor = "nvim";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      tag = {
        gpgSign = true;
      };
    };
  };
  programs.lazygit.enable = true;
  programs.gh.enable = true;
  programs.gh.extensions = [
    pkgs-unstable.gh-dash
  ];
  # gh-dash: force an explicit launcher so browser.New uses the io.Discard path
  # instead of the cli/browser fallback that leaks xdg-open output (fontconfig
  # warnings) into the TUI. See dlvhdr/gh-dash#942, #410.
  programs.gh.settings.browser = "xdg-open";
  programs.gh-dash.enable = true;
  programs.gh-dash.package = pkgs-unstable.gh-dash;
  programs.gh-dash.settings = {
    prSections = [
      {
        title = "My Repos";
        filters = "is:open user:@me";
      }
      {
        title = "My Pull Requests";
        filters = "is:open author:@me";
      }
      {
        title = "Needs My Review";
        filters = "is:open review-requested:@me";
      }
      {
        title = "Involved";
        filters = "is:open involves:@me -author:@me";
      }
    ];
  };
}
