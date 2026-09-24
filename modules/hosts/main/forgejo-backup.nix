{ self, inputs, ... }: {

  flake.nixosModules.forgejo-backup = { pkgs, config, ... }: let
      backupUser = "cypher";
      sshKey = "/home/${backupUser}/.ssh/backup-key-forgejo"; # Passphrase-less, systemd has no agent
      host = "ecoserver"; # Host declared in ssh-client.nix
      container = "forgejo";
      stagePath = "/home/sljusard/.cache/forgejo-backup"; # Server-side staging dir
      backupPath = "/home/${backupUser}/backups/forgejo";
      keep = 7; # How many dumps to retain locally
  in {
    systemd.services."forgejo-backup" = {
      description = "Pull a Forgejo dump from ${host} into ${backupPath}";
      path = [ config.programs.ssh.package pkgs.rsync ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      script = ''
        set -eu

        mkdir -p ${backupPath}

        ssh="ssh -i ${sshKey} -o IdentitiesOnly=yes -o BatchMode=yes"

        remote=$($ssh ${host} 'podman exec ${container} sh -c "rm -f /tmp/forgejo-dump-*; cd /tmp && forgejo dump --quiet --skip-index >/dev/null && ls -1t /tmp/forgejo-dump-* | head -n1"')
        dump=$(basename "$remote")

        $ssh ${host} "mkdir -p ${stagePath} && rm -f ${stagePath}/forgejo-dump-* && podman cp ${container}:$remote ${stagePath}/ && podman exec ${container} rm -f '$remote'"

        rsync -rltv --checksum --itemize-changes --remove-source-files \
          -e "$ssh" \
          ${host}:${stagePath}/"$dump" ${backupPath}/

        if [ ! -s "${backupPath}/$dump" ]; then
          echo "dump did not arrive, aborting" >&2
          exit 1
        fi

        ls -1t ${backupPath}/forgejo-dump-* \
          | tail -n +${toString (keep + 1)} \
          | xargs -r rm -f
      '';
      serviceConfig = {
        Type = "oneshot";
        User = backupUser;
      };
    };

    systemd.timers."forgejo-backup" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "15m";
        Unit = "forgejo-backup.service";
      };
    };
  };

}
