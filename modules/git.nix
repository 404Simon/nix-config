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
      merge = {
        conflictStyle = "zdiff3";
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
  programs.delta = {
    enable = true;
    # Delta >= 0.20 speaks lazygit's OSC 1717 metadata protocol, which lets the
    # delta-rendered diff stay on screen when the main view is focused.
    package = pkgs-unstable.delta;
    # Sets core.pager and interactive.diffFilter in git config.
    enableGitIntegration = true;
    options = {
      navigate = true;
      "line-numbers" = true;
      "syntax-theme" = "tokyonight_night";
    };
  };
  programs.lazygit = {
    enable = true;
    # `diffRenderers` requires lazygit >= 0.66; nixpkgs stable still ships 0.56.
    package = pkgs-unstable.lazygit;
    settings = {
      git.diffRenderers = [
        # Lazygit doesn't read git's pager config, so delta must be set explicitly.
        # Hunk headers are redundant with line numbers here, and the boxed
        # decoration looks odd inside lazygit's border.
        {
          command = "delta --{{colorScheme}} --paging=never --line-numbers --hunk-header-style=omit";
        }
      ];
      # Focusing a diff would otherwise switch to lazygit's raw hunk-selection
      # view, which cannot use delta. Toggle that view with `a` when needed.
      gui.useHunkModeInDiffView = false;
    };
  };
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
