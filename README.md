# Home Manager Config

## Pre Requisites

1. Install [nix](https://nixos.org/download.html)
2. Clone repo to `~/.config/home-manager` and cd
3. Might need git ssh keys configured...
4. Home Manager switch
    ```
    nix-shell -p home-manager
    home-manager switch --flake .#<user>@<host>
    ```