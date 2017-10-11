
;------------------------------------------------------------------------------
;
;  ProTracker playroutine, revision 3
;
;  Coded by Lars "ZAP" Hamre
;  Updated by Håvard "HOWARD/MENTAL DISEASES" Pedersen
;
;REVISION 2B:
;* Mastervolume. (Separate left and right for balance controls.)
;* Overstep for players using program mode.
;* Rewind/fast forward. (One pattern)
;* Easy CIA-utilising.
;* DMAWait solved. (Finally!)
;* No longer clears one word behind end of module if instrument 31 is unused.
;* F00 really halts module now. (Was ignored)
;* Slower than before. =(
;* Various small optimisations in attempt to compensate. (Bugs may appear!)
;* PT_End now stops module, even if music is still called.
;* Added (selectable) 68020+ optimisations. (Not powerful yet...) 8(
;
;REVISION 2C:
;* Overstep didn't trig on halting the module. Now does.
;* Made overstep selectable.
;* Added NoiseTracker compatibility. (Selectable through PT__NTComp) Both NTs
;  vibrato and loop-position is supported. PT modules are still played as
;  before.
;* Fixed some ucase/lcase confusion on some labels.
;* CIA-tempo wasn't reset upon PT_Init(). Now is.
;
;REVISION 3:
;* Made proper definitions of the chantemp-structure and ensured the entire
;  source used it.
;* Rearranged chantemp-structure to make longword accesses on longword
;  boundaries.
;* Optimized balance-handling. Now uses as much time as normal mastervolume
;  would have done.
;* Did some small optimizations. (Nothing to boast about...)
;* Renamed PT_MasterVol to PT__MasterVol.
;* Made maindata structure. (Faster access because of indirect addressing.)
;  Also makes longword access on longword boundaries.
;* DMAWait waited far longer than it was supposed to. Used a new scheme based
;  on the fact that all processors are slowed down to ~7MHz when accessing
;  CIA registers.
;* Added selectable amount of channels.
;* Source is now completely PC-relative.
;
;REVISION 4:
;* Renamed PT_SetIntRate to CIA_SetBPM for compatibility with my ProPruner
;  replay.
;* The DMA-wait was buggy, really Commodore's fault because the documentation
;  there was on it didn't explain the matter fully.
;* Added external sync using effectcommand 8.
;
;PLEASE NOTE!
;This replay assumes exclusive access to audio hardware and OCS/ECS/AGA or
;compatible audio chips. This behaviour is _NOT_ encouraged by Commodore!
;
;TODO:
;* Implement pause/continue functions.
;
;------------------------------------------------------------------------------

   IFND  PT__MasterVol        ; Mastervolume ON/OFF
PT__MasterVol  =  0        ; Call PT_SetMasterVol with
   ENDC              ; Left in D0 and Right in D1
                  ; ( 0 - 64 )

   IFND  PT__OverStep         ; Signal when module is
PT__OverStep   =  0        ; finished. PT_OverStep
   ENDC              ; contains 1 if end has reached
                  ; and -1 if rewound past
                  ; beginning.

   IFND  PT__WindFuncs        ; Fast forward / Rewind
PT__WindFuncs  =  0
   ENDC

   IFND  PT__CIA           ; CIA Support
PT__CIA     =  0        ; Supply CIA_SetBPM with
   ENDC              ; rate (32-255) in D0. Trash
                  ; only D1/D0/A1.

   IFND  PT__68020         ; 68020+ optimisations
PT__68020   =  0
   ENDC

   IFND  PT__NTComp        ; Noisetracker compatibility
PT__NTComp  =  1
   ENDC

   IFND  PT__Channels         ; Number of channels to play
PT__Channels   =  4
   ENDC

   rsreset  ; Chantemp structure. Data for individual channels.
PTv_Step0   rs.w  1
PTv_Step2   rs.b  1
PTv_Step3   rs.b  1
PTv_SmpStart   rs.l  1
PTv_SmpRepStart   rs.l  1
PTv_WaveStart  rs.l  1
PTv_MasterVol  rs.w  1
PTv_SmpLength  rs.w  1
PTv_SmpRepLen  rs.w  1
PTv_Period  rs.w  1
PTv_DMAMask rs.w  1
PTv_TPDestPer  rs.w  1
PTv_SmpRealLen rs.w  1
PTv_SmpFinetune   rs.b  1
PTv_SmpVolume  rs.b  1
PTv_TPDir   rs.b  1
PTv_TPSpeed rs.b  1
PTv_VibPara rs.b  1
PTv_VibPos  rs.b  1
PTv_TremPara   rs.b  1
PTv_TremPos rs.b  1
PTv_WaveCtrl   rs.b  1
PTv_GlissFunk  rs.b  1
PTv_SampleOffs rs.b  1
PTv_PattPos rs.b  1
PTv_LoopCount  rs.b  1
PTv_FunkOffs   rs.b  1
PTv_sizeof  rs.b  0

   rsreset  ; Maindata structure. Global data.
PTm_SamplePtrs rs.l  31
PTm_ModulePtr  rs.l  1
PTm_VibShift   rs.l  1
PTm_PattPos rs.w  1
PTm_DMAConTemp rs.w  1
PTm_OverStep   rs.w  1
PTm_Speed   rs.b  1
PTm_Counter rs.b  1
PTm_SongPos rs.b  1
PTm_PattBrkPos rs.b  1
PTm_PosJumpFlag   rs.b  1
PTm_PattBrkFlag   rs.b  1
PTm_LowMask rs.b  1
PTm_PtDelTime  rs.b  1
PTm_PtDelTime2 rs.b  1
PTm_LoopPos rs.b  1
PTm_SyncVal rs.b  1
PTm_Pad     rs.b  1
PTm_sizeof  rs.b  0

;------------------------------------------------------------------------------
;Macro:     PT_Wait()
;Purpose:   Waits for a given number of rasterlines to expire.
;;------------------------------------------------------------------------------

PT_Wait  macro
      moveq.l  #\1-1,d0
      bsr.w PT_WaitLines
   endm

PT_WaitLines   lea.l $dff006+1,a1
      move.b   (a1),d7
      and.b #$f0,d7
.loop1      move.b   (a1),d6
      and.b #$f0,d6
      cmp.b d7,d6
      beq.s .loop1
.loop2      move.b   (a1),d6
      and.b #$f0,d6
      cmp.b d7,d6
      bne.s .loop2
      dbf   d0,.loop1
      rts

;------------------------------------------------------------------------------
;Function:  PT_Init(Module)(A0)
;Purpose:   Initializes the play-routine and restarts the module if it's
;     already playing. The module may have up to 256 patterns.
;------------------------------------------------------------------------------
PT_Init     lea.l PT_MainData(pc),a4

      move.b   #0,PTm_Speed(a4)
      move.l   a0,PTm_ModulePtr(a4)

      ; Find highest pattern
      move.l   a0,a1
      lea.l 952(a1),a1
      moveq.l  #128-1,d0
      moveq.l  #0,d1
PT_loop     move.l   d1,d2
      subq.w   #1,d0
PT_loop2 move.b   (a1)+,d1
      cmp.b d2,d1
      bgt.s PT_loop
      dbra  d0,PT_loop2
      addq.b   #1,d2

      ; Find samplepointers and clear first word
      lea.l PTm_SamplePtrs(a4),a1   ; !Pointers to samples
      lsl.l #8,d2
      lsl.l #2,d2
      add.l #1084,d2
      add.l a0,d2
      move.l   d2,a2
      moveq.l  #31-1,d0
PT_loop3 cmp.l a2,a3
      blt.s .range
      clr.l (a2)
.range      move.l   a2,(a1)+
      moveq.l  #0,d1
      move.w   42(a0),d1      ; sample length
      beq.b .nosample
      lsl.l #1,d1
      add.l d1,a2
.nosample   add.l #30,a0
      dbra  d0,PT_loop3

      ; Init vibrato and loop-position if NT-mod.
   ifne PT__NTComp
      move.b   951(a0),d1
      cmp.b #$7f,d1
      beq.s .NotNT      ; ProTracker module
      cmp.b #$78,d1
      beq.w .NotNT      ; Old 15-instrument converted

.WasNT      move.l   #6,PTm_VibShift(a4)
      move.b   d1,PTm_LoopPos(a4)
      bra.s .GotFormat

.NotNT      move.l   #7,PTm_VibShift(a4)
      clr.b PTm_LoopPos(a4)
.GotFormat
   endc

      lea.l PT_chan1temp(pc),a0
      moveq.l  #1,d0
      moveq.l  #4-1,d1
.DMALoop move.w   d0,PTv_DMAMask(a0)
      move.w   #64,PTv_MasterVol(a0)
      lea.l PTv_sizeof(a0),a0
      lsl.l #1,d0
      dbf   d1,.DMALoop


   ifne PT__CIA
      moveq.l  #125,d0
      bsr.s CIA_SetBPM
   endc

      or.b  #2,$bfe001
      clr.b PTm_Counter(a4)
      clr.b PTm_SongPos(a4)
      clr.w PTm_PattPos(a4)
      bsr.s PT_KillSound
      move.b   #6,PTm_Speed(a4)
      rts

;------------------------------------------------------------------------------
;Function:  PT_End()
;Purpose:   Stops the music.
;------------------------------------------------------------------------------
PT_End      move.b   #0,PTm_Speed(a4)

PT_KillSound   lea.l $dff000,a0

   ifge PT__Channels-1
      clr.w $a8(a0)
   endc

   ifge PT__Channels-2
      clr.w $b8(a0)
   endc

   ifge PT__Channels-3
      clr.w $c8(a0)
   endc

   ifge PT__Channels-4
      clr.w $d8(a0)
   endc

      rts

;------------------------------------------------------------------------------
;Function:  PT_SetMasterVol(Left,Right)(D0,D1)
;Purpose:   Sets left and right mastervolume.
;------------------------------------------------------------------------------
   ifne  PT__MasterVol
PT_SetMasterVol
      move.w   d0,PT_chan1temp+PTv_MasterVol
      move.w   d0,PT_chan4temp+PTv_MasterVol
      move.w   d1,PT_chan2temp+PTv_MasterVol
      move.w   d1,PT_chan3temp+PTv_MasterVol
      lea.l $dff000,a5

   ifge PT__Channels-1
      moveq.l  #0,d0
      lea.l PT_chan1temp(pc),a0
      move.b   PTv_SmpVolume(a0),d0
      mulu.w   PTv_MasterVol(a0),d0
      lsr.w #6,d0
      move.b   d0,$a8(a5)
   endc

   ifge PT__Channels-2
      moveq.l  #0,d0
      lea.l PT_chan2temp(pc),a0
      move.b   PTv_SmpVolume(a0),d0
      mulu.w   PTv_MasterVol(a0),d0
      lsr.w #6,d0
      move.b   d0,$b8(a5)
   endc

   ifge PT__Channels-3
      moveq.l  #0,d0
      lea.l PT_chan3temp(pc),a0
      move.b   PTv_SmpVolume(a0),d0
      mulu.w   PTv_MasterVol(a0),d0
      lsr.w #6,d0
      move.b   d0,$c8(a5)
   endc

   ifge PT__Channels-4
      moveq.l  #0,d0
      lea.l PT_chan4temp(pc),a0
      move.b   PTv_SmpVolume(a0),d0
      mulu.w   PTv_MasterVol(a0),d0
      lsr.w #6,d0
      move.b   d0,$d8(a5)
   endc

      moveq.l  #0,d0
      rts
   endc

PT_calcvol  macro

   ifne  PT__MasterVol
      mulu.w   PTv_MasterVol(a6),d0
      lsr.w #6,d0
   endc

   endm

;------------------------------------------------------------------------------
;Function:  PT_Rewind()
;Purpose:   Jumps one pattern backwards.
;------------------------------------------------------------------------------
   ifne  PT__WindFuncs
PT_Rewind   bsr.w PT_KillSound

      lea.l PT_MainData(pc),a4
      move.b   PTm_SongPos(a4),d0
      tst.b d0
      bne.s .not0

      move.l   PTm_ModulePtr(a4),a0 ; get moduleptr.
      move.b   950(a0),PTm_SongPos(a4)
      sub.b #2,PTm_SongPos(a4)
   ifne PT__OverStep
      move.w   #-1,PTm_OverStep(a4)
   endc
      bra.s .ok

.not0    cmp.b #1,d0
      bne.s .not1

      move.l   PTm_ModulePtr(a4),a0 ; get moduleptr.
      move.b   950(a0),PTm_SongPos(a4)
      sub.b #1,PTm_SongPos(a4)
      bra.s .ok

.not1
      sub.b #2,PTm_SongPos(a4)
.ok      move.w   #63*16,PTm_PattPos(a4)
      move.b   PTm_Speed(a4),PTm_Counter(a4)

      moveq.l  #0,d0
      rts

;------------------------------------------------------------------------------
;Function:  PT_Forward()
;Purpose:   Jumps one pattern forwards.
;------------------------------------------------------------------------------
PT_Forward  bsr.w PT_KillSound
      lea.l PT_MainData(pc),a4
      move.w   #63*16,PTm_PattPos(a4)
      move.b   PTm_Speed(a4),PTm_Counter(a4)

      moveq.l  #0,d0
      rts
   endc

;------------------------------------------------------------------------------
;Function:  PT_Music()
;Purpose:   Updates the music. Call with steady intervals, preferably 50
;     times a second.
;------------------------------------------------------------------------------
;D0 -          A0 - Start of pattern
;D1 - Note offset    A1 -
;D2 -          A2 -
;D3 -          A3 -
;D4 -          A4 - MainData struct
;D5 -          A5 - Hardware registers
;D6 -          A6 - ChanTemp struct of current channel
;D7 -          A7 - [Stack pointer]

PT_Music lea.l PT_MainData(pc),a4
      addq.b   #1,PTm_Counter(a4)
      move.b   PTm_Counter(a4),d0
      move.b   PTm_Speed(a4),d1
      beq.w PT_return
      cmp.b d1,d0
      blo.s PT_nonewnote
      clr.b PTm_Counter(a4)
      tst.b PTm_PtDelTime2(a4)
      beq.w PT_getnewnote
      bsr.s PT_nonewallchannels
      bra.w PT_dskip

PT_nonewnote   bsr.s PT_nonewallchannels
      bra.w PT_nonewposyet

PT_nonewallchannels
   ifge PT__Channels-1
      lea.l $dff0a0,a5
      lea.l PT_chan1temp(pc),a6
      bsr.w PT_checkefx
   endc

   ifge PT__Channels-2
      lea.l $dff0b0,a5
      lea.l PT_chan2temp(pc),a6
      bsr.w PT_checkefx
   endc

   ifge PT__Channels-3
      lea.l $dff0c0,a5
      lea.l PT_chan3temp(pc),a6
      bsr.w PT_checkefx
   endc

   ifge PT__Channels-4
      lea.l $dff0d0,a5
      lea.l PT_chan4temp(pc),a6
      bsr.w PT_checkefx
   endc
      rts

PT_getnewnote  move.l   PTm_ModulePtr(a4),a0
      lea.l 12(a0),a3
      lea.l 952(a0),a2     ;pattpo
      lea.l 1084(a0),a0    ;patterndata
      moveq.l  #0,d0
      moveq.l  #0,d1
      move.b   PTm_SongPos(a4),d0
      move.b   (a2,d0.w),d1
      lsl.l #8,d1
      lsl.l #2,d1
      add.w PTm_PattPos(a4),d1
      clr.w PTm_DMAConTemp(a4)

      ; !(a0,d1) points to the patterndata

   ifge PT__Channels-1
      lea.l $dff0a0,a5
      lea.l PT_chan1temp(pc),a6
      bsr.s PT_playvoice
   endc

   ifge PT__Channels-2
      lea.l $dff0b0,a5
      lea.l PT_chan2temp(pc),a6
      bsr.s PT_playvoice
   endc

   ifge PT__Channels-3
      lea.l $dff0c0,a5
      lea.l PT_chan3temp(pc),a6
      bsr.s PT_playvoice
   endc

   ifge PT__Channels-4
      lea.l $dff0d0,a5
      lea.l PT_chan4temp(pc),a6
      bsr.s PT_playvoice
   endc

      bra.w PT_setdma

PT_playvoice   tst.w PTv_Step0(a6)
      bne.s PT_plvskip
      bsr.w PT_pernop

PT_plvskip  move.l   (a0,d1.l),PTv_Step0(a6)
      addq.l   #4,d1
      moveq.l  #0,d2
      move.b   PTv_Step2(a6),d2
      and.b #$f0,d2
      lsr.b #4,d2
      move.b   PTv_Step0(a6),d0
      and.b #$f0,d0
      or.b  d0,d2
      tst.b d2
      beq.w PT_setregs
      moveq.l  #0,d3
      lea.l PTm_SamplePtrs(a4),a1
      move.w   d2,d4
      subq.l   #1,d2

      move.w   d4,d3       ; *30
      lsl.w #5,d4
      add.w d3,d3
      sub.w d3,d4

   ifeq  PT__68020
      lsl.l #2,d2
      move.l   (a1,d2.l),PTv_SmpStart(a6)
   else
      move.l   (a1,d2.l*4),PTv_SmpStart(a6)
   endc

      move.w   (a3,d4.l),PTv_SmpLength(a6)
      move.w   (a3,d4.l),PTv_SmpRealLen(a6)
      move.b   2(a3,d4.l),PTv_SmpFinetune(a6)
      move.b   3(a3,d4.l),PTv_SmpVolume(a6)
      move.w   4(a3,d4.l),d3     ; get repeat
      tst.w d3
      beq.s PT_noloop
      move.l   PTv_SmpStart(a6),d2  ; get start
      add.w d3,d3
      add.l d3,d2       ; add repeat
      move.l   d2,PTv_SmpRepStart(a6)
      move.l   d2,PTv_WaveStart(a6)
      move.w   4(a3,d4.l),d0     ; get repeat
      add.w 6(a3,d4.l),d0     ; add replen
      move.w   d0,PTv_SmpLength(a6)
      move.w   6(a3,d4.l),PTv_SmpRepLen(a6); save replen
      moveq.l  #0,d0
      move.b   PTv_SmpVolume(a6),d0

      PT_calcvol

      move.w   d0,8(a5)    ; set volume
      bra.s PT_setregs

PT_noloop   move.l   PTv_SmpStart(a6),d2
      add.l d3,d2
      move.l   d2,PTv_SmpRepStart(a6)
      move.l   d2,PTv_WaveStart(a6)
      move.w   6(a3,d4.l),PTv_SmpRepLen(a6)  ; save replen
      moveq.l  #0,d0
      move.b   PTv_SmpVolume(a6),d0

      PT_calcvol

      move.w   d0,8(a5)    ; set volume

      ; A new note is supposed to be played
PT_setregs  move.w   PTv_Step0(a6),d0
      and.w #$0fff,d0
      beq.w PT_checkmoreefx      ; if no note
      move.w   PTv_Step2(a6),d0
      and.w #$0ff0,d0
      cmp.w #$0e50,d0
      beq.s PT_dosetfinetune
      move.b   PTv_Step2(a6),d0
      and.b #$0f,d0
      cmp.b #3,d0       ; toneportamento
      beq.s PT_chktoneporta
      cmp.b #5,d0
      beq.s PT_chktoneporta
      cmp.b #9,d0       ; sample offset
      bne.s PT_setperiod
      bsr.w PT_checkmoreefx
      bra.s PT_setperiod

PT_dosetfinetune
      bsr.w PT_setfinetune
      bra.s PT_setperiod

PT_chktoneporta
      bsr.w PT_settoneporta
      bra.w PT_checkmoreefx

PT_setperiod   move.w   PTv_Step0(a6),d7
      and.w #$0fff,d7
      lea.l PT_periodtable(pc),a1
      moveq.l  #0,d0
      moveq.l  #36,d2
PT_ftuloop  cmp.w (a1,d0.w),d7
      bhs.s PT_ftufound
      addq.l   #2,d0
      dbra  d2,PT_ftuloop
PT_ftufound moveq.l  #0,d7
      move.b   PTv_SmpFinetune(a6),d7
      mulu.w   #36*2,d7
      add.l d7,a1
      move.w   (a1,d0.w),PTv_Period(a6)

      move.w   PTv_Step2(a6),d0
      and.w #$0ff0,d0
      cmp.w #$0ed0,d0      ; notedelay
      beq.w PT_checkmoreefx

      move.w   PTv_DMAMask(a6),$dff096 ; Shut off DMA
      PT_Wait  1        ; Wait for DMA to come off

      btst  #2,PTv_WaveCtrl(a6)
      bne.s PT_vibnoc
      clr.b PTv_VibPos(a6)

PT_vibnoc   btst  #6,PTv_WaveCtrl(a6)
      bne.s PT_trenoc
      clr.b PTv_TremPos(a6)

PT_trenoc   move.l   PTv_SmpStart(a6),(a5)   ; set start
      move.w   PTv_SmpLength(a6),4(a5) ; set length
      move.w   PTv_Period(a6),d0
      move.w   d0,6(a5)    ; set period
      move.w   PTv_DMAMask(a6),d0
      or.w  d0,PTm_DMAConTemp(a4)
      bra.w PT_checkmoreefx

PT_setdma   lea.l $bfe000,a5

      PT_Wait  4        ; Wait for auddat to be fetched

      move.w   PTm_DMAConTemp(a4),d0
      or.w  #$8000,d0
      move.w   d0,$dff096     ; Enable audio DMA

      PT_Wait  1        ; Wait for DMA to start

      lea.l $dff000,a5

   ifge PT__Channels-1
      lea.l PT_chan1temp(pc),a6
      move.l   PTv_SmpRepStart(a6),$a0(a5)
      move.w   PTv_SmpRepLen(a6),$a4(a5)
   endc

   ifge PT__Channels-2
      lea.l PT_chan2temp(pc),a6
      move.l   PTv_SmpRepStart(a6),$b0(a5)
      move.w   PTv_SmpRepLen(a6),$b4(a5)
   endc

   ifge PT__Channels-3
      lea.l PT_chan3temp(pc),a6
      move.l   PTv_SmpRepStart(a6),$c0(a5)
      move.w   PTv_SmpRepLen(a6),$c4(a5)
   endc

   ifge PT__Channels-4
      lea.l PT_chan4temp(pc),a6
      move.l   PTv_SmpRepStart(a6),$d0(a5)
      move.w   PTv_SmpRepLen(a6),$d4(a5)
   endc

PT_dskip add.w #16,PTm_PattPos(a4)
      move.b   PTm_PtDelTime(a4),d0
      beq.s PT_dskc
      move.b   d0,PTm_PtDelTime2(a4)
      clr.b PTm_PtDelTime(a4)

PT_dskc     tst.b PTm_PtDelTime2(a4)
      beq.s PT_dska
      subq.b   #1,PTm_PtDelTime2(a4)
      beq.s PT_dska
      sub.w #16,PTm_PattPos(a4)

PT_dska     tst.b PTm_PattBrkFlag(a4)
      beq.s PT_nnpysk
      sf PTm_PattBrkFlag(a4)
      moveq.l  #0,d0
      move.b   PTm_PattBrkPos(a4),d0
      clr.b PTm_PattBrkPos(a4)

      lsl.w #4,d0
      move.w   d0,PTm_PattPos(a4)

PT_nnpysk   cmp.w #1024,PTm_PattPos(a4)
      blo.s PT_nonewposyet

PT_nextposition
      moveq.l  #0,d0
      move.b   PTm_PattBrkPos(a4),d0
      move.w   d0,PTm_PattPos(a4)
      clr.b PTm_PattBrkPos(a4)
      clr.b PTm_PosJumpFlag(a4)
      addq.b   #1,PTm_SongPos(a4)
      and.b #$7f,PTm_SongPos(a4)
      move.b   PTm_SongPos(a4),d1

      move.l   PTm_ModulePtr(a4),a0
      cmp.b 950(a0),d1
      blo.s PT_nonewposyet
   ifne PT__OverStep
      move.w   #1,PTm_OverStep(a4)
   endc
   ifne PT__NTComp
      move.b   PTm_LoopPos(a4),PTm_SongPos(a4)
   else
      clr.b PTm_SongPos(a4)
   endc

PT_nonewposyet
      tst.b PTm_PosJumpFlag(a4)
      bne.s PT_nextposition
PT_return   rts

PT_checkefx bsr.w PT_updatefunk
      move.w   PTv_Step2(a6),d0
      and.w #$0fff,d0
      beq.s PT_pernop
      move.b   PTv_Step2(a6),d0
      and.b #$0f,d0
      beq.s PT_arpeggio
      cmp.b #1,d0
      beq.w PT_portaup
      cmp.b #2,d0
      beq.w PT_portadown
      cmp.b #3,d0
      beq.w PT_toneportamento
      cmp.b #4,d0
      beq.w PT_vibrato
      cmp.b #5,d0
      beq.w PT_toneplusvolslide
      cmp.b #6,d0
      beq.w PT_vibratoplusvolslide
      cmp.b #$e,d0
      beq.w PT_e_commands
setback     move.w   PTv_Period(a6),6(a5)
      cmp.b #7,d0
      beq.w PT_tremolo
      cmp.b #$a,d0
      beq.w PT_volumeslide
      rts

PT_pernop   move.w   PTv_Period(a6),6(a5)
      rts

PT_arpeggio moveq.l  #0,d0
      move.b   PTm_Counter(a4),d0
      divs.w   #3,d0
      swap.w   d0
      tst.w d0
      beq.s PT_arpeggio2
      cmp.w #2,d0
      beq.s PT_arpeggio1
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      lsr.b #4,d0
      bra.s PT_arpeggio3

PT_arpeggio1   moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      and.b #15,d0
      bra.s PT_arpeggio3

PT_arpeggio2   move.w   PTv_Period(a6),d2
      bra.s PT_arpeggio4

PT_arpeggio3   add.w d0,d0
      moveq.l  #0,d1
      move.b   PTv_SmpFinetune(a6),d1
      mulu.w   #36*2,d1
      lea.l PT_periodtable(pc),a0
      add.l d1,a0
      moveq.l  #0,d1
      move.w   PTv_Period(a6),d1
      moveq.l  #36,d3

PT_arploop  move.w   (a0,d0.w),d2
      cmp.w (a0),d1
      bhs.s PT_arpeggio4
      addq.l   #2,a0
      dbra  d3,PT_arploop
      rts

PT_arpeggio4   move.w   d2,6(a5)
      rts

PT_fineportaup tst.b PTm_Counter(a4)
      bne.w PT_return
      move.b   #$0f,PTm_LowMask(a4)

PT_portaup  moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      and.b PTm_LowMask(a4),d0
      move.b   #$ff,PTm_LowMask(a4)
      sub.w d0,PTv_Period(a6)
      move.w   PTv_Period(a6),d0
      and.w #$0fff,d0
      cmp.w #113,d0
      bpl.s PT_portauskip
      and.w #$f000,PTv_Period(a6)
      or.w  #113,PTv_Period(a6)

PT_portauskip  move.w   PTv_Period(a6),d0
      and.w #$0fff,d0
      move.w   d0,6(a5)
      rts

PT_fineportadown
      tst.b PTm_Counter(a4)
      bne.w PT_return
      move.b   #$0f,PTm_LowMask(a4)

PT_portadown   clr.w d0
      move.b   PTv_Step3(a6),d0
      and.b PTm_LowMask(a4),d0
      move.b   #$ff,PTm_LowMask(a4)
      add.w d0,PTv_Period(a6)
      move.w   PTv_Period(a6),d0
      and.w #$0fff,d0
      cmp.w #856,d0
      bmi.s PT_portadskip
      and.w #$f000,PTv_Period(a6)
      or.w  #856,PTv_Period(a6)

PT_portadskip  move.w   PTv_Period(a6),d0
      and.w #$0fff,d0
      move.w   d0,6(a5)
      rts

PT_settoneporta
      move.l   a0,-(sp)
      move.w   PTv_Step0(a6),d2
      and.w #$0fff,d2
      moveq.l  #0,d0
      move.b   PTv_SmpFinetune(a6),d0
      mulu.w   #37*2,d0
      lea.l PT_periodtable(pc),a0
      add.l d0,a0
      moveq.l  #0,d0

PT_stploop  cmp.w (a0,d0.w),d2
      bhs.s PT_stpfound
      addq.w   #2,d0
      cmp.w #37*2,d0
      blo.s PT_stploop
      moveq.l  #35*2,d0

PT_stpfound move.b   PTv_SmpFinetune(a6),d2
      and.b #8,d2
      beq.s PT_stpgoss
      tst.w d0
      beq.s PT_stpgoss
      subq.w   #2,d0

PT_stpgoss  move.w   (a0,d0.w),d2
      move.l   (sp)+,a0
      move.w   d2,PTv_TPDestPer(a6)
      move.w   PTv_Period(a6),d0
      clr.b PTv_TPDir(a6)
      cmp.w d0,d2
      beq.s PT_cleartoneporta
      bge.w PT_return
      move.b   #1,PTv_TPDir(a6)
      rts

PT_cleartoneporta
      clr.w PTv_TPDestPer(a6)
      rts

PT_toneportamento
      move.b   PTv_Step3(a6),d0
      beq.s PT_toneportnochange
      move.b   d0,PTv_TPSpeed(a6)
      clr.b PTv_Step3(a6)

PT_toneportnochange
      tst.w PTv_TPDestPer(a6)
      beq.w PT_return
      moveq.l  #0,d0
      move.b   PTv_TPSpeed(a6),d0
      tst.b PTv_TPDir(a6)
      bne.s PT_toneportaup

PT_toneportadown
      add.w d0,PTv_Period(a6)
      move.w   PTv_TPDestPer(a6),d0
      cmp.w PTv_Period(a6),d0
      bgt.s PT_toneportasetper
      move.w   PTv_TPDestPer(a6),PTv_Period(a6)
      clr.w PTv_TPDestPer(a6)
      bra.s PT_toneportasetper

PT_toneportaup
      sub.w d0,PTv_Period(a6)
      move.w   PTv_TPDestPer(a6),d0
      cmp.w PTv_Period(a6),d0
      blt.s PT_toneportasetper
      move.w   PTv_TPDestPer(a6),PTv_Period(a6)
      clr.w PTv_TPDestPer(a6)

PT_toneportasetper
      move.w   PTv_Period(a6),d2
      move.b   PTv_GlissFunk(a6),d0
      and.b #$0f,d0
      beq.s PT_glissskip
      moveq.l  #0,d0
      move.b   PTv_SmpFinetune(a6),d0
      mulu.w   #36*2,d0
      lea.l PT_periodtable(pc),a0
      add.l d0,a0
      moveq.l  #0,d0

PT_glissloop   cmp.w (a0,d0.w),d2
      bhs.s PT_glissfound
      addq.w   #2,d0
      cmp.w #36*2,d0
      blo.s PT_glissloop
      moveq.l  #35*2,d0

PT_glissfound  move.w   (a0,d0.w),d2

PT_glissskip   move.w   d2,6(a5)    ; set period
      rts

PT_vibrato  move.b   PTv_Step3(a6),d0
      beq.s PT_vibrato2
      move.b   PTv_VibPara(a6),d2
      and.b #$0f,d0
      beq.s PT_vibskip
      and.b #$f0,d2
      or.b  d0,d2

PT_vibskip  move.b   PTv_Step3(a6),d0
      and.b #$f0,d0
      beq.s PT_vibskip2
      and.b #$0f,d2
      or.b  d0,d2

PT_vibskip2 move.b   d2,PTv_VibPara(a6)

PT_vibrato2 move.b   PTv_VibPos(a6),d0
      lea.l PT_vibratotable(pc),a1
      lsr.w #2,d0
      and.w #$001f,d0
      moveq.l  #0,d2
      move.b   PTv_WaveCtrl(a6),d2
      and.b #$03,d2
      beq.s PT_vib_sine
      lsl.b #3,d0
      cmp.b #1,d2
      beq.s PT_vib_rampdown
      move.b   #255,d2
      bra.s PT_vib_set

PT_vib_rampdown
      tst.b PTv_VibPos(a6)
      bpl.s PT_vib_rampdown2
      move.b   #255,d2
      sub.b d0,d2
      bra.s PT_vib_set

PT_vib_rampdown2
      move.b   d0,d2
      bra.s PT_vib_set

PT_vib_sine move.b   (a1,d0.w),d2

PT_vib_set  move.b   PTv_VibPara(a6),d0
      and.w #15,d0
      mulu.w   d0,d2
   ifne PT__NTComp
      move.l   PTm_VibShift(a4),d0
      lsr.w d0,d2
   else
      lsr.w #7,d2
   endc
      move.w   PTv_Period(a6),d0
      tst.b PTv_VibPos(a6)
      bmi.s PT_vibratoneg
      add.w d2,d0
      bra.s PT_vibrato3

PT_vibratoneg  sub.w d2,d0

PT_vibrato3 move.w   d0,6(a5)
      move.b   PTv_VibPara(a6),d0
      lsr.w #2,d0
      and.w #$003c,d0
      add.b d0,PTv_VibPos(a6)
      rts

PT_toneplusvolslide
      bsr.w PT_toneportnochange
      bra.w PT_volumeslide

PT_vibratoplusvolslide
      bsr.s PT_vibrato2
      bra.w PT_volumeslide

PT_tremolo  move.b   PTv_Step3(a6),d0
      beq.s PT_tremolo2
      move.b   PTv_TremPara(a6),d2
      and.b #$0f,d0
      beq.s PT_treskip
      and.b #$f0,d2
      or.b  d0,d2

PT_treskip  move.b   PTv_Step3(a6),d0
      and.b #$f0,d0
      beq.s PT_treskip2
      and.b #$0f,d2
      or.b  d0,d2

PT_treskip2 move.b   d2,PTv_TremPara(a6)

PT_tremolo2 move.b   PTv_TremPos(a6),d0
      lea.l PT_vibratotable(pc),a1
      lsr.w #2,d0
      and.w #$001f,d0
      moveq.l  #0,d2
      move.b   PTv_WaveCtrl(a6),d2
      lsr.b #4,d2
      and.b #$03,d2
      beq.s PT_tre_sine
      lsl.b #3,d0
      cmp.b #1,d2
      beq.s PT_tre_rampdown
      move.b   #255,d2
      bra.s PT_tre_set

PT_tre_rampdown
      tst.b PTv_VibPos(a6)
      bpl.s PT_tre_rampdown2
      move.b   #255,d2
      sub.b d0,d2
      bra.s PT_tre_set

PT_tre_rampdown2
      move.b   d0,d2
      bra.s PT_tre_set

PT_tre_sine move.b   (a1,d0.w),d2

PT_tre_set  move.b   PTv_TremPara(a6),d0
      and.w #15,d0
      mulu.w   d0,d2
      lsr.w #6,d2
      moveq.l  #0,d0
      move.b   PTv_SmpVolume(a6),d0
      tst.b PTv_TremPos(a6)
      bmi.s PT_tremoloneg
      add.w d2,d0
      bra.s PT_tremolo3

PT_tremoloneg  sub.w d2,d0

PT_tremolo3 bpl.s PT_tremoloskip
      clr.w d0

PT_tremoloskip
      cmp.w #$40,d0
      bls.s PT_tremolook
      move.w   #$40,d0

PT_tremolook   PT_calcvol

      move.w   d0,8(a5)
      move.b   PTv_TremPara(a6),d0
      lsr.w #2,d0
      and.w #$003c,d0
      add.b d0,PTv_TremPos(a6)
      rts

PT_syncval
      move.b   PTv_Step3(a6),PTm_SyncVal(a4)
      rts

PT_sampleoffset
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      beq.s PT_sononew
      move.b   d0,PTv_SampleOffs(a6)

PT_sononew  move.b   PTv_SampleOffs(a6),d0
      lsl.w #7,d0
      cmp.w PTv_SmpLength(a6),d0
      bge.s PT_sofskip
      sub.w d0,PTv_SmpLength(a6)
      add.w d0,d0
      add.l d0,PTv_SmpStart(a6)
      rts

PT_sofskip  move.w   #$0001,PTv_SmpLength(a6)
      rts

PT_volumeslide
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      lsr.b #4,d0
      tst.b d0
      beq.s PT_volslidedown

PT_volslideup  add.b d0,PTv_SmpVolume(a6)
      cmp.b #$40,PTv_SmpVolume(a6)
      bmi.s PT_vsuskip
      move.b   #$40,PTv_SmpVolume(a6)

PT_vsuskip  move.b   PTv_SmpVolume(a6),d0

      PT_calcvol

      move.w   d0,8(a5)
      rts

PT_volslidedown
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0

PT_volslidedown2
      sub.b d0,PTv_SmpVolume(a6)
      bpl.s PT_vsdskip
      clr.b PTv_SmpVolume(a6)

PT_vsdskip  moveq.l  #0,d0
      move.b   PTv_SmpVolume(a6),d0

      PT_calcvol

      move.w   d0,8(a5)
      rts

PT_positionjump
      move.b   PTv_Step3(a6),d0
      subq.b   #1,d0
      move.b   d0,PTm_SongPos(a4)
   ifne PT__OverStep
      move.w   #1,PTm_OverStep(a4)
   endc
PT_pj2      clr.b PTm_PattBrkPos(a4)
      st PTm_PosJumpFlag(a4)
      rts

PT_volumechange
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      cmp.b #$40,d0
      bls.s PT_volumeok
      moveq.l  #$40,d0

PT_volumeok move.b   d0,PTv_SmpVolume(a6)

      PT_calcvol

      move.w   d0,8(a5)
      rts

PT_patternbreak
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      move.l   d0,d2
      lsr.b #4,d0
      mulu.w   #10,d0
      and.b #$0f,d2
      add.b d2,d0
      cmp.b #63,d0
      bhi.s PT_pj2
      move.b   d0,PTm_PattBrkPos(a4)
      st PTm_PosJumpFlag(a4)
      rts

PT_setspeed
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0

   ifne PT__OverStep
      bne.s .wasnotzero
      move.w   #1,PTm_OverStep(a4)
.wasnotzero
   endc

   ifne  PT__CIA
      cmp.b #32,d0
      blo.s .setspeed

.settempo   bsr.w CIA_SetBPM
      rts

   endc

.setspeed   clr.b PTm_Counter(a4)
      move.b   d0,PTm_Speed(a4)
      rts

PT_checkmoreefx
      bsr.w PT_updatefunk
      move.b   PTv_Step2(a6),d0
      and.b #$0f,d0
      cmp.b #$8,d0
      beq.w PT_syncval
      cmp.b #$9,d0
      beq.w PT_sampleoffset
      cmp.b #$b,d0
      beq.w PT_positionjump
      cmp.b #$d,d0
      beq.w PT_patternbreak
      cmp.b #$e,d0
      beq.s PT_e_commands
      cmp.b #$f,d0
      beq.w PT_setspeed
      cmp.b #$c,d0
      beq.w PT_volumechange
      bra.w PT_pernop

PT_e_commands  move.b   PTv_Step3(a6),d0
      and.b #$f0,d0
      lsr.b #4,d0
      beq.s PT_filteronoff
      cmp.b #1,d0
      beq.w PT_fineportaup
      cmp.b #2,d0
      beq.w PT_fineportadown
      cmp.b #3,d0
      beq.s PT_setglisscontrol
      cmp.b #4,d0
      beq.w PT_setvibratocontrol
      cmp.b #5,d0
      beq.w PT_setfinetune
      cmp.b #6,d0
      beq.w PT_jumploop
      cmp.b #7,d0
      beq.w PT_settremolocontrol
      cmp.b #9,d0
      beq.w PT_retrignote
      cmp.b #$a,d0
      beq.w PT_volumefineup
      cmp.b #$b,d0
      beq.w PT_volumefinedown
      cmp.b #$c,d0
      beq.w PT_notecut
      cmp.b #$d,d0
      beq.w PT_notedelay
      cmp.b #$e,d0
      beq.w PT_patterndelay
      cmp.b #$f,d0
      beq.w PT_funkit
      rts

PT_filteronoff
      move.b   PTv_Step3(a6),d0
      and.b #1,d0
      add.b d0,d0
      and.b #$fd,$bfe001
      or.b  d0,$bfe001
      rts   

PT_setglisscontrol
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      and.b #$f0,PTv_GlissFunk(a6)
      or.b  d0,PTv_GlissFunk(a6)
      rts

PT_setvibratocontrol
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      and.b #$f0,PTv_WaveCtrl(a6)
      or.b  d0,PTv_WaveCtrl(a6)
      rts

PT_setfinetune
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      move.b   d0,PTv_SmpFinetune(a6)
      rts

PT_jumploop tst.b PTm_Counter(a4)
      bne.w PT_return
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      beq.s PT_setloop
      tst.b PTv_LoopCount(a6)
      beq.s PT_jumpcnt
      subq.b   #1,PTv_LoopCount(a6)
      beq.w PT_return

PT_jmploop  move.b   PTv_PattPos(a6),PTm_PattBrkPos(a4)
      st PTm_PattBrkFlag(a4)
      rts

PT_jumpcnt  move.b   d0,PTv_LoopCount(a6)
      bra.s PT_jmploop

PT_setloop  move.w   PTm_PattPos(a4),d0
      lsr.w #4,d0
      move.b   d0,PTv_PattPos(a6)
      rts

PT_settremolocontrol
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      lsl.b #4,d0
      and.b #$0f,PTv_WaveCtrl(a6)
      or.b  d0,PTv_WaveCtrl(a6)
      rts

PT_retrignote  move.l   d1,-(sp)
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      beq.s PT_rtnend
      moveq.l  #0,d1
      move.b   PTm_Counter(a4),d1
      bne.s PT_rtnskp
      move.w   PTv_Step0(a6),d1
      and.w #$0fff,d1
      bne.s PT_rtnend
      moveq.l  #0,d1
      move.b   PTm_Counter(a4),d1

PT_rtnskp   divu.w   d0,d1
      swap.w   d1
      tst.w d1
      bne.s PT_rtnend

PT_doretrig move.w   PTv_DMAMask(a6),$dff096 ; channel dma off
      move.l   PTv_SmpStart(a6),(a5)   ; set sampledata pointer
      move.w   PTv_SmpLength(a6),4(a5) ; set length
      move.w   #300,d0

PT_rtnloop1 dbra  d0,PT_rtnloop1
      move.w   PTv_DMAMask(a6),d0
      bset  #15,d0
      move.w   d0,$dff096
      move.w   #300,d0

PT_rtnloop2 dbra  d0,PT_rtnloop2
      move.l   PTv_SmpRepStart(a6),(a5)
      move.l   PTv_SmpRepLen(a6),4(a5)

PT_rtnend   move.l   (sp)+,d1
      rts

PT_volumefineup
      tst.b PTm_Counter(a4)
      bne.w PT_return
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      and.b #$f,d0
      bra.w PT_volslideup

PT_volumefinedown
      tst.b PTm_Counter(a4)
      bne.w PT_return
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      bra.w PT_volslidedown2

PT_notecut  moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      cmp.b PTm_Counter(a4),d0
      bne.w PT_return
      clr.b PTv_SmpVolume(a6)
      move.w   #0,8(a5)
      rts

PT_notedelay   moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      cmp.b PTm_Counter(a4),d0
      bne.w PT_return
      move.w   PTv_Step0(a6),d0
      beq.w PT_return
      move.l   d1,-(sp)
      bra.w PT_doretrig

PT_patterndelay
      tst.b PTm_Counter(a4)
      bne.w PT_return
      moveq.l  #0,d0
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      tst.b PTm_PtDelTime2(a4)
      bne.w PT_return
      addq.b   #1,d0
      move.b   d0,PTm_PtDelTime(a4)
      rts

PT_funkit   tst.b PTm_Counter(a4)
      bne.w PT_return
      move.b   PTv_Step3(a6),d0
      and.b #$0f,d0
      lsl.b #4,d0
      and.b #$0f,PTv_GlissFunk(a6)
      or.b  d0,PTv_GlissFunk(a6)
      tst.b d0
      beq.w PT_return

PT_updatefunk  movem.l  a0/d1,-(sp)
      moveq.l  #0,d0
      move.b   PTv_GlissFunk(a6),d0
      lsr.b #4,d0
      beq.s PT_funkend
      lea.l PT_funktable(pc),a0
      move.b   (a0,d0.w),d0
      add.b d0,PTv_FunkOffs(a6)
      btst  #7,PTv_FunkOffs(a6)
      beq.s PT_funkend
      clr.b PTv_FunkOffs(a6)

      move.l   PTv_SmpRepStart(a6),d0
      moveq.l  #0,d1
      move.w   PTv_SmpRepLen(a6),d1
      add.l d1,d0
      add.l d1,d0
      move.l   PTv_WaveStart(a6),a0
      addq.l   #1,a0
      cmp.l d0,a0
      blo.s PT_funkok
      move.l   PTv_SmpRepStart(a6),a0

PT_funkok   move.l   a0,PTv_WaveStart(a6)
      moveq.l  #-1,d0
      sub.b (a0),d0
      move.b   d0,(a0)

PT_funkend  movem.l  (sp)+,a0/d1
      rts

PT_funktable   dc.b  0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128

PT_vibratotable   
      dc.b  000,024,049,074,097,120,141,161
      dc.b  180,197,212,224,235,244,250,253
      dc.b  255,253,250,244,235,224,212,197
      dc.b  180,161,141,120,097,074,049,024

PT_periodtable
; tuning 0, normal
      dc.w  856,808,762,720,678,640,604,570,538,508,480,453
      dc.w  428,404,381,360,339,320,302,285,269,254,240,226
      dc.w  214,202,190,180,170,160,151,143,135,127,120,113
; tuning 1
      dc.w  850,802,757,715,674,637,601,567,535,505,477,450
      dc.w  425,401,379,357,337,318,300,284,268,253,239,225
      dc.w  213,201,189,179,169,159,150,142,134,126,119,113
; tuning 2
      dc.w  844,796,752,709,670,632,597,563,532,502,474,447
      dc.w  422,398,376,355,335,316,298,282,266,251,237,224
      dc.w  211,199,188,177,167,158,149,141,133,125,118,112
; tuning 3
      dc.w  838,791,746,704,665,628,592,559,528,498,470,444
      dc.w  419,395,373,352,332,314,296,280,264,249,235,222
      dc.w  209,198,187,176,166,157,148,140,132,125,118,111
; tuning 4
      dc.w  832,785,741,699,660,623,588,555,524,495,467,441
      dc.w  416,392,370,350,330,312,294,278,262,247,233,220
      dc.w  208,196,185,175,165,156,147,139,131,124,117,110
; tuning 5
      dc.w  826,779,736,694,655,619,584,551,520,491,463,437
      dc.w  413,390,368,347,328,309,292,276,260,245,232,219
      dc.w  206,195,184,174,164,155,146,138,130,123,116,109
; tuning 6
      dc.w  820,774,730,689,651,614,580,547,516,487,460,434
      dc.w  410,387,365,345,325,307,290,274,258,244,230,217
      dc.w  205,193,183,172,163,154,145,137,129,122,115,109
; tuning 7
      dc.w  814,768,725,684,646,610,575,543,513,484,457,431
      dc.w  407,384,363,342,323,305,288,272,256,242,228,216
      dc.w  204,192,181,171,161,152,144,136,128,121,114,108
; tuning -8
      dc.w  907,856,808,762,720,678,640,604,570,538,508,480
      dc.w  453,428,404,381,360,339,320,302,285,269,254,240
      dc.w  226,214,202,190,180,170,160,151,143,135,127,120
; tuning -7
      dc.w  900,850,802,757,715,675,636,601,567,535,505,477
      dc.w  450,425,401,379,357,337,318,300,284,268,253,238
      dc.w  225,212,200,189,179,169,159,150,142,134,126,119
; tuning -6
      dc.w  894,844,796,752,709,670,632,597,563,532,502,474
      dc.w  447,422,398,376,355,335,316,298,282,266,251,237
      dc.w  223,211,199,188,177,167,158,149,141,133,125,118
; tuning -5
      dc.w  887,838,791,746,704,665,628,592,559,528,498,470
      dc.w  444,419,395,373,352,332,314,296,280,264,249,235
      dc.w  222,209,198,187,176,166,157,148,140,132,125,118
; tuning -4
      dc.w  881,832,785,741,699,660,623,588,555,524,494,467
      dc.w  441,416,392,370,350,330,312,294,278,262,247,233
      dc.w  220,208,196,185,175,165,156,147,139,131,123,117
; tuning -3
      dc.w  875,826,779,736,694,655,619,584,551,520,491,463
      dc.w  437,413,390,368,347,328,309,292,276,260,245,232
      dc.w  219,206,195,184,174,164,155,146,138,130,123,116
; tuning -2
      dc.w  868,820,774,730,689,651,614,580,547,516,487,460
      dc.w  434,410,387,365,345,325,307,290,274,258,244,230
      dc.w  217,205,193,183,172,163,154,145,137,129,122,115
; tuning -1
      dc.w  862,814,768,725,684,646,610,575,543,513,484,457
      dc.w  431,407,384,363,342,323,305,288,272,256,242,228
      dc.w  216,203,192,181,171,161,152,144,136,128,121,114

   cnop 0,4

PT_chan1temp   dcb.b PTv_sizeof,0
PT_chan2temp   dcb.b PTv_sizeof,0
PT_chan3temp   dcb.b PTv_sizeof,0
PT_chan4temp   dcb.b PTv_sizeof,0

PT_MainData dcb.b PTm_sizeof,0

