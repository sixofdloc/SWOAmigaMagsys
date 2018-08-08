    section fish,data

    include 'filenames.s'
    include 'menus.s'

charcolors
    dc.l charcolor0,charcolor1,charcolor2,charcolor3,charcolor4,charcolor5
    dc.l charcolor6,charcolor7,charcolor8,charcolor9,charcolor10,charcolor11
    dc.l charcolor12,charcolor13,charcolor14,charcolor15,charcolor16
    dc.l charcolor17,charcolor18,charcolor19,charcolor20

palette_temp:
    ds.b 80,0
 
;menu variables for mouseover
menu_active
    dc.l 0

current_menu_addr
    dc.l 0

exitflag
    dc.l 0

loading_music
    dc.l 0

current_song
    dc.l 0
    
current_mouse_row
    dc.l 0
    
loading_article ;flag to keep from reloading article
    dc.l 0
article_rows ;number of rows in article
    dc.l 0
current_top_row ;currently displayed article row at top of screen
    dc.l 0
  
mouse_debounce
    dc.l 0

music_file_len
    dc.l 0

    EVEN

;mouse variables
MouseY:
        dc.w    0
MouseX:
        dc.w    0
;oldhorizcnt:
;        ds.b    1
;oldvertcnt:
;        ds.b    1
OldDeltaY:      
    dc.w    0
OldDeltaX:      
    dc.w    0
   
    EVEN
ColorBarTable:
    ds.w $80,0
    EVEN



LoadingText:
    dc.b 'LOADING',0
    EVEN
   
;library names
GraphicsName:
    GRAFNAME
    EVEN

DOSName:
    DOSNAME
    EVEN

PlaySIDName:
    PLAYSIDNAME    
    EVEN

Article
    ds.b 128000,0


;        section DemoBSS,BSS
OldIntSave: 
    ds.l    1
Level3Save: 
    ds.l    1
_GfxBase    
    ds.l    1       ; pointer to graphics base
_DOSBase    
    ds.l    1 
_PlaySidBase
    ds.l    1  
OldView     
    ds.l    1       ; old Work Bench view addr.
VectorBase: 
    ds.l    1       ; pointer to the Vector Base
OldDMACon:  
    ds.w    1       ; old dmacon bits
OldINTEna:  
    ds.w    1       ; old intena bits

