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

  reloadHomeManagerPrefix = if pkgs.stdenv.hostPlatform.isDarwin then "sudo darwin-rebuild" else "home-manager";
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

    def set_top_level_value(text, key, value):
        first_table = re.search(r"(?m)^\[", text)
        root_end = first_table.start() if first_table else len(text)
        root = text[:root_end]
        remainder = text[root_end:]
        pattern = rf"(?m)^{re.escape(key)}\s*=.*$"

        if re.search(pattern, root):
            root = re.sub(pattern, f"{key} = {value}", root)
        else:
            if root and not root.endswith("\n"):
                root += "\n"
            root += f"{key} = {value}\n"

        return root + remainder


    def remove_top_level_value(text, key):
        first_table = re.search(r"(?m)^\[", text)
        root_end = first_table.start() if first_table else len(text)
        root = text[:root_end]
        remainder = text[root_end:]
        pattern = rf"(?m)^{re.escape(key)}\s*=.*(?:\n|$)"

        return re.sub(pattern, "", root) + remainder


    def set_table_value(text, table, key, value):
        header = re.compile(rf"(?m)^\[{re.escape(table)}\]\s*$")
        match = header.search(text)

        if match is None:
            if text and not text.endswith("\n"):
                text += "\n"
            if text:
                text += "\n"
            return text + f"[{table}]\n{key} = {value}\n"

        next_header = re.search(r"(?m)^\[", text[match.end():])
        section_end = match.end() + next_header.start() if next_header else len(text)
        section = text[match.start():section_end]
        pattern = rf"(?m)^{re.escape(key)}\s*=.*$"

        if re.search(pattern, section):
            section = re.sub(pattern, f"{key} = {value}", section)
        else:
            if not section.endswith("\n"):
                section += "\n"
            section += f"{key} = {value}\n"

        return text[:match.start()] + section + text[section_end:]


    text = remove_top_level_value(text, "sandbox_mode")
    text = set_top_level_value(text, "approval_policy", '"never"')
    text = set_top_level_value(text, "default_permissions", '"workspace-with-git"')
    text = set_table_value(text, "permissions.workspace-with-git", "extends", '":workspace"')
    text = set_table_value(text, "permissions.workspace-with-git.network", "enabled", "true")
    text = set_table_value(
        text,
        'permissions.workspace-with-git.filesystem.":workspace_roots"',
        '".git"',
        '"write"',
    )
    text = set_table_value(text, "tui", "vim_mode_default", "true")

    if re.search(r"(?m)^hooks\s*=", text):
        text = re.sub(r"(?m)^hooks\s*=.*$", "hooks = true", text)
        text = re.sub(r"(?m)^codex_hooks\s*=.*(?:\n|$)", "", text)
    elif re.search(r"(?m)^codex_hooks\s*=", text):
        text = re.sub(r"(?m)^codex_hooks\s*=.*$", "hooks = true", text)
    elif re.search(r"(?m)^\[features\]\s*$", text):
        text = re.sub(r"(?m)^(\[features\]\s*$)", r"\1\nhooks = true", text, count=1)
    else:
        if text and not text.endswith("\n"):
            text += "\n"
        if text:
            text += "\n"
        text += "[features]\nhooks = true\n"

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
    (import ./files/default.nix { inherit dotfiles config pkgs; })
    # (import ./programs.nix { inherit config lib pkgs dotfiles; })
    (import ./programs.nix)
  ];
}
