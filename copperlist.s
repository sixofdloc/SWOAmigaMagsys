    
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

    include "raw/sceneworld2.iff.cmap"
BitmapPointers:
    dc.w _bpl1pth,$0000
    dc.w _bpl1ptl,$0000
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
    dc.w $2c0f,$fffe
    dc.w _color15
logo_outline_color:
    dc.w $0ff0
    dc.w $2d0f,$fffe
    dc.w _color14
logo_background_colors:
    dc.w $0000
    dc.w $2e0f,$fffe
    dc.w _color14,$0000
    dc.w $2f0f,$fffe
    dc.w _color14,$0ddd
    dc.w $300f,$fffe
    dc.w _color14,$0ccc
    dc.w $310f,$fffe
    dc.w _color14,$0bbb
    dc.w $320f,$fffe
    dc.w _color14,$0aaa
    dc.w $330f,$fffe
    dc.w _color14,$0999
    dc.w $340f,$fffe
    dc.w _color14,$0888
    dc.w $350f,$fffe
    dc.w _color14,$0777
    dc.w $360f,$fffe
    dc.w _color14,$0666
    dc.w $370f,$fffe
    dc.w _color14,$0555
    dc.w $380f,$fffe
    dc.w _color14,$0444
    dc.w $390f,$fffe
    dc.w _color14,$0333
    dc.w $3a0f,$fffe
    dc.w _color14,$0222
    dc.w $3b0f,$fffe
    dc.w _color14,$0111
    dc.w $3c0f,$fffe
    dc.w _color14,$0000
    dc.w $3d0f,$fffe
    dc.w _color14,$0f00
    dc.w $3e0f,$fffe
    dc.w _color14,$0e00
    dc.w $3f0f,$fffe
    dc.w _color14,$0d00
    dc.w $400f,$fffe
    dc.w _color14,$0c00
    dc.w $410f,$fffe
    dc.w _color14,$0b00
    dc.w $420f,$fffe
    dc.w _color14,$0a00
    dc.w $430f,$fffe
    dc.w _color14,$0900
    dc.w $440f,$fffe
    dc.w _color14,$0800
    dc.w $450f,$fffe
    dc.w _color14,$0700
    dc.w $460f,$fffe
    dc.w _color14,$0600
    dc.w $470f,$fffe
    dc.w _color14,$0500
    dc.w $480f,$fffe
    dc.w _color14,$0400
    dc.w $490f,$fffe
    dc.w _color14,$0300
    dc.w $4a0f,$fffe
    dc.w _color14,$0200
    dc.w $4b0f,$fffe
    dc.w _color14,$0100
    dc.w $4c0f,$fffe
    dc.w _color14,$0000
    dc.w $4d0f,$fffe
    dc.w _color14,$00f0
    dc.w $4e0f,$fffe
    dc.w _color14,$00e0
    dc.w $4f0f,$fffe
    dc.w _color14,$00d0
    dc.w $500f,$fffe
    dc.w _color14,$00c0
    dc.w $510f,$fffe
    dc.w _color14,$00b0
    dc.w $520f,$fffe
    dc.w _color14,$00a0
    dc.w $530f,$fffe
    dc.w _color14,$0090
    dc.w $540f,$fffe
    dc.w _color14,$0080
    dc.w $550f,$fffe
    dc.w _color14,$0070
    dc.w $560f,$fffe
    dc.w _color14,$0060
    dc.w $570f,$fffe
    dc.w _color14,$0050
    dc.w $580f,$fffe
    dc.w _color14,$0040
    dc.w $590f,$fffe
    dc.w _color14,$0030
    dc.w $5a0f,$fffe
    dc.w _color14,$0020
    dc.w $5b0f,$fffe
    dc.w _color14,$0010
    dc.w $5c0f,$fffe
    dc.w _color14,$0000
    dc.w $5d0f,$fffe
    dc.w _color14,$00f0
    dc.w $5e0f,$fffe
    dc.w _color14,$00e0
    dc.w $5f0f,$fffe
    dc.w _color14,$00d0
    dc.w $600f,$fffe
    dc.w _color14,$00c0
    dc.w $610f,$fffe
    dc.w _color14,$00b0
    dc.w $620f,$fffe
    dc.w _color14,$00a0
    dc.w $630f,$fffe
    dc.w _color14,$0090
    dc.w $640f,$fffe
    dc.w _color14,$0080
    dc.w $650f,$fffe
    dc.w _color14,$0070
    dc.w $660f,$fffe
    dc.w _color14,$0060
    dc.w $670f,$fffe
    dc.w _color14,$0050
    dc.w $680f,$fffe
    dc.w _color14,$0fff
    dc.w $690f,$fffe
    dc.w _color14,$0fff
 ;main magsys text window
    dc.w $6e0f,$fffe
    dc.w _color00,$0111
    dc.w $6f0f,_copwait
    dc.w _color00,$0222
    dc.w $700f,_copwait
    dc.w _color00,$0333
    dc.w $710f,_copwait
    dc.w _color00,$0444
    dc.w $720f,_copwait
    dc.w _color00,$0555
    dc.w $730f,_copwait
    dc.w _color00,$0666
;char row 0
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
;fade out
    dc.w $1c0f,_copwait
    dc.w _color00,$0555
    dc.w $1d0f,_copwait
    dc.w _color00,$0444
    dc.w $1e0f,_copwait
    dc.w _color00,$0333
    dc.w $1f0f,_copwait
    dc.w _color00,$0222
    dc.w $200f,_copwait
    dc.w _color00,$0111
    dc.w $210f,_copwait
    dc.w _color00,$0000
    

EndCopper:
    dc.l  -2,-2
