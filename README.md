# Elisas Strange Case - Processing sketch 


By f.Lüscher / fluescher.ch 2023 for Next Level Escape AG.

"AS IS" pi pa po etc.

Run this with [processing](http://processing.org/download) or standalone when compiled on mac/win/linux/raspberry pi.

When not on Raspberry Pi with GPIO pins and 4 connected rotary encoders,
  set `GPIO_AVAILABLE` to `false` and `DEBUG` to `true`.

Press number keys 0-6 or arrow keys to change stages.
`esc` to leave.

## STAGES
```
#   Action                                                  At end of script..
0:  Blackout                                                ..waits for dungeon master / udp signal
1:  Message"AWAITING INPUT"                                 ..waits for dungeon master / udp signal
2:  Startup sequence of computer                            ..auto-jumps to stage 3
3:  Elisas curves, but without brainalizer on players head  ..waits for dungeon master / udp signal
4:  Elisas curves, with brainalizer. Adjust dials to sync.  ..auto-jumps to next stage when synched
5:  Message "SUCCESS"                                       ..waits for dungeon master / udp signal
6:  Elisas thoughts as sequence in DE & EN                  ..waits for dungeon master / udp signal
```

## UDP
**Messages to control this script:**
- `sync_stage0`, `sync_stage1` etc: Jump to a specific stage (`0`...`6`).
- `sync_skipLoading` can be used to skip the initial loading process if it takes forever. (Stage `3`+`4` will not be as fast at first)

**Messages sent by this script:**
- `sync_ready` is sent when initially "loaded" stage `3`+`4` (only on startup)
- `sync_success` is sent when both curves where properly aligned by the player
- `sync_end_of_thoughts` is sent after the last thought of elisa
- `sync_died` is sent when program closed or died

## LUCKY NUMBERS
- Amplitude  337
- Frequency  224
- Scale      36
- De-noise   416