{ config, pkgs-unstable, ... }:

{
  xdg.configFile."opencode/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/resources/opencode/skills";

  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;

    settings = {
      theme = "tokyonight";

      autoupdate = false;

      mcp = {
        context7 = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@upstash/context7-mcp"
          ];
          enabled = true;
        };

        medical-mcp = {
          type = "local";
          command = [
            "node"
            "/home/simon/dev/medical-mcp/build/index.js"
          ];
          enabled = false;
        };

        anki = {
          type = "remote";
          url = "http://127.0.0.1:3141/";
          enabled = true;
        };

        zotero-mcp = {
          type = "local";
          command = [
            "/home/simon/dev/zotero-mcp/.venv/bin/python"
            "/home/simon/dev/zotero-mcp/src/main.py"
          ];
          enabled = true;
        };
        nixos = {
          type = "local";
          command = [
            "nix"
            "run"
            "github:utensils/mcp-nixos"
            "--"
          ];
        };
      };

      agent = {
        typster = {
          description = ''
            Use this agent when you need to create, edit, format, or improve Typst documents.
            Typst is a modern markup language for typesetting beautiful professional documents.
          '';
          mode = "all";
          prompt = builtins.readFile ../resources/opencode/agents/typster.md;
        };

        anki = {
          description = ''
            Use this agent when you need to create, edit, or manage Anki flashcards from lecture slides.
            It extracts text from PDFs using pdftotext and creates well-structured cards following established conventions.
          '';
          mode = "all";
          prompt = builtins.readFile ../resources/opencode/agents/anki.md;
        };
      };
    };
  };
}
