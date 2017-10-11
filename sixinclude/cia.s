;=============================================================================
; CIA Constants
;=============================================================================
CIAA        equ $bfe001 ; CIAA base address
CIAB        equ $bfd000 ; CIAB base address
PRA     equ $000    ; Peripheral Data Register for port A
PRB     equ $100    ; Peripheral Data Register for port B
DDRA        equ $200    ; Data Direction Register A
DDRB        equ $300    ; Data Direction Register B
TALO        equ $400    ; Timer A Low Byte
TAHI        equ $500    ; Timer A High Byte
TBLO        equ $600    ; Timer B Low Byte
TBHI        equ $700    ; Timer B High Byte
TODLO       equ $800    ; TOD Counter Low Byte
TODMID      equ $900    ; TOD Counter Mid Byte
TODHI       equ $a00    ; TOD Counter High Byte
TODHR       equ $b00    ; Unused
SDR     equ $c00    ; Serial Data Register
ICR     equ $d00    ; Interrupt Control Register
CRA     equ $e00    ; Control Register A
CRB     equ $f00    ; Control Register B
