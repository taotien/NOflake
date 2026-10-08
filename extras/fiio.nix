{...}: {
    # FiiO K5 Pro. Its ring light shows the rate: blue = 44.1/48kHz, yellow = higher.
    # Keep the default at 48kHz (pipewire's own default): winepulse opens its streams
    # at pipewire-pulse's default rate, so a higher default makes proton games
    # resample 48k->96k themselves and the high end gets scratchy. Allowing the
    # higher rates still lets hi-res music switch the DAC up when it plays alone.
    services.pipewire.extraConfig.pipewire."90-fiio" = {
        "context.properties"."default.clock.allowed-rates" = [44100 48000 96000 192000];
    };
}
