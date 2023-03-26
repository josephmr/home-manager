{ pkgs, config, ... }:

{
  imports = [ ./modules/emacs.nix ];

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    overmind
    ripgrep
    httpie
    jq
    wget
    bat
    exa
    delta
    du-dust
    duf
    choose
    glances
  ];

  xdg.enable = true;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  modules.emacs.enable = true;

  programs.git = {
    enable = true;
    userName = "Joseph Rollins";
    extraConfig = {
      # TODO: Might still need this for work, but it breaks doom
      # install `home.activation` script.
      # https://discourse.nixos.org/t/home-manager-home-activation-access-to-packages-in-home-packages/26732
      url = {
        "ssh://git@github.com/" = { insteadOf = "https://github.com/"; };
        "https://github.com/" = { insteadOf = "gh:"; };
      };
      github.user = "josephmr";
      core.excludesfile = "${config.home.homeDirectory}/.gitignore";
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden";
    fileWidgetCommand = "rg --files --hidden";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;

    keyMode = "vi";
    newSession = true;
    terminal = "screen-256color";

    plugins = with pkgs; [ tmuxPlugins.vim-tmux-navigator ];

    extraConfig = ''
      set -g pane-border-status top
      set -g pane-active-border-style "bg=#28E945"
    '';
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "";
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "v1.21.0";
          hash = "sha256-YfasTKCABvMtncrfoWR1Su9QxzCqPED18/BTXaJHttg=";
        };
      }
    ];
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      save = 40000;
      size = 40000;
      share = true;
    };
    shellAliases = {
      emacsd = "emacs --daemon";
      emacsc = "emacsclient -nc";
      cat = "bat";
    };
    initExtra = ''
      autoload -U promptinit; promptinit
      prompt pure

      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
        . $HOME/.nix-profile/etc/profile.d/nix.sh
      fi

      # Set the title of tmux panes to the running command entered.
      # This differes from pane_current_command as that outputs the running command name
      # without arguments. Which also follows aliases (e.g. alias foo=node) would show node
      # not foo.
      function set_tmux_title() {
        if [ "$TERM" != "screen-256color" ]; then
          return
        fi

        printf '\033]2;%s\033\\' "$1"
      }

      preexec_functions+=(set_tmux_title)

      function ssh-check-agent() {
        if [ ! -S $HOME/.ssh/ssh_auth_sock ]; then
          eval `ssh-agent` > /dev/null
          ln -sf "$SSH_AUTH_SOCK" $HOME/.ssh/ssh_auth_sock
        fi
        export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
        ssh-add -l > /dev/null || rg -l "PRIVATE" ~/.config/ssh | xargs -I {} ssh-add {} 2> /dev/null
      }

      ssh-check-agent
    '';
  };
}
