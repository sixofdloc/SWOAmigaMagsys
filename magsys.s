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
;=============================================================================

ScreenWidth     EQU 320
ScreenHeight    EQU 256
PT__Channels    EQU 4

;=============================================================================
    section  malt_vinegar,code
      
    movea.l 4.w,a6      ; exec base
    lea $dff002,a5  ; custom chip base + 2

    lea GraphicsName,a1 ; "graphics.library"
    moveq   #0,d0       ; any version
    CALL    OpenLibrary ; open it.

    lea DOSName,a1 
    moveq   #1,d0       
    CALL    OpenLibrary 
    move.l  d0,_DOSBase 
    bsr.w InitMouse
    move.l #3,d0
    bsr.w LoadModNumber
    move.l #0,d0
    bsr.w LoadArticle
    bsr.W DisplayArticleText
    ;bsr.W DisplayArticleText
    ;bsr.W DisplayArticleText
    ;bsr.w LoadMod
    bsr.w InstallPointerSprite
    bsr.w SetupScreen    ; Setup Copperlist
  
    
    bsr.b  GetVBR      ; get the vector base pointer
    move.l d0,VectorBase   ; save it for later.

    move.l d0,a0
    move.l $6c(a0),OldIntSave
    move.l #VBlankInt,$6c(a0)

;=============================================================================
MainLoop:
    WaitVRT
    ;   move.w   #$fff,$dff180
    cmp.l #1,loading_music
    beq noMusic
    jsr   PT_Music    ; Make music
noMusic
    cmp.l #0,mouse_debounce
    bne NoMouseClickToHandle
    btst.b   #6,$bfe001  ; wait for left mouse button
    bne.s NoMouseClickToHandle
    bsr.w HandleMouseClick
NoMouseClickToHandle:
    cmp.l #6,exitflag
    bne.s MainLoop
    move.w    #$7fff,$9a-2(a5)
    move.l    VectorBase,a0
    move.l    OldIntSave,$6c(a0)
    bsr.w dlocRestoreSystem
    jmp   PT_End         ; Shut off audio
    rts

;=============================================================================
VBlankInt:
    movem.l d0-a6,-(a7) ; Push all regs onto stack
    move.l  #$dff002,a5 ; Custom chip base
;interrupt driven calls here
    jsr DoLogo
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
InitMusic: 
    lea.l Module,a0
    jsr   PT_Init        ; Initialize replay
    rts     
    
SetupScreen:
    lea      BitmapPointers,a0

    move.l   #Backdrop,d0
    move.w   d0,6(a0)
    swap     d0
    move.w   d0,2(a0)
    swap     d0

    add.l    #320*256/8,d0
    move.w   d0,14(a0)
    swap     d0
    move.w   d0,10(a0)
    swap     d0

    add.l    #320*256/8,d0
    move.w   d0,22(a0)
    swap     d0
    move.w   d0,18(a0)
    swap     d0

    add.l    #320*256/8,d0
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
;=============================================================================
;LoadFile
;   Expects Filename Addr in d1
;   Expects Dest Addr in d2
;   Expects MaxLen in d3
;=============================================================================
lf_fn:
    dc.l 0
lf_dest:
    dc.l 0
lf_maxlen:
    dc.l 0
    
LoadFile:
    move.l d1,lf_fn
    move.l d2,lf_dest
    move.l d3,lf_maxlen
    moveq #0,d6         ;filesize or 0 if not ok
    move.l lf_fn,d1
    move.l #MODE_OLDFILE,d2        ;mode_old - file must exist
    CALLDOS Open         ;DOS Open()
    move.l d0,d5            ;copy file handle
    move.l d5,d1            ;filehdl
    move.l lf_dest,d2      ;addr
    move.l lf_maxlen,d3       ;maxlen cap
    CALLDOS Read         ;DOS Read()
    cmp.l d1,d0
    bne.s .notok
    move.l d1,d6            ;loading ok! (set to size!)
.notok: 
    ;jmp .notok
    move.l d5,d1            ;file handle
    CALLDOS Close        ;DOS Close()

    rts    

;=============================================================================    
LoadArticle ;expects article # in d0
    move.l #1,loading_article
    jsr ClearTextArea
    ;jsr ClearArticleArea
    lea articlefilenames,a0
    move.l a0,d1
    asl.l #2,d0
    add.l d0,d1
    move.l d1,a0
    move.l (a0),d1
    move.l #Article,d2
    move.l #$FFFF,d3
    bsr.w LoadFile
    ;jsr FindArticleSize
    divu #40,d6
    move.l d6,article_rows
    move.l #0,loading_article
    move.l #0,current_top_row
    rts

ClearArticleArea
    lea Article,a0
    move.l #$FFFF,d0
caa_loop
    move.l #0,(a0)+
    dbra d0,caa_loop
    rts
    
FindArticleSize
    lea Article,a0
    moveq.l #0,d6
fas_loop
    move.l (a0)+,d0
    add.l #1,d6
    cmp.l #0,d0
    bne fas_loop
    rts
    
;=============================================================================    
LoadModNumber: ;expects mod # in d0
    move.l #1,loading_music
    WaitVRT
    WaitVRT
    jsr PT_End
    lea modfilenames,a0
    move.l a0,d1
    asl.l #2,d0
    add.l d0,d1
    move.l d1,a0
    move.l (a0),d1
    bsr.w LoadMod
    bsr.w InitMusic
    move.l #0,loading_music
    rts
    
LoadMod: 
    ;jmp LoadMod
    ;move.l #modfilename,d1
    move.l #Module,d2
    move.l #256000,d3
    bsr.w LoadFile
    rts
;=============================================================================    
    
InitMouse:  
; set the starting mouse position (for example 0,0)
    move.w  #0,MouseX
    move.w  #0,MouseY

; initialize the old counters, so the mouse will not jump on first movement
    move.w  $dff00a,d0
    move.b  d0,OldDeltaX
    lsr.w   #8,d0
    move.b  d0,OldDeltaY
    rts

         

HandleMouse:
    bsr.w ReadMouse
    bsr.w SetMousePointerPosition
    bsr.w CalcMouseCharRow
    rts
 
ReadMouse:

    ; **** SOF Read Mouse Routine ****

    movem.l d0-d2/a0-a1,-(sp)
    lea.l   OldDeltaY,a0
    lea.l   $dff00a,a1

    moveq   #0,d0
    move.b  (a1),d0         ; Get New Y Mouse
    move.w  (a0),d1         ; Get Old Y Mouse
    move.w  d0,(a0)         ; Save New Y Mouse
    sub.w   d1,d0           ; Delta Y

    moveq   #0,d1
    move.b  1(a1),d1        ; Get New X Mouse
    move.w  2(a0),d2        ; Get Old X Mouse
    move.w  d1,2(a0)        ; Save New X Mouse
    sub.w   d2,d1           ; Delta X

    ; **** Check Y Delta ****

    cmp.w   #-127,d0
    bge     .noUnderFlowY
    move.w  #-255,d2
    sub.w   d0,d2           ; Delta Y = -255 - Delta Y
    bpl     .noYPos
    moveq   #0,d2 
.noYPos:
    move.w  d2,d0
    bra     .rmSkipY 
.noUnderFlowY:
    cmp.w   #127,d0
    ble     .rmSkipY
    move.w  #255,d2
    sub.w   d0,d2           ; Delta X = 255 - Delta Y
    bmi     .noYNeg
    moveq   #0,d2
.noYNeg:        
    move.w  d2,d0 
.rmSkipY: 
    ; **** Check X Delta ****
    cmp.w   #-127,d1
    bge     .noUnderFlowX
    move.w  #-255,d2
    sub.w   d1,d2           ; Delta X = -255 - Delta X
    bpl     .noXPos
    moveq   #0,d2
.noXPos:
    move.w  d2,d1
    bra     .rmSkipX 
.noUnderFlowX:  
    cmp.w   #127,d1
    ble     .rmSkipX
    move.w  #255,d2
    sub.w   d1,d2           ; Delta X = 255 - Delta X
    bmi     .noXNeg
    moveq   #0,d2
.noXNeg:        
    move.w  d2,d1 
.rmSkipX: 
    lea.l   MouseY,a0
 
    move.w  (a0),d2         ; D2.W = Old Y Mouse 
    add.w   d0,d2           ; Y Mouse = Y Mouse + Y Delta

    cmp.w   #$6f,d2
    bpl     .yPositive

    moveq   #$6f,d2
.yPositive:     
    cmp.w   #$128,d2      ; Y Mouse > Screen Height?
    ble     .yBelow
    move.w  #$128,d2
.yBelow:       
    move.w  d2,(a0)+        ; Save Y Mouse

    move.w  (a0),d2         ; D2.W = Old X Mouse
    add.w   d1,d2           ; X Mouse = X Mouse + X Delta

    cmp.w   #$40,d2
    bpl     .xPositive

    moveq   #$40,d2
.xPositive:
    cmp.w   #$dd,d2       ; X Mouse > Screen Width?
    ble     .xBelow
    move.w  #$dd,d2
.xBelow:       
    move.w  d2,(a0)+
    movem.l (sp)+,d0-d2/a0-a1
    rts 
      
SetMousePointerPosition:
    move.b  MouseY+1,MousePointer
    move.b  MouseX+1,MousePointer+1

    move.b  #0,d2
    cmp.b #1,MouseY
    bne rm_NoStartInc
    ori #4,d2
rm_NoStartInc
    moveq #0,d0
    move.w MouseY,d0
    add.w   #$10,d0
    move.b d0,MousePointer+2
    lsr.w #8,d0
    cmp.b #0,d0
    beq rm_NoEndInc
    ori #2,d2
rm_NoEndInc
    move.b d2,MousePointer+3
    rts

InstallPointerSprite:
    lea SpritePointers,a0
    move.l  #MousePointer,d0
    move.w  d0,6(a0)
    swap    d0
    move.w  d0,2(a0)        
    rts
    
CalcMouseCharRow
    ;if mouse_y <$74 or mouse_y > $11c, char row is $ff
    moveq.l #0,d0
    move.w MouseY,d0
    cmp.w #$6f,d0
    ble NoRow
    cmp.w #$11d,d0
    bge NoRow
    ;char row is (mouse_Y-$74)/8
    sub.l #$6f,d0
    asr.l #3,d0
    sub.l #1,d0
    move.l d0,current_mouse_row
    rts
NoRow:
    move.l #$ff,current_mouse_row
    rts
    
HandleMouseClick
    move.l #06,mouse_debounce
    ;if we're in menu mode, call that menu's click handler with the char row
    ;otherwise, check if we clicked on the bottom menu bar
    cmp.l #1,menu_active
    bne hmc_nomenu
    jsr HandleMenuClick
    rts
hmc_nomenu
    cmp.w #120,MouseY
    ble hmc_notbottommenu
    cmp.w #$50,MouseX
    bgt hmc_notmainmenu
    lea main_menu,a0
    bsr.w ShowMenu
    rts
hmc_notmainmenu
    cmp.w #$c0,MouseX
    ble hmc_notbottommenu
    lea music_menu,a0
    bsr.w ShowMenu
    rts
hmc_notbottommenu
    ;Are we in the text area?
    cmp.w #$CA,MouseY
    bgt hmc_not_text_up
    ;can we dec the articlebase?
    cmp.l #0,current_top_row
    beq hmc_not_text_area
    sub.l #1,current_top_row
    jsr DisplayArticleText
    move.l #00,mouse_debounce
    rts
hmc_not_text_up
    ;can we inc the articlebase?
    move.l article_rows,d0
    sub.l #22,d0
    cmp.l current_top_row,d0

    ble hmc_not_text_area
    add.l #1,current_top_row
    jsr DisplayArticleText
hmc_exit    
    move.l #00,mouse_debounce
    rts
hmc_not_text_area
    rts

HandleMenuClick
    ;selected option is currentMouseRow - 6
    cmp.l #6,current_mouse_row
    blt hmenuclick_exit
    move.l current_menu_addr,a0
    move.l (a0),d1
    move.l MENU_ACTIONSADDR(a0),a1
    move.l MENU_PARAMSADDR(a0),a2
    move.l current_mouse_row,d0
;lock
;    jmp lock
    sub.l #6,d0
    cmp.l d1,d0
    bgt hmenuclick_exit
    asl.l #2,d0
    add.l d0,a1
    add.l d0,a2
;lock2
;    jmp lock2
    cmp.l #MENU_ACTION_CLOSEMENU,(a1)
    bne hmenu_notclosemenu
    jsr CloseMenu
    rts
hmenu_notclosemenu
    cmp.l #MENU_ACTION_EXITMAGSYS,(a1)
    bne hmenu_notexitmagsys
    move.l #6,exitflag
    jmp hmc_exit
hmenu_notexitmagsys
    cmp.l #MENU_ACTION_SPAWNMENU,(a1)
    bne hmenu_notspawnmenu
    move.l (a2),a0
    jsr ShowMenu
    rts
hmenu_notspawnmenu
    cmp.l #MENU_ACTION_ARTICLE,(a1)
    bne hmenu_notarticle
    move.l (a2),d0
    jsr LoadArticle
    jsr CloseMenu
    jmp hmc_exit
hmenu_notarticle
    cmp.l #MENU_ACTION_MUSIC,(a1)
    bne hmenu_notmusic
    move.l (a2),d0
    jsr LoadModNumber
    jsr CloseMenu
    jmp hmc_exit
hmenu_notmusic
hmenuclick_exit
    rts

    
;MainMenuClick
;    cmp.l #16,current_mouse_row
;    bne mm_NotExit
;    jsr ClearTextArea
;    move.l #0,menu_active
;    jmp exit_main_menu
;mm_NotExit
;    cmp.l #18,current_mouse_row
;    bne MainMenuClickDone
;    move.l #6,exitflag
;exit_main_menu
;    bsr.w CloseMenu
;MainMenuClickDone
;    rts
;
;MusicMenuClick
;    cmp.l #6,current_mouse_row
;    bne not_music0
;    move.l #0,d0
;    jsr LoadModNumber
;    jmp exit_music_menu
;not_music0
;    cmp.l #8,current_mouse_row
;    bne not_music1
;    move.l #1,d0
;    jsr LoadModNumber
;    jmp exit_music_menu
;not_music1
;    cmp.l #10,current_mouse_row
;    bne not_music2
;    move.l #2,d0
;    jsr LoadModNumber
;    jmp exit_music_menu
;not_music2
;    cmp.l #12,current_mouse_row
;    bne not_music3
;    move.l #3,d0
;    jsr LoadModNumber
;    jmp exit_music_menu
;not_music3
;    cmp.l #14,current_mouse_row
;    bne MusicMenuClickDone
;exit_music_menu
;    bsr.w CloseMenu
;MusicMenuClickDone
;    rts
;=============================================================================
CloseMenu:
    ;;MOVEM.l D0-D7/A0-A6,-(SP) ;Push D0-D7/A0-A6 onto the stack
    jsr ClearTextArea
    move.l #0,menu_active
    jsr DisplayArticleText
    ;;MOVEM.l (SP)+,D0-D7/A0-A6 ;Pop regs   
    rts
    
ClearTextArea:
    MOVEM.l D0-D7/A0-A6,-(SP) ;Push D0-D7/A0-A6 onto the stack
    lea Backdrop,a1
    add.l #72*40,a1
    move.l #21*40*8,d2
cta_loop
    move.b #0,(a1)+
    ;add.l #4,a0
    dbra d2,cta_loop
;lock
;    jmp lock
    bsr.w CleanRowColors
    MOVEM.l (SP)+,D0-D7/A0-A6 ;Pop regs   
    rts

  
;=============================================================================
DisplayArticleText: 
    lea Article,a2
    move.l current_top_row,d3
    mulu #40,d3
    add.l d3,a2
   ;move.l current_top_row,d3
    move.l #20,d5
    move.l #0,d0
dat_loop
    bsr.w Put40
    ;add.l #40,a2
    add.l #1,d0
    ;add.l #1,d3
    ;cmp.l article_rows,d3
    ;bgt dat_exit
    dbra d5,dat_loop
dat_exit
    rts

;=============================================================================
Put40 ;pointer to text in a2, dest row in d0, returns new text addr in a2
    ;jmp Put40
    MOVEM.l D0-D7/A3-A6,-(SP) ;Push D0-D7/A3-A6 onto the stack
    lea Backdrop,a1   
    add.l #(72*40),a1
    ;add (row*40) + col
    lsl.l #3,d0
    move.l  d0,d2
    lsl.l #2,d0
    add.l   d0,d2
    lsl.l   #3,d2
;    add.l   d1,d2
    add.l  d2,a1
    move.l #39,d4
p40_loop
    moveq   #0,d0
    move.b (a2)+,d0
   ; cmp.b #$0d,d0
   ; beq p40_skipchar
  ;  cmp.b #$0a,d0
  ;  beq p40_done
    ;move.b (a2)+,d0
    ;cmp.b #10,d0
    ;beq p40_done
    ;sub.l #1,a2
    ;jmp p40_done
p40_normalchar    
    bsr.w Putchar
p40_skipchar
    dbra d4,p40_loop
p40_done:      
    MOVEM.l (SP)+,D0-D7/A3-A6 ;Pop regs   
    rts
    
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
    
ShowMenu: ;expects pointer to menu in a0
    move.l a0,current_menu_addr
    bsr.w ClearTextArea
    move.l (a0),d7 ;number of menu options in d7
    move.l MENU_OPTIONADDRS(a0),a4 ;address of string pointer list in a7
    move.l (a4),a1 ;address of first string in a1
    move.l MENU_OPTIONLENGTHS(a0),a3 ;length list address in a6
    move.l MENU_TITLEADDR(a0),a2 ;pointer to title in a1
    move.l MENU_TITLELEN(a0),d2
    move.l #1,menu_active
    asr.l #1,d2
    move.l #20,d1
    sub.l d2,d1         ;title col is 20 - (len of title/2)
    
    ;Title row of menu is 4
    move.l #4,d0
    ;sub.l d7,d0
    bsr.w PrintString
    add.l #2,d0
    move.l a1,a2
    
        ;each left is 20-(len of menu option/2)
        ;top menu option row is 6
sm_loop:
    move.l (a3),d2
    asr.l #1,d2
    move.l #20,d1
    sub.l d2,d1 ;col is 20 - (len/2)
    ;string in a2, row in d0, col in d1
    bsr.w PrintString
    add.l #4,a4
    move.l (a4),a2 ;address of next string in a2
    add.l #1,d0
    add.l #4,a3
    dbra d7,sm_loop
    rts

    
;=============================================================================
HighlightMenuRow:
    moveq.l #20,d7
hmr_loop
    move.l d7,d0
    cmp.l current_mouse_row,d0
    bne hmr_notcurrent
    move.l #$0f00,d1
    jmp hmr_setcolor
hmr_notcurrent
    move.l #$0fff,d1
hmr_setcolor
    bsr.w SetCharRowColor
    dbra d7,hmr_loop    
    rts
;=============================================================================
CleanRowColors:
    moveq.l #20,d7
crc_loop
    move.l d7,d0
    move.l #$0fff,d1
crc_setcolor
    bsr.w SetCharRowColor
    dbra d7,crc_loop    
    rts


;=============================================================================
SetCharRowColor: ;expects char row in d0, color in d1
    asl.l #2,d0 ;d0*4
    lea charcolors,a0
    add.l d0,a0
    move.l (a0),a1
    move.w d1,(a1)
    rts
;=============================================================================
DoLogo:
    jsr DoOutline
    jsr ClearColorTable
    jsr DoRed
    jsr DoGreen
    jsr DoBlue
    lea logo_background_colors,a1
    lea ColorBarTable,a0
    move.l #0,d0
cllctc_loop:
    move.b (a0)+,(a1)+
    move.b (a0)+,(a1)+
    add.l #6,a1
    add.l #1,d0
    cmp.l #$3d,d0
    bne.s cllctc_loop
    rts    

DoOutline:
    sub.b #1,OutlineTick
    cmp.b #0,OutlineTick
    bne SkipOutline
    move.b OutlineDelay,OutlineTick
    add.b #$02,OutlinePos
    cmp.b #$40,OutlinePos
    bne Not_Outline_Reset
    move.b #0,OutlinePos
Not_Outline_Reset:
    move.l #0,d0
    move.b OutlinePos,d0
    lea GreyTable,a0
    lea logo_outline_color,a1
    add.l d0,a0
    move.w (a0),(a1)
SkipOutline:
    rts

DoRed
    sub.b #1,RedTick
    cmp.b #0,RedTick
    bne PlotRed
    move.b RedDelay,RedTick
    cmp.b #0,RedDir ; 0 is increment, 1 is decrement
    bne DecRed
    add.b #1,RedPos
    cmp.b #$24,RedPos
    bne PlotRed
    move.b #1,RedDir
    jmp PlotRed
DecRed
    sub.b #1,RedPos
    cmp.b #0,RedPos
    bne PlotRed
    move.b #0,RedDir
PlotRed:
    lea RedTable,a0
    move.l #0,d0
    move.b RedPos,d0
    move.l #0,d1
PlotBar
    lea ColorBarTable,a1
    asl.l #1,d0
    add.l d0,a1
    move.l #$40,d0
    bsr.w CopyMemBytes
    rts

DoGreen
    sub.b #1,GreenTick
    cmp.b #0,GreenTick
    bne PlotGreen
    move.b GreenDelay,GreenTick
    cmp.b #0,GreenDir ; 0 is increment, 1 is decrement
    bne DecGreen
    add.b #1,GreenPos
    cmp.b #$27,GreenPos
    bne PlotGreen
    move.b #1,GreenDir
    jmp PlotGreen
DecGreen:
    sub.b #1,GreenPos
    cmp.b #0,GreenPos
    bne PlotGreen
    move.b #0,GreenDir    
PlotGreen:
    lea GreenTable,a0
    move.l #0,d0
    move.b GreenPos,d0
    move.l #1,d1
    jmp PlotBar

DoBlue
    sub.b #1,BlueTick
    cmp.b #0,BlueTick
    bne PlotBlue
    move.b BlueDelay,BlueTick
    cmp.b #0,BlueDir ; 0 is increment, 1 is decrement
    bne DecBlue
    add.b #1,BluePos
    cmp.b #$29,BluePos
    bne PlotBlue
    move.b #1,BlueDir
    jmp PlotBlue
DecBlue
    sub.b #1,BluePos
    cmp.b #0,BluePos
    bne PlotBlue
    move.b #0,BlueDir
    
PlotBlue:
    lea BlueTable,a0
    move.l #0,d0
    move.b BluePos,d0
    move.l #1,d1
    jmp PlotBar

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

    section fish,data


    
    include 'menus.s'
;=============================================================================    
charcolors
    dc.l charcolor0,charcolor1,charcolor2,charcolor3,charcolor4,charcolor5
    dc.l charcolor6,charcolor7,charcolor8,charcolor9,charcolor10,charcolor11
    dc.l charcolor12,charcolor13,charcolor14,charcolor15,charcolor16
    dc.l charcolor17,charcolor18,charcolor19,charcolor20

 
;menu variables for mouseover
menu_active
    dc.l 0

current_menu_addr
    dc.l 0

exitflag
    dc.l 0

loading_music
    dc.l 0
    
current_mouse_row
    dc.l 0
    
loading_article ;flag to keep from reloading article
    dc.l 0
article_rows ;number of rows in article
    dc.l 0
current_top_row ;currently displayed article row at top of screen
    dc.l 0
  
mouse_debounce
    dc.l 0

    EVEN

;mouse variables
MouseY:
        dc.w    0
MouseX:
        dc.w    0
;oldhorizcnt:
;        ds.b    1
;oldvertcnt:
;        ds.b    1
OldDeltaY:      
    dc.w    0
OldDeltaX:      
    dc.w    0
   
    EVEN
ColorBarTable:
    ds.w $80,0
    EVEN

RedTable
    dc.w $0000,$0100,$0200,$0300,$0400,$0500,$0600,$0700
    dc.w $0800,$0900,$0a00,$0b00,$0c00,$0d00,$0e00,$0f00
    dc.w $0f00,$0e00,$0d00,$0c00,$0b00,$0a00,$0900,$0800
    dc.w $0700,$0600,$0500,$0400,$0300,$0200,$0100,$0000
GreenTable
    dc.w $0000,$0010,$0020,$0030,$0040,$0050,$0060,$0070
    dc.w $0080,$0090,$00a0,$00b0,$00c0,$00d0,$00e0,$00f0
    dc.w $00f0,$00e0,$00d0,$00c0,$00b0,$00a0,$0090,$0080
    dc.w $0070,$0060,$0050,$0040,$0030,$0020,$0010,$0000
BlueTable
    dc.w $0000,$0001,$0002,$0003,$0004,$0005,$0006,$0007
    dc.w $0008,$0009,$000a,$000b,$000c,$000d,$000e,$000f
    dc.w $000f,$000e,$000d,$000c,$000b,$000a,$0009,$0008
    dc.w $0007,$0006,$0005,$0004,$0003,$0002,$0001,$0000
GreyTable
    dc.w $0000,$0111,$0222,$0333,$0444,$0555,$0666,$0777
    dc.w $0888,$0999,$0aaa,$0bbb,$0ccc,$0ddd,$0eee,$0fff
    dc.w $0fff,$0eee,$0ddd,$0ccc,$0bbb,$0aaa,$0999,$0888
    dc.w $0777,$0666,$0555,$0444,$0333,$0222,$0111,$0000

OutlineDelay:
    dc.b $05
OutlinePos:
    dc.b $00
OutlineTick: 
    dc.b $04

RedPos  
    dc.b $00
GreenPos    
    dc.b $08
BluePos     
    dc.b $10

RedDir
    dc.b $00
GreenDir
    dc.b $00
BlueDir
    dc.b $00

RedDelay
    dc.b $02
GreenDelay
    dc.b $03
BlueDelay
    dc.b $04

RedTick
    dc.b $01
GreenTick
    dc.b $01
BlueTick
    dc.b $01

EVEN
LoadingText:
    dc.b 'LOADING',0

    EVEN
   
;library names
GraphicsName:
    GRAFNAME
    EVEN
DOSName:
    DOSNAME
    
    EVEN
Article
    ds.b 128000,0

;=============================================================================
    section  chips,data_c
    include "copperlist.s"

NullSprite: 
    dc.l 0,0,0,0 

MousePointer:
    dc.w $C985,$D900
    dc.w $C000,$4000
    dc.w $7000,$B000 
    dc.w $3C00,$4C00
    dc.w $3F00,$4300 
    dc.w $1FC0,$20C0 
    dc.w $1FC0,$2000 
    dc.w $0F00,$1100
    dc.w $0D80,$1280 
    dc.w $04C0,$0940 
    dc.w $0460,$08A0 
    dc.w $0020,$0040  
    dc.w $0000,$0000 
    dc.w $0000,$0000 
    dc.w $0000,$0000 
    dc.w $0000,$0000 
    dc.w $0000,$0000 
    dc.w $0000,$0000 
Backdrop:
    incbin "raw/sceneworld2.iff.raw"

mt_Counter:
    dc.b 0,0,0,0

Font:
    incbin  'raw/font_swo_c64_2.raw'

Module:
    ds.b 256000,0

;=============================================================================

        section DemoBSS,BSS
OldIntSave: 
    ds.l    1
Level3Save: 
    ds.l    1
gfx_base    
    ds.l    1       ; pointer to graphics base
_DOSBase    
    ds.l    1   
OldView     
    ds.l    1       ; old Work Bench view addr.
VectorBase: 
    ds.l    1       ; pointer to the Vector Base
OldDMACon:  
    ds.w    1       ; old dmacon bits
OldINTEna:  
    ds.w    1       ; old intena bits

