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
    move.l #0,d0
    bsr.w LoadLogoNumber
    move.l #0,d0
    bsr.w LoadModNumber
    move.l #0,d0
    bsr.w LoadArticle
    bsr.W DisplayArticleText
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
InitMusic: 
    lea.l Module,a0
    jsr   PT_Init        ; Initialize replay
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
;=============================================================================
    ;expects logo number in d0
LoadLogoNumber:
    add.b #$30,d0
    lea logobasename,a0
    move.b d0,6(a0)
    move.b #$61,7(a0)
    bsr.w LoadLogo
;lock:
 ;   jmp lock
    rts

LoadLogo:
    ;load plane 1
    lea logobasename,a0
    move.l a0,d1
    move.l #Backdrop_plane_1,d2
    move.l 2560,d3
    bsr.w LoadFile
;lock
;    jmp lock

    ;load plane 2
    lea logobasename,a0
    move.b #$62,7(a0)
    move.l a0,d1
    move.l #Backdrop_plane_2,d2
    move.l 2560,d3
    bsr.w LoadFile

    ;load plane 3
    lea logobasename,a0
    move.b #$63,7(a0)
    move.l a0,d1
    move.l #Backdrop_plane_3,d2
    move.l 2560,d3
    bsr.w LoadFile

    ;load plane 4
    lea logobasename,a0
    move.b #$64,7(a0)
    move.l a0,d1
    move.l #Backdrop_plane_4,d2
    move.l 2560,d3
    bsr.w LoadFile

    ;load palette
    lea logobasename,a0
    move.b #$65,7(a0)
    move.l a0,d1
    move.l #palette_temp,d2
    move.l #64,d3
    bsr.w LoadFile
;lock
 ;   jmp lock

    lea palette_temp,a0
    lea LogoPalette,a1
    move.l #64,d1
paletteloop:
    move.b (a0)+,(a1)+
    dbra d1,paletteloop
    rts

;LoadFile
;   Expects Filename Addr in d1
;   Expects Dest Addr in d2
;   Expects MaxLen in d3
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
    moveq #0,d6                 ;filesize or 0 if not ok
    move.l lf_fn,d1
    move.l #MODE_OLDFILE,d2     ;mode_old - file must exist
    CALLDOS Open                
    move.l d0,d5                ;copy file handle
    move.l d5,d1                ;filehdl
    move.l lf_dest,d2           ;addr
    move.l lf_maxlen,d3         ;maxlen cap
    CALLDOS Read         
    cmp.l d1,d0 
    bne.s .notok
    move.l d1,d6                ;loading ok! (set to size!)
.notok: 
    move.l d5,d1            
    CALLDOS Close        
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
    cmp.w #$d8,MouseX
    ble hmc_notmusicmenu
    lea music_menu,a0
    bsr.w ShowMenu
    rts
hmc_notmusicmenu
    cmp.w #$d0,MouseX
    ble hmc_notbottommenu
    lea logo_menu,a0
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
    sub.l #6,d0
    cmp.l d1,d0
    bgt hmenuclick_exit
    asl.l #2,d0
    add.l d0,a1
    add.l d0,a2
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
    cmp.l #MENU_ACTION_LOGO,(a1)
    bne hmenuclick_exit
    move.l (a2),d0
    jsr LoadLogoNumber
    jsr CloseMenu
    jmp hmc_exit

hmenuclick_exit
    rts

    
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
    bsr.w CleanRowColors
    MOVEM.l (SP)+,D0-D7/A0-A6 ;Pop regs   
    rts

  
;=============================================================================
DisplayArticleText: 
    lea Article,a2
    move.l current_top_row,d3
    mulu #40,d3
    add.l d3,a2
    move.l #20,d5
    move.l #0,d0
dat_loop
    bsr.w Put40
    add.l #1,d0
    dbra d5,dat_loop
dat_exit
    rts

;=============================================================================
Put40 ;pointer to text in a2, dest row in d0, returns new text addr in a2
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
    move.l #$0444,d1 ;$fff
hmr_setcolor
    bsr.w SetCharRowColor
    dbra d7,hmr_loop    
    rts
;=============================================================================
CleanRowColors:
    moveq.l #20,d7
crc_loop
    move.l d7,d0
    move.l #$0444,d1 ;$fff
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
    include 'data.s'
    include "chipmem.s"

