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
  ];

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
      core.pager = "less -FRX";
    };
  };
}
