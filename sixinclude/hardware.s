;=============================================================================
; Hardware Registers
;=============================================================================
CUSTOM      equ $dff000 ; Custom chips base address

DMACONR         EQU     $dff002
ADKCONR         EQU     $dff010
INTENAR         EQU     $dff01c
INTREQR         EQU     $dff01e

DMACON          EQU     $dff096
ADKCON          EQU     $dff09e
INTENA          EQU     $dff09a
INTREQ          EQU     $dff09c

BPLCON0         EQU     $dff100
BPLCON1         EQU     $dff102
BPL1MOD         EQU     $dff108
BPL2MOD         EQU     $dff10a
DIWSTRT         EQU     $dff08e
DIWSTOP         EQU     $dff090
DDFSTRT         EQU     $dff092
DDFSTOP         EQU     $dff094
VPOSR           EQU     $dff004
COP1LCH         EQU     $dff080

CIAAPRA         EQU     $bfe001
