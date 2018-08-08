

***********************************************************
* Equates
***********************************************************

 IFND   gb_ActiView
gb_ActiView EQU 32
 ENDIF

 IFND   gb_CopInit
gb_CopInit  EQU 36
 ENDIF

dlocRestoreSystem: 
    move.l   #$dff000,a5    ; Custom chip base

        movea.l  4.w,a6         ; ExecBase
        lea   GraphicsName,a1      ; "graphics.library"
        jsr   -$198(a6)      ; OldOpenLibrary()
        move.l   d0,a1       ; Copy ptr to GfxBase
        move.l   $26(a1),$80(a5)      ; Install old system copperlist
        jsr   -$19e(a6)      ; CloseLibrary()
        rts            ; Done

RestoreSystem:  lea $dff002,a5  ; custom chip base + 2
        move.w  OldDMACon,dmacon-2(a5)  ; restore old dma bits
        move.w  OldINTEna,intena-2(a5)  ; restore old int bits

        move.l  OldView,a1  ; old Work Bench view
        move.l  _GfxBase,a6 ; gfx base
        CALL    LoadView    ; Restore the view
        CALL    DisownBlitter   ; give blitter back to the system.

        move.l  gb_CopInit(a6),$80-2(a5) ; restore system clist
        move.l  a6,a1
        movea.l 4.w,a6      ; exec base
        CALL    CloseLibrary
        CALL    Permit      ; restart multitasking
        rts

TakeSystem: movea.l 4.w,a6      ; exec base
        lea $dff002,a5  ; custom chip base + 2

        lea GraphicsName,a1 ; "graphics.library"
        moveq   #0,d0       ; any version
        CALL    OpenLibrary ; open it.
        move.l  d0,_GfxBase ; save pointer to gfx base
        move.l  d0,a6       ; for later callls...

        move.l  gb_ActiView(a6),OldView ; save old view

        move.w  #0,a1       ; clears full long-word
        CALL    LoadView    ; Open a NULL view (resets display
                    ;   on any Amiga)

        CALL    WaitTOF     ; Wait twice so that an interlace
        CALL    WaitTOF     ;   display can reset.

        CALL    OwnBlitter  ; take over the blitter and...
        CALL    WaitBlit    ;   wait for it to finish so we
                    ;   safely use it as we please.

        movea.l 4.w,a6      ; exec base
        CALL    Forbid      ; kill multitasking

        move.w  $7c-2(a5),d0    ; AGA register...
        cmpi.b  #$f8,d0     ; are we AGA?
        bne.b   .not_aga    ; nope.
        move.w  #0,$dff1fc  ; reset AGA sprites to normal mode

.not_aga:
        bsr.b   GetVBR      ; get the vector base pointer
        move.l  d0,VectorBase   ; save it for later.

        move.w  dmaconr-2(a5),d0    ; old DMACON bits
        ori.w   #$8000,d0   ; or it set bit for restore
        move.w  d0,OldDMACon    ; save it

        move.w  intenar-2(a5),d0    ; old DMACON bits
        ori.w   #$c000,d0   ; or it set bit for restore
        move.w  d0,OldINTEna    ; save it
        rts


***********************************************************
* This function provides a method of obtaining a pointer to the base of the
* interrupt vector table on all Amigas.  After getting this pointer, use
* the vector address as an offset.  For example, to install a level three
* interrupt you would do the following:
*
*       bsr _GetVBR
*       move.l  d0,a0
*       move.l  $6c(a0),OldIntSave
*       move.l  #MyIntCode,$6c(a0)
*
***********************************************************
* Inputs: none
* Output: d0 contains vbr.

GetVBR:     move.l  a5,-(sp)        ; save it.
        moveq   #0,d0           ; clear
        movea.l 4.w,a6          ; exec base
        btst.b  #AFB_68010,AttnFlags+1(a6); are we at least a 68010?
        beq.b   .1          ; nope.
        lea.l   vbr_exception(pc),a5    ; addr of function to get VBR
        CALL    Supervisor      ; supervisor state
.1:     move.l  (sp)+,a5        ; restore it.
        rts             ; return

vbr_exception:
    ; movec vbr,Xn is a priv. instr.  You must be supervisor to execute!
;       movec   vbr,d0
    ; many assemblers don't know the VBR, if yours doesn't, then use this
    ; line instead.
        dc.w    $4e7a,$0801
        rte             ; back to user state code
 
