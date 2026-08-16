{ pkgs, lib, ... }:
let
  laravelSrc = pkgs.fetchFromGitHub {
    owner = "adalessa";
    repo = "laravel.nvim";
    rev = "c0b171c8f9f0b5914f12b197711b93aa2c4047d3";
    sha256 = "1ssjnvr07ncyns9dchvlafksw21wb0801dhfgnzz863sn34v51j2";
  };

  mcphubSrc = pkgs.fetchFromGitHub {
    owner = "ravitemer";
    repo = "mcphub.nvim";
    rev = "7cd5db330f41b7bae02b2d6202218a061c3ebc1f";
    sha256 = "009w7iq31k9sx94p3izqnjbgi0gr9fwn7p5wjcaa3kz16jz4znw3";
  };
in
{
  extraFiles = {
    "lua/utils/laravel.lua".source = ../lua/utils/laravel.lua;
  };

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "laravel.nvim";
      src = laravelSrc;
      doCheck = false;
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "mcphub.nvim";
      src = mcphubSrc;
      doCheck = false;
    })
    pkgs.vimPlugins.vim-dotenv
    pkgs.vimPlugins.nvim-nio
    pkgs.vimPlugins.plenary-nvim
  ];

  plugins.nui.enable = true;

  extraConfigLua = ''
    require("utils.laravel").setup()
  '';
}
