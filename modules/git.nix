{ config, pkgs, ... }:

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
}
