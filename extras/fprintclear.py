#!/usr/bin/env -S nix-shell -p gobject-introspection libfprint gusb 'python3.withPackages (p: with p; [pygobject3])' --run python3

import gi
gi.require_version('FPrint', '2.0')
from gi.repository import FPrint

ctx = FPrint.Context()

for dev in ctx.get_devices():
    print(dev)
    print(dev.get_driver())
    print(dev.props.device_id);

    dev.open_sync()

    dev.clear_storage_sync()
    print("All prints deleted.")

    dev.close_sync()
