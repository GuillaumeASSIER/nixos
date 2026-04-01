{...}: {
  # === Disable Core Dumps ===
  systemd.coredump.enable = false;
  security = {
    pam.loginLimits = [
      {
        domain = "*";
        type = "hard";
        item = "core";
        value = "0";
      }
      {
        domain = "*";
        type = "soft";
        item = "core";
        value = "0";
      }
    ];
    # === Audit Logging ===
    auditd.enable = true;
    audit = {
      enable = true;
      rules = [
        # Surveiller les modifications de fichiers système critiques
        "-w /etc/passwd -p wa -k identity"
        "-w /etc/group -p wa -k identity"
        "-w /etc/shadow -p wa -k identity"
        "-w /etc/sudoers -p wa -k sudoers"
        "-w /etc/sudoers.d/ -p wa -k sudoers"

        # Surveiller les modifications du noyau
        "-w /sbin/insmod -p x -k modules"
        "-w /sbin/rmmod -p x -k modules"
        "-w /sbin/modprobe -p x -k modules"

        # Surveiller les connexions réseau
        "-a exit,always -F arch=b64 -S socket -k network"
      ];
    };
  };
}
