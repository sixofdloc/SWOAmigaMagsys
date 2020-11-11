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
Backdrop_plane_1:
    ds.b 2560,0;incbin "logos/1a" ; default logo
    ds.b 7240,0
    incbin "graphics/mba" ;menubar graphic
Backdrop_plane_2:
    ds.b 2560,0;incbin "logos/1b" 
    ds.b 7240,0
    incbin "graphics/mbb"
Backdrop_plane_3:
    ds.b 2560,0;incbin "logos/1c" 
    ds.b 7240,0
    incbin "graphics/mbc"
Backdrop_plane_4:
    ds.b 2560,0;incbin "logos/1d" 
    ds.b 7240,0
    incbin "graphics/mbd"

mt_Counter:
    dc.b 0,0,0,0

Font:
    incbin  'graphics/basefont'
UpperFont:
    incbin 'fonts/editorial.fon'

Module:
    ds.b 256000,0

;=============================================================================

