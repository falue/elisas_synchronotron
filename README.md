# Elisas Strange Case - Processing sketch 

By f.Lüscher / fluescher.ch 2023 for Next Level Escape AG.

"AS IS" pi pa po etc.

Run this with [processing.org](http://processing.org/download) or standalone when compiled on mac/win/linux/raspberry pi.

When not on Raspberry Pi with GPIO pins and 4 connected rotary encoders,
set `GPIO_AVAILABLE` to `false` and `DEBUG` to `true`.

Press number keys `0`-`6` or left/right `arrow keys` to change stages manually.
Press `ESC` to leave.

## STAGES
| Stage#| Action                                                  | At end of script..      |
|:-----:|---------------------------------------------------------|-------------------------|
| **0** | Blackout                                                | ..waits for UDP signal  |
| **1** | Message"AWAITING INPUT"                                 | ..waits for UDP signal  |
| **2** | Startup sequence of computer                            | ..**auto-jumps** to stage **3** |
| **3** | Elisas curves, without connected brainalizer on players head | ..waits for UDP signal  |
| **4** | Elisas curves, with connected brainalizer. Adjust with dials to sync brainwaves.  | ..**auto-jumps** to next stage when synched |
| **5** | Message "SUCCESS"                                       | ..waits for UDP signal  |
| **6** | Elisas thoughts as sequence in DE & EN                  | ..waits for UDP signal  |

## UDP
**Messages to control this script:**
- `sync_stage0`, `sync_stage1` etc: Jump to a specific stage (`0`...`6`).
- `sync_skipLoading` can be used to skip the initial loading process if it takes forever. (Stage `3`+`4` will not be as fast at first)

**Messages sent by this script:**
- `sync_ready` is sent when initially "loaded" stage `3`+`4` (only on startup)
- `sync_success` is sent when both curves where properly aligned by the player
- `sync_end_of_thoughts` is sent after the last thought of elisa
- `sync_died` is sent when program closed or died

## Exit application & see desktop
Press `ESC`.

## Adjustments
If adjustments to the scripts are needed, open the file `~/Applications/sketchbook/synchronotron/synchronotron.pde` with processing.
Or double click the file `processing.sh` on the desktop and click "file > open recent.. > synchronotron".
Press the **play** button on the GUI to preview the changes. `ESC` to exit. Save and quit.
Double click the file `startSketch.sh` on the desktop to verify changes.
Double click the file `update.sh` on the desktop to pull latest changes made by f.Lüscher - be sure to deliver an internet connection.

## LUCKY NUMBERS
- Amplitude  337
- Frequency  224
- Scale      36
- De-noise   416