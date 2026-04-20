# Main user-level configuration
{
  config,
  pkgs,
  lib,
  user,
  host,
  hardware,
  system,
  dotfiles,
  stateVersion,
  isOther,
  ...
}:

let
  homeDirectoryPrefix = if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
  dotfilePath = "${homeDirectoryPrefix}/${user}/environment/dotfiles";
  _reloadHomeManagerSuffix = "switch --flake ~/environment#$USER-$NIX_HOST-$HARDWARE-$ARCH";

  reloadHomeManagerSuffix =
    if isOther then _reloadHomeManagerSuffix + " -b hm-backup" else _reloadHomeManagerSuffix;

  reloadHomeManagerPrefix = if pkgs.stdenv.isDarwin then "sudo darwin-rebuild" else "home-manager";
in
{

  home = {
    username = user;
    homeDirectory = "${homeDirectoryPrefix}/${user}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = stateVersion;

    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      NIX_HOST = host;
      HARDWARE = hardware;
      ARCH = system;
      EDITOR = "vim";
      LESS = "-eirMX";
      RELOAD_PREFIX = "${reloadHomeManagerPrefix}";
      RELOAD_SUFFIX = "${reloadHomeManagerSuffix}";
    };
    shellAliases = {
      reload-home-manager-config = "${reloadHomeManagerPrefix} ${reloadHomeManagerSuffix}";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 29d";
  };

  home.activation.merge-claude-settings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    claude_dir="$HOME/.claude"
    settings="$claude_dir/settings.json"
    dotfile_settings="${dotfilePath}/agents/claude/settings.json"

    if [ -f "$dotfile_settings" ]; then
      mkdir -p "$claude_dir"
      if [ -f "$settings" ]; then
        # Deep merge dotfile settings into existing settings (dotfile values win on conflict)
        ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$settings" "$dotfile_settings" > "$settings.tmp" \
          && mv "$settings.tmp" "$settings"
      else
        cp "$dotfile_settings" "$settings"
      fi
    fi
  '';

  home.activation.merge-codex-config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        codex_dir="$HOME/.codex"
        config="$codex_dir/config.toml"

        mkdir -p "$codex_dir"

        ${pkgs.python3}/bin/python3 - "$config" <<'PY'
    from pathlib import Path
    import re
    import sys

    path = Path(sys.argv[1])
    text = path.read_text(encoding="utf-8") if path.exists() else ""

    if re.search(r"(?m)^codex_hooks\s*=", text):
        text = re.sub(r"(?m)^codex_hooks\s*=.*$", "codex_hooks = true", text)
    elif re.search(r"(?m)^\[features\]\s*$", text):
        text = re.sub(r"(?m)^(\[features\]\s*$)", r"\1\ncodex_hooks = true", text, count=1)
    else:
        if text and not text.endswith("\n"):
            text += "\n"
        if text:
            text += "\n"
        text += "[features]\ncodex_hooks = true\n"

    path.write_text(text, encoding="utf-8")
    PY
  '';

  home.activation.merge-codex-hooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        codex_dir="$HOME/.codex"
        hooks="$codex_dir/hooks.json"
        dotfile_hooks="${dotfilePath}/agents/codex/hooks.json"

        if [ -f "$dotfile_hooks" ]; then
          mkdir -p "$codex_dir"
          if [ -f "$hooks" ]; then
            ${pkgs.python3}/bin/python3 - "$hooks" "$dotfile_hooks" <<'PY'
    import json
    import sys
    from pathlib import Path


    def merge_value(existing, incoming):
        if existing is None:
            return incoming
        if incoming is None:
            return existing
        if isinstance(existing, dict) and isinstance(incoming, dict):
            merged = {}
            for key in dict.fromkeys([*existing.keys(), *incoming.keys()]):
                merged[key] = merge_value(existing.get(key), incoming.get(key))
            return merged
        if isinstance(existing, list) and isinstance(incoming, list):
            merged = list(existing)
            for item in incoming:
                if item not in merged:
                    merged.append(item)
            return merged
        return incoming


    hooks_path = Path(sys.argv[1])
    dotfile_hooks_path = Path(sys.argv[2])

    existing = json.loads(hooks_path.read_text(encoding="utf-8"))
    incoming = json.loads(dotfile_hooks_path.read_text(encoding="utf-8"))
    merged = merge_value(existing, incoming)

    hooks_path.write_text(json.dumps(merged, indent=2) + "\n", encoding="utf-8")
    PY
          else
            cp "$dotfile_hooks" "$hooks"
          fi
        fi
  '';

  imports = [
    # program and dotfile installation/setup
    (import ./files/default.nix { inherit dotfiles config; })
    # (import ./programs.nix { inherit config lib pkgs dotfiles; })
    (import ./programs.nix)
  ];
}
