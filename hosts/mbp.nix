{ ... }:

{
  home = {
    stateVersion = "22.11";

    username = "joseph";
    homeDirectory = "/Users/joseph";

    file.".config/skhd".source = ../config/skhd;
    file.".config/yabai".source = ../config/yabai;
    file.".config/sketchybar".source = ../config/sketchybar;
  };

  programs.git = {
    userEmail = "joseph@guilded.gg";

    aliases = {
      delete-squashed = ''
        !f() { local targetBranch=''${1:-master} && git checkout -q $targetBranch && git branch --merged | grep -v "\*" | xargs -n 1 git branch -d && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base $targetBranch $branch) && [[ $(git cherry $targetBranch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done; }; f'';
      echo-squashed = ''
        !f() { local targetBranch=''${1:-master} && git checkout -q $targetBranch && git branch --merged | grep -v "\*" | xargs -n 1 git branch -d && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base $targetBranch $branch) && [[ $(git cherry $targetBranch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && echo git branch -D $branch; done; }; f'';
    };
  };

  programs.zsh.shellAliases = {
    "sketchybar-start" = "tmux new-session -d -s sketchybar sketchybar";
  };
  programs.zsh.initExtra = ''
    # Global config for non-nix project which expects brew + nvm + ruby
    eval "$(/opt/homebrew/bin/brew shellenv)"

    export PATH=$(brew --prefix ruby)/bin:/Users/joseph/.local/share/gem/ruby/3.2.0/bin:$PATH

    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

    function notify() {
      # Run the command passed as arguments
      "$@"

      # Create a desktop notification
      terminal-notifier -title "Task Finished" -message "$1 completed" -sound "Submarine"
    }
  '';
}
