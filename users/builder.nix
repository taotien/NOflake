{
    users.users.builder = {
        isSystemUser = true;
        group = "builder";
        useDefaultShell = true;

        openssh.authorizedKeys.keys = [
        ];
    };

    users.groups.builder = {};

    nix.settings.trusted-users = ["builder"];
}
