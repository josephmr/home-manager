# Home Manager Config

## Known Manual Steps

- Manually download SSH pub/private keys

### Linux

- Need to add the following to `~/.profile` or similar depending on distribution
  or i3 rofi commands won't pick up desktop files from XDG_DATA_DIRS:

    ``` sh
    if [ -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
    . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
    fi
    ```


## Pre Requisites

1. Install [nix](https://nixos.org/download.html)
2. Clone repo to `~/.config/home-manager` and cd
4. Home Manager switch
    ```
    nix-shell -p home-manager
    home-manager switch --flake .#<user>@<host>
    ```
