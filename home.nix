{ pkgs, config, ... }:

{
  home.username = "jrollins";
  home.homeDirectory = "/Users/jrollins";

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
    '';
  };

  programs.tmux = {
    enable = true;

    keyMode = "vi";
    newSession = true;
    terminal = "screen-256color";

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
    ];

    extraConfig = ''
      set -g pane-border-status top
      set -g pane-active-border-style "bg=#28E945"
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden";
    fileWidgetCommand = "rg --files --hidden";
  };

  programs.git = {
    enable = true;

    userEmail = "joseph@guilded.gg";
    userName = "Joseph Rollins";

    aliases = {
      delete-squashed = "!f() { local targetBranch=\${1:-master} && git checkout -q $targetBranch && git branch --merged | grep -v \"\\*\" | xargs -n 1 git branch -d && git for-each-ref refs/heads/ \"--format=%(refname:short)\" | while read branch; do mergeBase=$(git merge-base $targetBranch $branch) && [[ $(git cherry $targetBranch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == \"-\"* ]] && git branch -D $branch; done; }; f";
      echo-squashed = "!f() { local targetBranch=\${1:-master} && git checkout -q $targetBranch && git branch --merged | grep -v \"\\*\" | xargs -n 1 git branch -d && git for-each-ref refs/heads/ \"--format=%(refname:short)\" | while read branch; do mergeBase=$(git merge-base $targetBranch $branch) && [[ $(git cherry $targetBranch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == \"-\"* ]] && echo git branch -D $branch; done; }; f";
    };

    extraConfig = {
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
      github.user = "josephmr";
      core.excludesfile = "${config.home.homeDirectory}/.gitignore";

      # Use delta for diffs
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
}
