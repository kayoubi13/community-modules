# home-manager

Integrates [home-manager](https://github.com/nix-community/home-manager) into finix, allowing per-user declarative dotfile and package management without requiring a full NixOS home-manager integration.

Home-manager runs as a finit task (`hm-activate-<user>`) after the nix daemon is ready, applying the user's home configuration on each boot.

> [!NOTE]
> Home-manager user services are not supported on finix as there is no systemd user session. Only `home.packages`, `home.file`, and program configuration options are usable.

## Usage

```nix
{ inputs, ... }:
{
  imports = [ inputs.community-modules.nixosModules.home-manager ];

  home-manager.users.alice = {
    home.username = "alice";
    home.homeDirectory = "/home/alice";
    home.stateVersion = "24.11";

    programs.helix.enable = true;
  };
}
```

## Options

| Option                              | Type             | Default | Description                                                                                                                                              |
| ----------------------------------- | ---------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `home-manager.users`                | `attrsOf <user>` | `{}`    | Per-user home-manager configurations.                                                                                                                    |
| `home-manager.enableProfileInstall` | `bool`           | `true`  | Whether to run `nix profile install` during activation. Set to `false` when `/nix/store` is read-only (e.g. in QEMU VMs that bind-mount the host store). |

## Notes

The nix daemon is automatically enabled when any users are configured.

In finix VMs where `/nix/store` is a read-only bind mount, set `home-manager.enableProfileInstall = false`. Packages remain accessible via the system closure regardless.
