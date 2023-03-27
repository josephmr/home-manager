{ ... }:

{
  imports = [ ../modules/git.nix ];

  home = {
    stateVersion = "22.11";

    username = "jrollins";
    homeDirectory = "/Users/jrollins";
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

  programs.zsh.initExtra = ''
    # Global config for non-nix project which expects brew + nvm + ruby
    # TODO try to remove needing these globally
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
    export PATH=$(brew --prefix ruby)/bin:$(brew --prefix)/lib/ruby/gems/3.1.0/bin:$PATH
  '';
}
