ClearTextArea:
    MOVEM.l D0-D7/A0-A6,-(SP) ;Push D0-D7/A0-A6 onto the stack
    lea Backdrop,a1
    add.l #72*40,a1
    move.l #21*40*8,d2
cta_loop
    move.b #0,(a1)+
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
    lsl.l #3,d0
    move.l  d0,d2
    lsl.l #2,d0
    add.l   d0,d2
    lsl.l   #3,d2
    add.l  d2,a1
    move.l #39,d4
p40_loop
    moveq   #0,d0
    move.b (a2)+,d0
p40_normalchar    
    bsr.w Putchar
p40_skipchar
    dbra d4,p40_loop
p40_done:      
    MOVEM.l (SP)+,D0-D7/A3-A6 ;Pop regs   
    rts

