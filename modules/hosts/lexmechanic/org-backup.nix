{ self, inputs, ... }: {

  flake.nixosModules.org-backup = { pkgs, config, ... }: let
      selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
      gitUser = "cypher";
      deployKey = "/home/${gitUser}/.ssh/deploy-key-org-files";
      repoPath = "/home/${gitUser}/org";
  in {
    systemd.services."org-backup" = {
      description = "Auto-commit and push all changes in org Git repo";
      path = [ selfpkgs.myGit config.programs.ssh.package ]; # myGit declared in git.nix, carries baked-in identity
      script = ''
        set -eu
        export GIT_SSH_COMMAND="ssh -i ${deployKey} -o IdentitiesOnly=yes"
        if [ -n "$(git -C ${repoPath} status --porcelain)" ]; then
          git -C ${repoPath} add -A
          git -C ${repoPath} commit -m "auto: backup at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
        fi
        git -C ${repoPath} push
      '';
      serviceConfig = {
        Type = "oneshot";
        User = gitUser;
      };
    };

    systemd.timers."org-backup" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2h";
        OnUnitActiveSec = "2h";
        Unit = "org-backup.service";
      };
    };
  };

}
