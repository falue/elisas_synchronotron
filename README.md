# Elisas Strange Case - Processing sketch 

By f.Lüscher / fluescher.ch 2023 for Next Level Escape AG.

"AS IS" pi pa po etc.

Run this with [processing.org](http://processing.org/download) or standalone when compiled on mac/win/linux/raspberry pi.

When not on Raspberry Pi with GPIO pins and 4 connected rotary encoders,
set `GPIO_AVAILABLE` to `false` and `DEBUG` to `true`.

Press number keys `0`-`6` or left/right `arrow keys` to change stages manually.
Press `ESC` or `right mouse button` to leave.

## STAGES
| Stage#| Action                                                  | At end of stage..      |
|:-----:|---------------------------------------------------------|-------------------------|
| **0** | Blackout                                                | ..wait for UDP signal  |
| **1** | Message "AWAITING INPUT"                                 | ..wait for UDP signal  |
| **2** | Startup sequence of computer                            | ..**auto-jump** to stage **3** |
| **3** | Elisas curves, without connected brainalizer on players head | ..wait for UDP signal  |
| **4** | Elisas curves, with connected brainalizer. Adjust with dials to sync brainwaves.  | ..**auto-jump** to next stage when synched |
| **5** | Message "SUCCESS"                                       | ..wait for UDP signal  |
| **6** | Elisas thoughts as sequence in DE & EN                  | ..wait for UDP signal  |

## IP & USER
The IP address is fixed to `192.168.1.226`.
WRONG
currently 192.168.1.60

- username raspberry pi: `esc`
- password raspberry pi: `synchron`

## UDP
**Messages received by this script @ port `53545`:**
- `sync_stage0`, `sync_stage1` etc: Jump to a specific stage (`0`...`6`).
- `sync_skipLoading` can be used to skip the initial loading process if it takes forever. (Stage `3`+`4` will not be as fast at first)

**Messages sent by this script to port @ `53544`:**
- `sync_ready` is sent when initially "loaded" stage `3`+`4` (only on startup)
- `sync_success` is sent when both curves where properly aligned by the player
- `sync_end_of_thoughts` is sent after the last thought of elisa
- `sync_died` is sent when program closed or died

## EXIT APPLICATION TO DESKTOP
Press `ESC` or `right mouse button`.

## ADJUSTMENTS
To see the whole screen on one monitor, press the "SPLITTER" button on the "video wall hdmi" remote.

If adjustments to the scripts are needed, open the file `~/Applications/sketchbook/synchronotron/synchronotron.pde` with processing.
Or double click the file `editor.sh` on the desktop and click "*file* > *open recent..* > *synchronotron*".
Press the **play** button on the GUI to preview the changes. `ESC` or `right mouse button` to exit. Save and quit.

Double click the file `play.sh` on the desktop to verify changes.

Double click the file `update_and_play.sh` on the desktop to pull latest changes made by f.Lüscher - be sure to deliver an internet connection.

To reset the screens, press the "2x2" button on the "video wall hdmi" remote.

**NOTE**: If you update, you loose all local changes made by you to `~/Applications/sketchbook/synchronotron/synchronotron.pde`.


## LUCKY NUMBERS
|           |          |
|-----------|---------:|
| Amplitude | +**345** |
| Frequency | +**307** |
| Scale     |  +**12** |
| De-noise  | +**424** |