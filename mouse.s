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
    IFEQ MUSIC_SYSTEM
        move.l _PlaySidBase,d0
        cmp.l #0,d0
        beq skipmusicmenu
    ENDIF
    lea music_menu,a0
    bsr.w ShowMenu
skipmusicmenu:
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


