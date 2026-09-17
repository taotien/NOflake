# fTPM timeout consistently precedes the MES/gfxoff hang cascade -- possible shared PSP root cause

## Hardware / environment

- Framework Laptop 16, AMD Ryzen 7040 Series (7840HS), Radeon 780M iGPU (gfx1103), BIOS 04.05 (06/30/2026)
- NixOS, kernel 7.2.5 (also reproduced on 6.18.50 with the same signature)
- `boot.kernelParams`: `amdgpu.gpu_recovery=1 amdgpu.abmlevel=1 amdgpu.dcdebugmask=0x410 amdgpu.cwsr_enable=0`
  (`0x410` includes the documented PSR workaround from #3647; `cwsr_enable=0` is the community-reported
  partial mitigation from the Framework 13 AI-300 MES-timeouts thread)
- fTPM confirmed (not a discrete chip): `/sys/class/tpm/tpm0/device` -> `MSFT0101` (standard ACPI HID for
  a firmware TPM; on this platform that's implemented inside the PSP)

## Symptom

Same failure family already tracked in #3647 and (I believe) this issue: `ring gfx_0.0.0` stops
signaling, MES stops responding to reset/queue messages, the driver's own recovery (ring reset ->
pipe reset -> full ASIC reset) also fails, and the GPU is left wedged until a hard reboot.

## New observation: an fTPM operation timeout precedes the cascade by ~2 seconds, every time

Checked kernel logs across three independent crash instances (different days, two kernel versions)
and all three show the identical lead-in:

**Instance 1 (2026-09-16, kernel 6.18.50-derived build):**
```
20:33:36  tpm tpm0: Operation Timed out
20:33:38  amdgpu 0000:c4:00.0: Dumping IP State
20:33:47  amdgpu 0000:c4:00.0: Failed to disable gfxoff!
20:33:52  amdgpu 0000:c4:00.0: Failed to disable gfxoff!
...
```

**Instance 2 (2026-09-17, kernel 7.2.5):**
```
10:34:21  clocksource: Watchdog remote CPU 3 read timed out        (~10 min earlier, possibly unrelated -
                                                                      noting it since Framework's tracker
                                                                      issue #17 treats a similar clocksource
                                                                      symptom as a separate BIOS/TSC bug,
                                                                      not making a strong claim here)
10:44:48  tpm tpm0: Operation Timed out
10:44:50  amdgpu 0000:c4:00.0: Dumping IP State                    (2s later)
10:44:56  amdgpu 0000:c4:00.0: SMU: No response msg_reg: 1a resp_reg: 0
10:44:56  amdgpu 0000:c4:00.0: Failed to disable gfxoff!            (repeats 5x over ~30s)
10:45:14  amdgpu 0000:c4:00.0: ring gfx_0.0.0 timeout, signaled seq=312343, emitted seq=312345
10:45:24  amdgpu 0000:c4:00.0: MES failed to respond to msg=RESET
10:45:24  amdgpu 0000:c4:00.0: reset via MES failed and try pipe reset -110
10:45:24  amdgpu 0000:c4:00.0: GPU reset begin!. Source:  1
10:45:34  amdgpu 0000:c4:00.0: psp gfx command INVOKE_CMD(0x3) failed and response status is (0x0)
          (repeats)
10:45:49  amdgpu 0000:c4:00.0: MES failed to respond to msg=REMOVE_QUEUE
          (repeats ~10x over the next 30s)
10:46:22  amdgpu 0000:c4:00.0: Mode2 reset failed!
10:46:22  amdgpu 0000:c4:00.0: ASIC reset failed with error, -62 for drm dev, 0000:c4:00.0
10:46:22  amdgpu 0000:c4:00.0: GPU Recovery Failed: -62
```

**Instance 3 (2026-09-17, kernel 7.2.5, ~3 hours after instance 2):**
```
13:13:28  clocksource: Watchdog remote CPU 5 read timed out
13:13:58  tpm tpm0: Operation Timed out
13:13:59  amdgpu 0000:c4:00.0: Dumping IP State                    (1s later)
13:14:05  amdgpu 0000:c4:00.0: Failed to disable gfxoff!            (repeats 4x)
13:14:20  amdgpu 0000:c4:00.0: GPU reset begin!. Source:  1
13:14:44  amdgpu 0000:c4:00.0: MES failed to respond to msg=REMOVE_QUEUE  (repeats ~9x over 25s)
13:15:13  amdgpu 0000:c4:00.0: ASIC reset failed with error, -62 for drm dev, 0000:c4:00.0
13:15:13  amdgpu 0000:c4:00.0: GPU Recovery Failed: -62
13:15:16  amdgpu 0000:c4:00.0: MES failed to respond to msg=RESET
13:15:16  amdgpu 0000:c4:00.0: reset via MES failed and try pipe reset -110
13:16:42  tpm tpm0: A TPM error (257) occurred attempting get random
13:16:52  tpm tpm0: A TPM error (257) occurred attempting get random
          (repeats every ~10s for the remainder of the boot -- the TPM did
           not recover, unlike instances 1-2 where it was a brief blip)
```

**Independent, firmware-level corroboration:** on the next cold boot after instance 3, the BIOS
itself prompted to reset the fTPM -- i.e. the firmware, not just the kernel, flagged the TPM's state
as bad as a direct result of this crash. That's a stronger signal than a kernel log correlation alone:
the platform firmware is independently confirming the PSP/fTPM ended the crash in a genuinely
corrupted state, not just a transient logging blip. (Confirmed nothing on this system is sealed to
the TPM -- no LUKS, no systemd-creds, no vTPM -- so resetting it was safe and doesn't itself tell us
anything about root cause, but the fact that the BIOS *needed* to prompt for it does.)

In all three cases: `tpm0: Operation Timed out` is the very first symptom in the log, `amdgpu` starts
reacting (`Dumping IP State`) 1-2 seconds later, and from that point on every subsequent
gfxoff-disable and PSP-mediated GPU firmware command (`psp gfx command INVOKE_CMD`) also fails --
not just the MES/queue-reset path.

Since this device's TPM is a firmware TPM living inside the PSP, and `psp gfx command INVOKE_CMD`
failures show up in the same cascade, this reads less like "MES has a bug" in isolation and more like
"the PSP itself stalls or wedges, and everything that depends on it -- fTPM ops, gfxoff toggling via
SMU, MES queue management, GPU firmware loading -- starts failing together, with the fTPM timeout
being the earliest visible symptom because it's timing out on the shortest interval."

I don't have a root cause for *why* the PSP stalls, and I want to be clear I'm not asserting the
clocksource watchdog line above is definitely connected -- flagging it only because Framework's own
tracker (FrameworkComputer/SoftwareFirmwareIssueTracker#17) treats a similar-looking clocksource
symptom as a distinct BIOS/TSC issue on this same chip family, not necessarily the same bug as the
GPU hang. The fTPM-then-GPU correlation is the part I'm confident is real and repeatable.

## What's already been ruled out / tried without success

- `amdgpu.cwsr_enable=0`, `amdgpu.dcdebugmask=0x410` (includes the #3647 PSR workaround),
  `amdgpu.gpu_recovery=1` -- all active, none prevent this.
- `amdgpu.mes=0` -- silently a no-op on 7.2.5 (`amdgpu: unknown parameter 'mes' ignored`), that
  module parameter no longer exists in this kernel's amdgpu build.
- Hand-adapted the unmerged amd-gfx patch "drm/amdgpu/gfx11: disallow gfxoff around GPU reset"
  (Alex Deucher, posted 2026-07-06, still under review) onto current `gfx_v11_0_reset_kgq`/
  `reset_kcq` (the original diff no longer applied -- those functions were refactored independently
  since July). Built and booted successfully, but did not prevent this crash: since SMU is already
  refusing *all* messages (including gfxoff-disable) by the time any reset is attempted, wrapping the
  reset call in `amdgpu_gfx_off_ctrl()` can't help -- that call fails identically to every other SMU
  message in the same window.
- No real hardware fault signals anywhere in these logs: no MCE/ECC errors, no PCIe AER errors, no
  thermal shutdown. Whatever this is, it isn't failing silicon.

Happy to test a patch, pull more targeted logs, or run `amdgpu_gpu_recover` and capture the debugfs
dump if that would help narrow this down further.
