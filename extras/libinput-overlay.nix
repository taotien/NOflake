final: prev: {
  libinput = prev.libinput.overrideAttrs (oldAttrs: {
    prePatch = ''
      substituteInPlace src/evdev-mt-touchpad.c --replace "DEFAULT_KEYBOARD_ACTIVITY_TIMEOUT_1 ms2us(200)" "DEFAULT_KEYBOARD_ACTIVITY_TIMEOUT_1 ms2us(2000)"
      substituteInPlace src/evdev-mt-touchpad.c --replace "DEFAULT_KEYBOARD_ACTIVITY_TIMEOUT_2 ms2us(500)" "DEFAULT_KEYBOARD_ACTIVITY_TIMEOUT_2 ms2us(5000)"

    '';
  });
}
