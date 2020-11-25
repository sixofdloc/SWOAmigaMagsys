    include 'sixinclude/copper.s'
    include 'sixinclude/hardware.s'
    include 'macros.s'

    incdir  'include/'
    include 'exec/exec_lib.i'
    include 'exec/execbase.i'
    include 'graphics/gfxbase.i'
    include 'graphics/graphics_lib.i'
    include 'hardware/custom.i'
    include 'libraries/dos_lib.i'
    include 'libraries/dos.i'
    include 'libraries/playsidbase.i'
    include 'libraries/playsid_lib.i'

MUSIC_SYSTEM EQU 0 ; 0 for SID, 1 for PT
CUSTOM_FONTS EQU 0 ; 0 for no custom fonts, 1 for custom fonts per article
;=============================================================================

ScreenWidth     EQU 320
ScreenHeight    EQU 256
PT__Channels    EQU 4
SysBase         EQU 4
;=============================================================================
    section  malt_vinegar,code
      
    lea $dff002,a5                  ; custom chip base + 2
    
    jsr OpenLibs                    ;Open all of the libraries we're using

    move.l #Loading0,d1
    CALLDOS PutStr

    bsr.w InitMouse                 ;Initialize the mouse
    move.l #Loading1,d1
    CALLDOS PutStr

    move.l #0,d0
    bsr.w LoadLogoNumber            ;Load Logo 0

    move.l #Loading2,d1
    CALLDOS PutStr

    move.l #0,d0
    bsr.w LoadModNumber             ;Load Module 0

    move.l #Loading3,d1
    CALLDOS PutStr

    move.l #0,d0
    bsr.w LoadArticle               ;Load Article 0

    bsr.W DisplayArticleText        ;Draw the initial text
    bsr.w InstallPointerSprite      ;Setup our pointer
    bsr.w SetupScreen               ;Setup Copperlist
 
    bsr.b  GetVBR                   ;Stash the vector base pointer
    move.l d0,VectorBase
    move.l d0,a0
    move.l $6c(a0),OldIntSave       ;Stash the old vb interrupt
    move.l #VBlankInt,$6c(a0)
    jmp MainLoop                    ;Jump into the main magsys

;=============================================================================
;Main Loop
;=============================================================================
MainLoop:
    WaitVRT
    cmp.l #1,loading_music
    beq noMusic                     ;Skip music if loading

    IFNE MUSIC_SYSTEM
        jsr   PT_Music              ;Call mod player if applicable
    ENDIF
noMusic
    jsr CheckMouse
    cmp.l #6,exitflag
    bne.s MainLoop

shutdownMagsys
    move.w    #$7fff,$9a-2(a5)      ;restore vectors
    move.l    VectorBase,a0
    move.l    OldIntSave,$6c(a0)
    bsr.w dlocRestoreSystem

    IFNE MUSIC_SYSTEM
        jmp   PT_End                ; Shut off audio
    ELSE
        move.l _PlaySidBase,d0
        cmp.l #0,d0
        beq nosidplaylibstop
        CALLPLAYSID StopSong
nosidplaylibstop
    ENDIF    

    rts

;=============================================================================
; Mouse handling top-level
;=============================================================================
CheckMouse:
    cmp.l #0,mouse_debounce
    bne NoMouseClickToHandle
    btst.b   #6,$bfe001  ; wait for left mouse button
    bne.s NoMouseClickToHandle
    bsr.w HandleMouseClick
NoMouseClickToHandle:
    rts

;=============================================================================
; Vertical Blank Interrupt
;=============================================================================
VBlankInt:
    movem.l d0-a6,-(a7) ; Push all regs onto stack
    move.l  #$dff002,a5 ; Custom chip base
;interrupt driven calls here
;    jsr DoLogo
    bsr.w HandleMouse
    cmp.l #1,menu_active
    bne vbi_nomenu
    bsr.w HighlightMenuRow
vbi_nomenu
    cmp.l #0,mouse_debounce
    beq no_debounce
    btst.b   #6,$bfe001  ; wait for left mouse button
    beq no_debounce ;mouse isn't back up yet
    sub.l #1,mouse_debounce
no_debounce:
    
    move.w  #$20,$9c-2(a5)  ; Turn off VBLANK int request bit
    movem.l (a7)+,d0-a6 ; Pop all regs from stack
    rte         ; End of interrupt

;=============================================================================
OpenLibs:
    movea.l SysBase,a6      ; exec base
    lea GraphicsName,a1 ; "graphics.library"
    moveq   #0,d0       ; any version
    CALL    OpenLibrary ; open it.
    move.l d0,_GfxBase

    movea.l SysBase,a6      ; exec base
    lea DOSName,a1 
    moveq   #1,d0       
    CALL    OpenLibrary 
    cmp.l #0,d0
    move.l  d0,_DOSBase 

    IFEQ MUSIC_SYSTEM
        movea.l SysBase,a6      ; exec base
        lea PlaySIDName,a1
        moveq #0,d0
        CALL OpenLibrary
        move.l d0,_PlaySidBase
        cmp.l #0,d0
        beq nosidplaylib
        CALLPLAYSID AllocEmulResource
nosidplaylib:
    ENDIF

    rts

;=============================================================================
InitMusic: 
    IFNE MUSIC_SYSTEM
        lea.l Module,a0
        jsr   PT_Init        ; Initialize replay
    ELSE
        move.l _PlaySidBase,d0
        cmp.l #0,d0
        beq nosidplaylibinit

        lea Module,a0
        lea Module,a1
        move.l music_file_len,d0
        CALLPLAYSID SetModule  
        move.l #0,d0
        CALLPLAYSID StartSong
nosidplaylibinit:
    ENDIF

    rts     
    
SetupScreen:
    lea      BitmapPointers,a0

    move.l   #Backdrop_plane_1,d0
    move.w   d0,6(a0)
    swap     d0
    move.w   d0,2(a0)
    swap     d0

    move.l   #Backdrop_plane_2,d0
    move.w   d0,14(a0)
    swap     d0
    move.w   d0,10(a0)
    swap     d0

    move.l   #Backdrop_plane_3,d0
    move.w   d0,22(a0)
    swap     d0
    move.w   d0,18(a0)
    swap     d0

    move.l   #Backdrop_plane_4,d0
    move.w   d0,30(a0)
    swap     d0
    move.w   d0,26(a0)
    swap     d0

    move.l   #CUSTOM,a5          ; Custom chip base
    move.l   #Copper,_cop1lc(a5)      ; install copper

    rts                           ; Done
;=============================================================================
    include 'ptplay.s'
    include 'dloc_kit.s'
    include 'fileio.s'
    include 'mouse.s'
    include 'menusystem.s'
    include 'articleviewer.s'
    
    
PrintString ; expects pointer to string in a2, dest row in d0, dest col in d1
    MOVEM.l D0-D7/A0-A6,-(SP) ;Push D0-D7/A0-A6 onto the stack
    lea Backdrop,a1   
    add.l #(72*40),a1
    ;add (row*40) + col
    lsl.l #3,d0
    move.l  d0,d2
    lsl.l #2,d0
    add.l   d0,d2
    lsl.l   #3,d2
    add.l   d1,d2
    add.l  d2,a1
    bsr.w PutString
    MOVEM.l (SP)+,D0-D7/A0-A6 ;Pop regs   
    rts
        
PutString ;expects pointer to string in a2, destination address in a1
    moveq   #0,d0
    move.b (a2)+,d0
    beq ps_done
    bsr.w Putchar_Adjusted
    jmp PutString
ps_done:      
    rts
    
Putchar_Adjusted:
    cmp #97,d0
    blt Putchar
    sub.w #96,d0
Putchar: ;expects char in d0, destination address in a1
    lea Font,a0         ; Adr of font
    ;subi.b  #' ',d0
    lsl.w   #3,d0
    add.w   d0,a0
    moveq   #7,d7           ; We will copy this many raster lines
DrawLoop:  
    move.b  (a0)+,(a1)       ; Copy a line of the character
    add.l   #40,a1          ; Next line in target bmap
    dbra    d7,DrawLoop     ; Repeat until whole character is done
    sub.l #319,a1
    rts             ; Done      
 ;=============================================================================
   
  
BlitBlock: ;expects source in d2, dest in d3
    move.l  d2,$50-2(a5)     ; Blitter source A       (y = 1)
    move.l  d3,$54-2(a5)     ; Blitter destination D  (y = 0)
    move.l  #$00000000,$64-2(a5)    ; A & D modulos
    move.l  #-1,$44-2(a5)           ; Write mask
    move.l  #$09f00000,$40-2(a5)    ; Blitter Control registers
    move.w  #(8*64)+40,$58-2(a5)    ; 198 lines by 8 words
    rts

;=============================================================================

CopyMemBytes:  ;(a0)->(a1), d0 bytes
   ; jmp CopyMemBytes
   cmp #1,d1
   beq AndMemBytes
   move.b (a0)+,(a1)+
   dbra d0,CopyMemBytes
   rts
   
AndMemBytes:
    move.b (a0),d2
    or.b (a1),d2
    move.b d2,(a1)
    add.l #1,a0
    add.l #1,a1
    dbra d0,AndMemBytes
    rts
    
CopyMemWords ; (a0)->(a1), d0 words
    move.w (a0),(a1)
    add.l #2,a0
    add.l #2,a1
    dbra d0,CopyMemWords
    rts
    
ClearColorTable
    move.w #$40,d0
    lea ColorBarTable,a0
CCT_Loop:
    move.l #0,(a0)
    add #4,a0
    dbra d0,CCT_Loop
    rts

;=============================================================================    
    include 'decruncher.s'
    include 'data.s'
    include "chipmem.s"

