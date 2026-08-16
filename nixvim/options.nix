{ lib, ... }:

{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
    have_nerd_font = true;
  };

  opts = {
    expandtab = true;
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;

    clipboard = "unnamedplus";
    swapfile = false;

    number = true;
    relativenumber = true;
    cursorline = true;

    mouse = "a";
    showmode = false;
    breakindent = true;
    undofile = true;

    ignorecase = true;
    smartcase = true;

    signcolumn = "yes";
    updatetime = 250;
    timeoutlen = 300;

    splitright = true;
    splitbelow = true;

    list = true;
    listchars = {
      tab = "» ";
      trail = "·";
      nbsp = "␣";
    };

    inccommand = "split";
    scrolloff = 10;
    hlsearch = true;
  };

  # tmux-navigator owns <C-h>/<C-j>/<C-k>/<C-l>; no plain window navigation mappings.
  keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlight";
    }
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
      options.desc = "Go to previous [D]iagnostic message";
    }
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
      options.desc = "Go to next [D]iagnostic message";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      options.desc = "Show diagnostic [E]rror messages";
    }
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }
  ];

  autoGroups.highlight-yank = {
    clear = true;
  };

  autoCmd = [
    {
      event = "TextYankPost";
      group = "highlight-yank";
      desc = "Highlight when yanking (copying) text";
      callback.__raw = "function() vim.highlight.on_yank() end";
    }
  ];
}
