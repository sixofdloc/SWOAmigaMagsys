    
Copper:
    dc.w _diwstrt,$2c81
    dc.w _diwstop,$2cc1
    dc.w _ddfstrt,$0038
    dc.w _ddfstop,$00d0
    dc.w _bplcon0,$4200
    dc.w _bplcon1,$0000
    dc.w _bplcon2,$0024
    dc.w _bpl1mod,$0000
    dc.w _bpl2mod,$0000
    dc.w _bplcon4,$0000
    dc.w _brstmod,$0000
LogoPalette:
    incbin "logos/1e" ;default palette
    
BitmapPointers:
    dc.w _bpl1pth
Bitplane1H:
    dc.w $0000
    dc.w _bpl1ptl
Bitplane1L:
    dc.w $0000
    dc.w _bpl2pth,$0000
    dc.w _bpl2ptl,$0000
    dc.w _bpl3pth,$0000
    dc.w _bpl3ptl,$0000
    dc.w _bpl4pth,$0000
    dc.w _bpl4ptl,$0000
    dc.w _bpl5pth,$0000
    dc.w _bpl5ptl,$0000
    dc.w _bpl6pth,$0000
    dc.w _bpl6ptl,$0000
SpritePointers:
    dc.w _spr0pth,$0000
    dc.w _spr0ptl,$0000
    dc.w _spr1ptl,$0000
    dc.w _spr1pth,$0000
    dc.w _spr2ptl,$0000
    dc.w _spr2pth,$0000
    dc.w _spr3ptl,$0000
    dc.w _spr3pth,$0000
    dc.w _spr4ptl,$0000
    dc.w _spr4pth,$0000
    dc.w _spr5ptl,$0000
    dc.w _spr5pth,$0000
    dc.w _spr6ptl,$0000
    dc.w _spr6pth,$0000
    dc.w _spr7ptl,$0000
    dc.w _spr7pth,$0000

 ;main magsys text window, background color fade in
    dc.w $6e0f,$fffe
    dc.w _color00,$0222
    dc.w $6f0f,_copwait
    dc.w _color00,$0444
    dc.w $700f,_copwait
    dc.w _color00,$0666
    dc.w $710f,_copwait
    dc.w _color00,$0888
    dc.w $720f,_copwait
    dc.w _color00,$0aaa
    dc.w $730f,_copwait
    dc.w _color00,$0ccc
;main magsys text window, char row 0
    dc.w $740f,_copwait
    dc.w _color01
charcolor0:
    dc.w $0fff
;char row 1
    dc.w $7c0f,_copwait
    dc.w _color01
charcolor1:
    dc.w $0fff
;char row 2
    dc.w $840f,_copwait
    dc.w _color01
charcolor2:
    dc.w $0f00
;char row 3
    dc.w $8C0f,_copwait
    dc.w _color01
charcolor3:
    dc.w $00ff
;char row 4
    dc.w $940f,_copwait
    dc.w _color01
charcolor4:
    dc.w $00f0
;char row 5
    dc.w $9C0f,_copwait
    dc.w _color01
charcolor5:
    dc.w $000f
;char row 6
    dc.w $a40f,_copwait
    dc.w _color01
charcolor6:
    dc.w $0ff0
;char row 7
    dc.w $ac0f,_copwait
    dc.w _color01
charcolor7:
    dc.w $0fff
;char row 8
    dc.w $b40f,_copwait
    dc.w _color01
charcolor8:
    dc.w $0fff
;char row 9
    dc.w $bc0f,_copwait
    dc.w _color01
charcolor9:
    dc.w $0fff
;char row 10
    dc.w $c40f,_copwait
    dc.w _color01
charcolor10:
    dc.w $0fff
;char row 11
    dc.w $cc0f,_copwait
    dc.w _color01
charcolor11:
    dc.w $0fff
;char row 12
    dc.w $d40f,_copwait
    dc.w _color01
charcolor12:
    dc.w $0fff
;char row 13
    dc.w $dc0f,_copwait
    dc.w _color01
charcolor13:
    dc.w $0fff
;char row 14
    dc.w $e40f,_copwait
    dc.w _color01
charcolor14:
    dc.w $0fff
;char row 15
    dc.w $ec0f,_copwait
    dc.w _color01
charcolor15:
    dc.w $00f
;char row 16
    dc.w $f40f,_copwait
    dc.w _color01
charcolor16:
    dc.w $0fff
;char row 17
    dc.w $fc0f,_copwait
    dc.w _color01
charcolor17:
    dc.w $0fff
    
    dc.w $ffdf,_copwait
;char row 18
    dc.w $040f,_copwait
    dc.w _color01
charcolor18:
    dc.w $0fff
;char row 19
    dc.w $0c0f,_copwait
    dc.w _color01
charcolor19:
    dc.w $0fff
;char row 20
    dc.w $140f,_copwait
    dc.w _color01
charcolor20:
    dc.w $0fff

;main window text area background fade out
    dc.w $1c0f,_copwait
    dc.w _color00,$0ccc
    dc.w $1d0f,_copwait
    dc.w _color00,$0aaa
    dc.w $1e0f,_copwait
    dc.w _color00,$0888
    dc.w $1f0f,_copwait
    dc.w _color00,$0666
    dc.w $200f,_copwait
    dc.w _color00,$0444
    dc.w $210f,_copwait
    dc.w _color00,$0222

;bottom menu bar palette
    dc.w _color01,$0fff
    dc.w _color02,$0444
    dc.w _color03,$0888

EndCopper:
    dc.l  -2,-2
