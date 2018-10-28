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
    bne hmenu_notlogo
    move.l (a2),d0
    jsr LoadLogoNumber
    jsr CloseMenu
    jmp hmc_exit
hmenu_notlogo
    cmp.l #MENU_ACTION_SILENCE,(a1)
    bne hmenu_notsilence
    IFNE MUSIC_SYSTEM
        jsr PT_End
    ELSE
       move.l _PlaySidBase,d0
        cmp.l #0,d0
        beq nosidplaynotlogo
        CALLPLAYSID StopSong
nosidplaynotlogo
    ENDIF
    jsr CloseMenu
    jmp hmc_exit
hmenu_notsilence
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
