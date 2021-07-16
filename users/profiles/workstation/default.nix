{ self, config, lib, pkgs, ... }:

let inherit (lib) fileContents;


  weechat = pkgs.weechat.override {
    configure = { availablePlugins, ... }: {
      scripts = with pkgs.weechatScripts; [
        wee-slack
      ];
      init = ''
        /slack register ${fileContents ../../../secrets/slackToken}
      '';
    };
  };

in
{


  home.packages = with pkgs; [
    slack
    discord
    signal-desktop
    gparted
    cloc
    xflux-gui
    zoom-us

    niv
    nixfmt

    weechat
    aerc
  ];

  home.file.".bash/def.shlib" = {
    text = (fileContents ./def.shlib);
    executable = true;
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      function direnv-reset-def() {
          eval "''${DIRENV_RESET_DEF}"
        }

        function direnv-set-def() {
          eval "''${DIRENV_SET_DEF}"
        }

        eval "$(direnv hook bash)"
        export PROMPT_COMMAND="direnv-reset-def;''${PROMPT_COMMAND};direnv-set-def"
    '';
  };



  programs.obs-studio.enable = true;

  programs.vscode = {
    enable = true;
  };

  programs.git = {
    enable = true;

    extraConfig = {
      pull.rebase = false;
    };

    aliases = {
      a = "add -p";
      co = "checkout";
      cob = "checkout -b";
      f = "fetch -p";
      c = "commit";
      p = "push";
      ba = "branch -a";
      bd = "branch -d";
      bD = "branch -D";
      d = "diff";
      dc = "diff --cached";
      ds = "diff --staged";
      r = "restore";
      rs = "restore --staged";
      st = "status -sb";

      # reset
      soft = "reset --soft";
      hard = "reset --hard";
      s1ft = "soft HEAD~1";
      h1rd = "hard HEAD~1";

      # logging
      lg =
        "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      plog =
        "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
      tlog =
        "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
      rank = "shortlog -sn --no-merges";

      # delete merged branches
      bdm = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.chromium = {
    enable = true;
    extensions = [
      # Dark Reader and LastPass
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      { id = "hdokiejnpimakedhajhdlcegeplioahd"; }
      # Roam Toolkit
      { id = "ebckolanhdjilblnkcgcgifaikppnhba"; }
      # tab-less
      { id = "mdndkociaebjkggmhnemegoegnbfbgoo"; }
    ];
  };
}
