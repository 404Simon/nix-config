{ config, pkgs, ... }:

let
  wallpaperConfig = import ./wallpaper-config.nix;
  scriptsDir = "${config.home.homeDirectory}/nix-config/resources/shell/scripts";
in
{
  programs.zsh = {
    enable = true;

    history = {
      path = "${config.home.homeDirectory}/.zsh_history";
      size = 1000000;
      save = 1000000;
      share = true;
      extended = true;
      expireDuplicatesFirst = true;
    };

    completionInit = ''
      autoload -Uz compinit
      compinit

      zstyle ':completion:*' matcher-list \
        'm:{a-z}={A-Za-z} r:|=*' \
        'm:{a-z}={A-Za-z} l:|=* r:|=*'

      zstyle ':completion:*' menu select=1
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # Ignore patterns for vim/nvim
      zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.pdf' '*.class'
      zstyle ':completion:*:*:nvim:*:*files' ignored-patterns '*.pdf' '*.class'
    '';

    initContent = ''
      setopt inc_append_history

      # -------------------------------------------------------------
      # Custom Tab Completion for .. -> ../
      # -------------------------------------------------------------
      insert-slash-if-dotdot() {
        if [[ ''${LBUFFER: -2} == '..' ]]; then
          LBUFFER+='/'
        else
          zle expand-or-complete
        fi
      }

      zle -N insert-slash-if-dotdot
      bindkey '^I' insert-slash-if-dotdot

      # -------------------------------------------------------------
      # Custom Functions
      # -------------------------------------------------------------

      # Weather function
      function weather() {
          location="''${*:-Erlangen}"
          location="''${location// /+}"
          curl -s "wttr.in/$location" | sed '1d;$d;$d'
      }

      # Open function with completion
      op() {
          xdg-open "$@" >/dev/null 2>&1 &
          disown
      }
      compdef '_files -g "*.(pdf|PDF|epub)"' op

      slug() {
        local s="$(wl-paste)"
        s="$(echo "$s" | sed 's/[^a-zA-Z0-9_-]/_/g;s/__*/_/g;s/^_//;s/_$//')"
        echo -n "$s" | wl-copy
        echo "$s"
      }

      function anki() {
          if ! pgrep anki > /dev/null; then
              hyprctl dispatch exec "[workspace 8] anki"
          fi
          for i in $(seq 1 30); do
              ss -tln 2>/dev/null | grep -q :3141 && break
              echo "waiting for Anki MCP server..."
              sleep 1
          done
          opencode --agent anki "$@"
      }

      # Laravel completions
      eval $(laravel completion)

      # Typst completions
      eval "$(typst completions zsh)"

      # Vesskel completions
      eval "$(vesskel completions zsh)"
    '';

    shellAliases = {
      t = "tmux a || tmux";
      y = "yazi";
      g = "lazygit";
      fzf = "fzf --tmux 80%,80%";
      ls = "eza --color=always --icons=always";
      pp = "pnpm";
      mm = "/home/simon/dev/musicmatch/.venv/bin/musicmatch";
      artisan = "php artisan";
      pint = "./vendor/bin/pint";
      stan = "./vendor/bin/phpstan";
      pest = "./vendor/bin/pest";
      rector = "./vendor/bin/rector";
      sail = "./vendor/bin/sail";
      db = "lazysql \"file:database/database.sqlite?loc=auto\"";

      dev = "eval \"$(${scriptsDir}/projectnavigator.sh)\"";
      v = "eval \"$(${scriptsDir}/vorlesungsnavigator.sh)\"";
      m = "eval \"$(${scriptsDir}/musicnavigator.sh)\"";
      o = "cd \"$OBSIDIAN_VAULT\" && nvim";

      blog = "~/dev/quartz/automation.sh";
      lyrics = "${scriptsDir}/lyric_search.py";
      plz = "${scriptsDir}/plz.sh";
      song = "${scriptsDir}/song.sh";
      jo = "cd /home/simon/dev/VesSkel";
      napari = "~/dev/VesSkel/.venv/bin/napari";

      c = "calcure";
      n = "newsboat";
      r = "rmpc";

      suspend = "systemctl suspend";
      open = "xdg-open";
      todo = "vim ~/Vorlesungen/TODO.md";
      b = "bg && disown";
      winfo = "WALLPAPER_DIR=\"$WALLPAPER_DIR\" WALLPAPER_HISTORY_LOG=\"$WALLPAPER_HISTORY_LOG\" /home/simon/dev/wallpaper_slideshow/target/release/wallpaper-info";
      shutdown = "pangolin down; systemctl poweroff";
      reboot = "pangolin down; systemctl reboot";
      gaming = "ssh xmg.server \"wakeonlan 88:d7:f6:7a:5d:eb\"";
      dnd = "if [ \"$(makoctl mode)\" = \"do-not-disturb\" ]; then makoctl mode -s default; else makoctl mode -s do-not-disturb; fi";
      luft = "${scriptsDir}/airpods.sh";
      bib = "hyprctl keyword monitor DP-2,2560x1440@74.99,0x0,1";

      timer = "${scriptsDir}/timer.sh";
    };
  };

  # ============================================================================
  # Environment Variables
  # ============================================================================
  home.sessionVariables = {
    EDITOR = "nvim";
    OBSIDIAN_VAULT = "/home/simon/obsidian-vault/";

    FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
    FZF_CTRL_T_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
    FZF_ALT_C_COMMAND = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
    FZF_DEFAULT_OPTS = "--color=fg:#CBE0F0,bg:#011628,hl:#B388FF,fg+:#CBE0F0,bg+:#143652,hl+:#B388FF,info:#06BCE4,prompt:#2CF9ED,pointer:#2CF9ED,marker:#2CF9ED,spinner:#2CF9ED,header:#2CF9ED";

    JAVA_HOME = "$HOME/.jdks/selected_java/java";
    GRAAL_HOME = "$HOME/.jdks/selected_java/java";
    GRAALVM_HOME = "$HOME/.jdks/selected_java/java";

    # Wallpaper configuration
    WALLPAPER_DIR = "${wallpaperConfig.wallpaperDir}";
    WALLPAPER_HISTORY_LOG = "${wallpaperConfig.wallpaperHistoryLog}";
    WALLPAPER_CACHE_DB = "${wallpaperConfig.wallpaperCacheDb}";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.composer/vendor/bin"
    "$HOME/.config/composer/vendor/bin"
    "$HOME/.jdks/selected_java/java/bin"
    scriptsDir
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
    fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git";

    changeDirWidgetOptions = [ "--preview 'eza --tree --color=always {}'" ];
    fileWidgetOptions = [ "--preview 'bat --color=always {}'" ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "always";
    git = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "tokyonight_night";
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "matcha-dark-sea";
    };
  };

  # Copy custom theme
  xdg.configFile."bat/themes/tokyonight_night.tmTheme".source =
    ../resources/bat/tokyonight_night.tmTheme;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = false;
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "~/dev" = "δ";
          "dotfiles" = "⚙ ";
          "nix-config" = "";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };

      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };

      nodejs = {
        symbol = "";
        detect_files = [ "package.json" ];
        detect_extensions = [
          "mjs"
          "cjs"
          "ts"
          "mts"
          "cts"
        ];
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      php = {
        symbol = "🐘";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      python = {
        symbol = "🐍";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      time = {
        disabled = true;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };

      direnv = {
        disabled = false;
        style = "bg:#212736";
        format = "[[ $symbol: $loaded/$allowed ](fg:#769ff0 bg:#212736)]($style)";
      };
    };
  };
}
