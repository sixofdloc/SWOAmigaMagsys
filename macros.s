;=============================================================================
; Macros
;=============================================================================

    macro CALL
        jsr _LVO\1(a6)
    endm
    
    macro WaitBlit
        tst.b   (a5)
.\@:        
        btst.b  #6,(a5)
        bne.b   .\@
    endm
   macro WaitVRT
.\@: 
    cmp.b #$ff,$dff006      ; Simple beampos-wait
    bne.s .\@
.\@1:    cmp.b #$ff,$dff006
         beq.s .\@1
    endm