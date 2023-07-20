{ pkgs, ... }: {
	environment.systemPackages = with pkgs; [
		qgroundcontrol
		qgis-ltr
		arduino
		firefox
	];

	networking.hostName = "NObcer";
	users.users.ssrov = {
		isNormalUser = true;
		extraGroups = [ "dialout" ];
		hashedPassword = "";
	};
}
