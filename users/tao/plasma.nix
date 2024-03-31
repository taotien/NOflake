{
  programs.plasma = {
    enable = true;
    shortcuts = {
      "ActivityManager"."switch-to-activity-4c4b4e59-b0da-4a45-b9cc-729233bb1e9a" = [ ];
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to English (US)" = [ ];
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to English (Workman)" = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = ["Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku"];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = ["Microphone Mute" "Meta+Volume Mute"];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Halt Without Confirmation" = [ ];
      "ksmserver"."Lock Session" = ["Meta+L" "Screensaver"];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "ksmserver"."Log Out Without Confirmation" = [ ];
      "ksmserver"."Reboot" = [ ];
      "ksmserver"."Reboot Without Confirmation" = [ ];
      "ksmserver"."Shut Down" = [ ];
      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Cycle Overview" = [ ];
      "kwin"."Cycle Overview Opposite" = [ ];
      "kwin"."Decrease Opacity" = [ ];
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Ctrl+F9";
      "kwin"."ExposeAll" = ["Ctrl+F10" "Launch (C)"];
      "kwin"."ExposeClass" = "Ctrl+F7";
      "kwin"."ExposeClassCurrentDesktop" = [ ];
      "kwin"."Grid View" = [ ];
      "kwin"."Increase Opacity" = [ ];
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."Move Tablet to Next Output" = [ ];
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."MoveZoomDown" = [ ];
      "kwin"."MoveZoomLeft" = [ ];
      "kwin"."MoveZoomRight" = [ ];
      "kwin"."MoveZoomUp" = [ ];
      "kwin"."Overview" = [ ];
      "kwin"."Setup Window Shortcut" = [ ];
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."Suspend Compositing" = "Alt+Shift+F12";
      "kwin"."Switch One Desktop Down" = "Meta+Ctrl+Down";
      "kwin"."Switch One Desktop Up" = "Meta+Ctrl+Up";
      "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Switch Window Down" = "Meta+Down";
      "kwin"."Switch Window Left" = "Meta+Left";
      "kwin"."Switch Window Right" = "Meta+Right";
      "kwin"."Switch Window Up" = "Meta+Up";
      "kwin"."Switch to Desktop 1" = "Ctrl+F1";
      "kwin"."Switch to Desktop 10" = [ ];
      "kwin"."Switch to Desktop 11" = [ ];
      "kwin"."Switch to Desktop 12" = [ ];
      "kwin"."Switch to Desktop 13" = [ ];
      "kwin"."Switch to Desktop 14" = [ ];
      "kwin"."Switch to Desktop 15" = [ ];
      "kwin"."Switch to Desktop 16" = [ ];
      "kwin"."Switch to Desktop 17" = [ ];
      "kwin"."Switch to Desktop 18" = [ ];
      "kwin"."Switch to Desktop 19" = [ ];
      "kwin"."Switch to Desktop 2" = "Ctrl+F2";
      "kwin"."Switch to Desktop 20" = [ ];
      "kwin"."Switch to Desktop 3" = "Ctrl+F3";
      "kwin"."Switch to Desktop 4" = "Ctrl+F4";
      "kwin"."Switch to Desktop 5" = [ ];
      "kwin"."Switch to Desktop 6" = [ ];
      "kwin"."Switch to Desktop 7" = [ ];
      "kwin"."Switch to Desktop 8" = [ ];
      "kwin"."Switch to Desktop 9" = [ ];
      "kwin"."Switch to Next Desktop" = [ ];
      "kwin"."Switch to Next Screen" = [ ];
      "kwin"."Switch to Previous Desktop" = [ ];
      "kwin"."Switch to Previous Screen" = [ ];
      "kwin"."Switch to Screen 0" = [ ];
      "kwin"."Switch to Screen 1" = [ ];
      "kwin"."Switch to Screen 2" = [ ];
      "kwin"."Switch to Screen 3" = [ ];
      "kwin"."Switch to Screen 4" = [ ];
      "kwin"."Switch to Screen 5" = [ ];
      "kwin"."Switch to Screen 6" = [ ];
      "kwin"."Switch to Screen 7" = [ ];
      "kwin"."Switch to Screen Above" = [ ];
      "kwin"."Switch to Screen Below" = [ ];
      "kwin"."Switch to Screen to the Left" = [ ];
      "kwin"."Switch to Screen to the Right" = [ ];
      "kwin"."Toggle Night Color" = [ ];
      "kwin"."Toggle Window Raise/Lower" = [ ];
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows Alternative" = [ ];
      "kwin"."Walk Through Windows Alternative (Reverse)" = [ ];
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Walk Through Windows of Current Application Alternative" = [ ];
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = [ ];
      "kwin"."Window Above Other Windows" = [ ];
      "kwin"."Window Below Other Windows" = [ ];
      "kwin"."Window Close" = ["Alt+F4" "Meta+W"];
      "kwin"."Window Fullscreen" = [ ];
      "kwin"."Window Grow Horizontal" = [ ];
      "kwin"."Window Grow Vertical" = [ ];
      "kwin"."Window Lower" = [ ];
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Maximize Horizontal" = [ ];
      "kwin"."Window Maximize Vertical" = [ ];
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window Move" = [ ];
      "kwin"."Window Move Center" = [ ];
      "kwin"."Window No Border" = [ ];
      "kwin"."Window On All Desktops" = [ ];
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window One Screen Down" = [ ];
      "kwin"."Window One Screen Up" = [ ];
      "kwin"."Window One Screen to the Left" = [ ];
      "kwin"."Window One Screen to the Right" = [ ];
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Pack Down" = [ ];
      "kwin"."Window Pack Left" = [ ];
      "kwin"."Window Pack Right" = [ ];
      "kwin"."Window Pack Up" = [ ];
      "kwin"."Window Quick Tile Bottom" = [ ];
      "kwin"."Window Quick Tile Bottom Left" = [ ];
      "kwin"."Window Quick Tile Bottom Right" = [ ];
      "kwin"."Window Quick Tile Left" = [ ];
      "kwin"."Window Quick Tile Right" = [ ];
      "kwin"."Window Quick Tile Top" = [ ];
      "kwin"."Window Quick Tile Top Left" = [ ];
      "kwin"."Window Quick Tile Top Right" = [ ];
      "kwin"."Window Raise" = [ ];
      "kwin"."Window Resize" = [ ];
      "kwin"."Window Shade" = [ ];
      "kwin"."Window Shrink Horizontal" = [ ];
      "kwin"."Window Shrink Vertical" = [ ];
      "kwin"."Window to Desktop 1" = [ ];
      "kwin"."Window to Desktop 10" = [ ];
      "kwin"."Window to Desktop 11" = [ ];
      "kwin"."Window to Desktop 12" = [ ];
      "kwin"."Window to Desktop 13" = [ ];
      "kwin"."Window to Desktop 14" = [ ];
      "kwin"."Window to Desktop 15" = [ ];
      "kwin"."Window to Desktop 16" = [ ];
      "kwin"."Window to Desktop 17" = [ ];
      "kwin"."Window to Desktop 18" = [ ];
      "kwin"."Window to Desktop 19" = [ ];
      "kwin"."Window to Desktop 2" = [ ];
      "kwin"."Window to Desktop 20" = [ ];
      "kwin"."Window to Desktop 3" = [ ];
      "kwin"."Window to Desktop 4" = [ ];
      "kwin"."Window to Desktop 5" = [ ];
      "kwin"."Window to Desktop 6" = [ ];
      "kwin"."Window to Desktop 7" = [ ];
      "kwin"."Window to Desktop 8" = [ ];
      "kwin"."Window to Desktop 9" = [ ];
      "kwin"."Window to Next Desktop" = [ ];
      "kwin"."Window to Next Screen" = [ ];
      "kwin"."Window to Previous Desktop" = [ ];
      "kwin"."Window to Previous Screen" = [ ];
      "kwin"."Window to Screen 0" = [ ];
      "kwin"."Window to Screen 1" = [ ];
      "kwin"."Window to Screen 2" = [ ];
      "kwin"."Window to Screen 3" = [ ];
      "kwin"."Window to Screen 4" = [ ];
      "kwin"."Window to Screen 5" = [ ];
      "kwin"."Window to Screen 6" = [ ];
      "kwin"."Window to Screen 7" = [ ];
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = ["Meta++" "Meta+="];
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."mediavolumedown" = [ ];
      "mediacontrol"."mediavolumeup" = [ ];
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = [ ];
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [ ];
      "org_kde_powerdevil"."powerProfile" = ["Battery" "Meta+B"];
      "plasmashell"."activate task manager entry 1" = "Meta+1";
      "plasmashell"."activate task manager entry 10" = [ ];
      "plasmashell"."activate task manager entry 2" = "Meta+2";
      "plasmashell"."activate task manager entry 3" = "Meta+3";
      "plasmashell"."activate task manager entry 4" = "Meta+4";
      "plasmashell"."activate task manager entry 5" = "Meta+5";
      "plasmashell"."activate task manager entry 6" = "Meta+6";
      "plasmashell"."activate task manager entry 7" = "Meta+7";
      "plasmashell"."activate task manager entry 8" = "Meta+8";
      "plasmashell"."activate task manager entry 9" = "Meta+9";
      "plasmashell"."clear-history" = [ ];
      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."cycleNextAction" = [ ];
      "plasmashell"."cyclePrevAction" = [ ];
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+A";
      "plasmashell"."previous activity" = "Meta+Shift+A";
      "plasmashell"."repeat_action" = [ ];
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-barcode" = [ ];
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";
      "plasmashell"."switch to next activity" = [ ];
      "plasmashell"."switch to previous activity" = [ ];
      "plasmashell"."toggle do not disturb" = [ ];
      "services/firefox.desktop"."_launch" = "Meta+F";
      "services/firefox.desktop"."new-private-window" = "Meta+Shift+F";
      "services/org.wezfurlong.wezterm.desktop"."_launch" = "Meta+Return";
    };
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false;
      "baloofilerc"."General"."dbVersion".value = 2;
      "baloofilerc"."General"."exclude filters".value = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found";
      "baloofilerc"."General"."exclude filters version".value = 9;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize".value = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size".value = 22;
      "kactivitymanagerdrc"."activities"."4c4b4e59-b0da-4a45-b9cc-729233bb1e9a".value = "Default";
      "kactivitymanagerdrc"."main"."currentActivity".value = "4c4b4e59-b0da-4a45-b9cc-729233bb1e9a";
      "kcminputrc"."Libinput/12972/18/Framework Laptop 16 Keyboard Module - ANSI Consumer Control"."Enabled".value = true;
      "kcminputrc"."Libinput/2362/628/PIXA3854:00 093A:0274 Mouse"."Enabled".value = false;
      "kcminputrc"."Libinput/2362/628/PIXA3854:00 093A:0274 Mouse"."PointerAccelerationProfile".value = 1;
      "kcminputrc"."Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad"."ClickMethod".value = 2;
      "kcminputrc"."Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad"."DisableWhileTyping".value = true;
      "kcminputrc"."Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad"."NaturalScroll".value = true;
      "kcminputrc"."Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad"."PointerAcceleration".value = 1.000;
      "kcminputrc"."Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad"."PointerAccelerationProfile".value = 1;
      "kcminputrc"."Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad"."ScrollFactor".value = 0.1;
      "kcminputrc"."Libinput/5426/123/Razer Razer Viper Ultimate Dongle"."PointerAccelerationProfile".value = 1;
      "kcminputrc"."Mouse"."X11LibInputXAccelProfileFlat".value = true;
      "kded5rc"."Module-browserintegrationreminder"."autoload".value = false;
      "kded5rc"."Module-device_automounter"."autoload".value = false;
      "kdeglobals"."KFileDialog Settings"."Allow Expansion".value = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension".value = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation".value = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position".value = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode".value = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode".value = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks".value = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path".value = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews".value = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview".value = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar".value = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files".value = false;
      "kdeglobals"."KFileDialog Settings"."Sort by".value = "Name";
      "kdeglobals"."KFileDialog Settings"."Sort directories first".value = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last".value = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed".value = false;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width".value = 138;
      "kdeglobals"."KFileDialog Settings"."View Style".value = "DetailTree";
      "kdeglobals"."WM"."activeBackground".value = "49,54,59";
      "kdeglobals"."WM"."activeBlend".value = "252,252,252";
      "kdeglobals"."WM"."activeForeground".value = "252,252,252";
      "kdeglobals"."WM"."inactiveBackground".value = "42,46,50";
      "kdeglobals"."WM"."inactiveBlend".value = "161,169,177";
      "kdeglobals"."WM"."inactiveForeground".value = "161,169,177";
      "kglobalshortcutsrc"."ActivityManager"."_k_friendly_name".value = "Activity Manager";
      "kglobalshortcutsrc"."KDE Keyboard Layout Switcher"."_k_friendly_name".value = "Keyboard Layout Switcher";
      "kglobalshortcutsrc"."kaccess"."_k_friendly_name".value = "Accessibility";
      "kglobalshortcutsrc"."kcm_touchpad"."_k_friendly_name".value = "Touchpad";
      "kglobalshortcutsrc"."kmix"."_k_friendly_name".value = "Audio Volume";
      "kglobalshortcutsrc"."ksmserver"."_k_friendly_name".value = "Session Management";
      "kglobalshortcutsrc"."kwin"."_k_friendly_name".value = "KWin";
      "kglobalshortcutsrc"."mediacontrol"."_k_friendly_name".value = "Media Controller";
      "kglobalshortcutsrc"."org_kde_powerdevil"."_k_friendly_name".value = "KDE Power Management System";
      "kglobalshortcutsrc"."plasmashell"."_k_friendly_name".value = "plasmashell";
      "kiorc"."Confirmations"."ConfirmDelete".value = true;
      "krunnerrc"."Plugins"."baloosearchEnabled".value = false;
      "kwalletrc"."Wallet"."First Use".value = false;
      "kwinrc"."Desktops"."Id_1".value = "925ef4df-45a9-4cdc-a29f-0f6a17a59588";
      "kwinrc"."Desktops"."Number".value = 1;
      "kwinrc"."Desktops"."Rows".value = 1;
      "kwinrc"."Tiling"."padding".value = 4;
      "kwinrc"."Tiling/530b5b99-fb5c-526e-822b-a6ca66eb2461"."tiles".value = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/7e0b89fb-bf08-5d5d-a334-0ecfa3cb7b04"."tiles".value = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.2520833333333333},{\"width\":0.7479166666666595}]}";
      "kwinrc"."Tiling/b139d5e7-0994-57d9-b378-1e6f13020bc3"."tiles".value = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"layoutDirection\":\"vertical\",\"tiles\":[{\"height\":0.55125},{\"height\":0.44875}],\"width\":0.492578125},{\"width\":0.5074218749999996}]}";
      "kwinrc"."Tiling/b4e8ebb4-a5b0-596a-b70d-9a1b27c4f05b"."tiles".value = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.3312500000000039},{\"width\":0.6687499999999946}]}";
      "kwinrc"."Tiling/e23d0cc4-ba9f-5b08-9f6b-33b2434ca622"."tiles".value = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/e688eb74-7230-5d02-a5e0-3b38a54bc04e"."tiles".value = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Wayland"."InputMethod[$e]".value = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
      "kwinrc"."Windows"."AutoRaise".value = true;
      "kwinrc"."Windows"."AutoRaiseInterval".value = 250;
      "kwinrc"."Windows"."DelayFocusInterval".value = 200;
      "kwinrc"."Windows"."FocusPolicy".value = "FocusFollowsMouse";
      "kwinrc"."Xwayland"."Scale".value = 1;
      "kwinrulesrc"."1"."Description".value = "Application settings for org.wezfurlong.wezterm";
      "kwinrulesrc"."1"."size".value = "1420,969";
      "kwinrulesrc"."1"."sizerule".value = 3;
      "kwinrulesrc"."1"."wmclass".value = "wezterm-gui org.wezfurlong.wezterm";
      "kwinrulesrc"."1"."wmclasscomplete".value = true;
      "kwinrulesrc"."1"."wmclassmatch".value = 1;
      "kwinrulesrc"."94b88066-bf8f-4089-8678-61be77391e5c"."Description".value = "Application settings for org.wezfurlong.wezterm";
      "kwinrulesrc"."94b88066-bf8f-4089-8678-61be77391e5c"."size".value = "1420,969";
      "kwinrulesrc"."94b88066-bf8f-4089-8678-61be77391e5c"."sizerule".value = 3;
      "kwinrulesrc"."94b88066-bf8f-4089-8678-61be77391e5c"."wmclass".value = "wezterm-gui org.wezfurlong.wezterm";
      "kwinrulesrc"."94b88066-bf8f-4089-8678-61be77391e5c"."wmclasscomplete".value = true;
      "kwinrulesrc"."94b88066-bf8f-4089-8678-61be77391e5c"."wmclassmatch".value = 1;
      "kwinrulesrc"."General"."count".value = 1;
      "kwinrulesrc"."General"."rules".value = 1;
      "kxkbrc"."Layout"."DisplayNames".value = "";
      "kxkbrc"."Layout"."LayoutList".value = "us";
      "kxkbrc"."Layout"."ResetOldOptions".value = true;
      "kxkbrc"."Layout"."Use".value = true;
      "kxkbrc"."Layout"."VariantList".value = "";
      "plasma-localerc"."Formats"."LANG".value = "en_US.utf8";
    };
  };
}
