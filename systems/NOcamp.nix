{ pkgs, ... }: {
	environment.systemPackages = with pkgs; [
		qgroundcontrol
		qgis-ltr
		arduino
	];
}
