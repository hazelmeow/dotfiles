{ pkgs, inputs, lib, config, ... }:

let
  exts = inputs.nix-vscode-extensions.extensions.${pkgs.system};

  # TODO: this seems kinda brittle
  vscodeCfg = config.programs.vscode;
  vscodePname = vscodeCfg.package.pname;
  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
    "openvscode-server" = "OpenVSCode Server";
  }.${vscodePname};
  userDir = "${config.xdg.configHome}/${configDir}/User";
  snippetDir = "${userDir}/snippets";

  snippetFiles = builtins.filter (f: f != "package.json") (
    builtins.attrNames (builtins.readDir ../snippets)
  );
in {
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = [
        exts.vscode-marketplace.mkhl.direnv
        exts.vscode-marketplace.sainnhe.everforest
        exts.vscode-marketplace.esbenp.prettier-vscode
        exts.vscode-marketplace.rust-lang.rust-analyzer
        exts.vscode-marketplace.tamasfe.even-better-toml
        exts.vscode-marketplace.svelte.svelte-vscode
        exts.vscode-marketplace.unifiedjs.vscode-mdx
        exts.vscode-marketplace.astro-build.astro-vscode
        exts.vscode-marketplace.elmtooling.elm-ls-vscode
        exts.vscode-marketplace.denoland.vscode-deno
        exts.vscode-marketplace.charliermarsh.ruff
      ];

      userSettings = {
        "workbench.colorTheme" = "Everforest Dark";
        
        "search.exclude" = {
          "**/.direnv/**" = true;
        };

        "github.copilot.nextEditSuggestions.enabled" = true;

        "[javascript][typescript][javascriptreact][typescriptreact][json][jsonc][css]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
        };

        "rust-analyzer.check.command" = "clippy";
        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust-analyzer";
          "editor.formatOnSave" = true;
        };

        "svelte.enable-ts-plugin" = true;
        "[svelte]" = {
          "editor.defaultFormatter" = "svelte.svelte-vscode";
          "editor.formatOnSave" = true;
        };

        "[astro]" = {
          "editor.defaultFormatter" = "astro-build.astro-vscode";
          "editor.formatOnSave" = true;
        };

        "[elm]" = {
          "editor.defaultFormatter" = "elmtooling.elm-ls-vscode";
          "editor.formatOnSave" = true;
        };

        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff";
          "editor.formatOnSave" = true;
        };
      };
    };
  };

  # TODO: it would be nice to not have to duplicate language in package.json and scope in each file
  home.file = lib.mkMerge [
    (builtins.listToAttrs (
      map (f: {
        name = "${snippetDir}/${builtins.replaceStrings [".json"] [".code-snippets"] f}";
        value = {
          source = ../snippets/${f};
        };
      }) snippetFiles
    ))
  ];
}
