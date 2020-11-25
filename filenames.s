;=============================================================================
; Music filenames
;=============================================================================
modfilename0:
    dc.b 'sid/BeautifulMoment.sid',0
modfilename1:
    dc.b 'sid/CarribeanTrip.sid',0
modfilename2:
    dc.b 'sid/DystopianShock.sid',0
modfilename3:
    dc.b 'sid/MyHoneybee.sid',0

modfilenames:
    dc.l modfilename0,modfilename1,modfilename2,modfilename3

;=============================================================================
; Logo filenames
;=============================================================================
logobasename:
	dc.b 'logos/0a',0

;=============================================================================
; Article filenames
;=============================================================================
articlefilename0:
    dc.b 'articles/editorial.pak',0 ;Editorial
articlefilename1:
    dc.b 'articles/swofeedback30.pak',0  ;Feedback
articlefilename2:
    dc.b 'articles/30info.pak',0  ;SWO Info

articlefilename3:
    dc.b 'articles/back1.pak',0 
articlefilename4:
    dc.b 'articles/back2.pak',0 
articlefilename5:
    dc.b 'articles/back3.pak',0 
articlefilename6:
    dc.b 'articles/back4.pak',0 
articlefilename7:
    dc.b 'articles/back5.pak',0 
articlefilename8:
    dc.b 'articles/back6.pak',0
articlefilename9:
    dc.b 'articles/biggi1.pak',0 
articlefilename10:
    dc.b 'articles/biggi2.pak',0 
articlefilename11:
    dc.b 'articles/biggi3.pak',0
articlefilename12:
    dc.b 'articles/biggi4.pak',0 
articlefilename13:
    dc.b 'articles/gamescon2019.pak',0 
articlefilename14:
    dc.b 'articles/gamenews1.pak',0 
articlefilename15:
    dc.b 'articles/gamenews2.pak',0 
articlefilename16:
    dc.b 'articles/gamenews3.pak',0 
articlefilename17:
    dc.b 'articles/gamenews4.pak',0 
articlefilename18:
    dc.b 'articles/gamenews5.pak',0 
articlefilename19:
    dc.b 'articles/thec64programmingchallenge.pak',0 
articlefilename20:
    dc.b 'articles/thec64unboxing.pak',0 
articlefilename21:
    dc.b 'articles/welleerdball.pak',0 
    
articlefilenames:
    dc.l articlefilename0,articlefilename1,articlefilename2,articlefilename3
    dc.l articlefilename4,articlefilename5,articlefilename6,articlefilename7
    dc.l articlefilename8,articlefilename9,articlefilename10,articlefilename11
    dc.l articlefilename12,articlefilename13,articlefilename14,articlefilename15
    dc.l articlefilename16,articlefilename17,articlefilename18,articlefilename19
    dc.l articlefilename20,articlefilename21

    IFNE CUSTOM_FONTS
;=============================================================================
; Font filenames
;=============================================================================
fontfilename0:
    dc.b 'fonts/editorial.fon',0 
fontfilename1:
    dc.b 'fonts/nafcom.fon',0 
fontfilename2:
    dc.b 'fonts/28info.fon',0 
;party menu
fontfilename3:
    dc.b 'fonts/syntax.fon',0 
fontfilename4:
    dc.b 'fonts/revision.fon',0 
fontfilename5:
    dc.b 'fonts/homecon.fon',0 
fontfilename6:
    dc.b 'fonts/expo.fon',0 

;games scene menu
fontfilename7:
    dc.b 'fonts/8bit.fon',0 
fontfilename8:
    dc.b 'fonts/mkgm1.fon',0
fontfilename9:
    dc.b 'fonts/mkgm2.fon',0 

;games news menu
fontfilename10:
    dc.b 'fonts/gnews1.fon',0 
fontfilename11:
    dc.b 'fonts/gnews2.fon',0
fontfilename12:
    dc.b 'fonts/gnews3.fon',0 
fontfilename13:
    dc.b 'fonts/gnews4.fon',0 
fontfilename14:
    dc.b 'fonts/gnews5.fon',0 
fontfilename15:
    dc.b 'fonts/gnews6.fon',0 
fontfilename16:
    dc.b 'fonts/gnews7.fon',0 

;interviews/John Chowning menu
fontfilename17:
    dc.b 'fonts/john1.fon',0 
fontfilename18:
    dc.b 'fonts/john2.fon',0 
fontfilename19:
    dc.b 'fonts/john3.fon',0 

;interviews/Christian Spanik
fontfilename20:
    dc.b 'fonts/chris1.fon',0 
fontfilename21:
    dc.b 'fonts/chris2.fon',0 
fontfilename22:
    dc.b 'fonts/chris3.fon',0 
fontfilename23:
    dc.b 'fonts/chris4.fon',0 

;interviews/David Pleasance
fontfilename24:
    dc.b 'fonts/david1.fon',0 
fontfilename25:
    dc.b 'fonts/david2.fon',0 
fontfilename26:
    dc.b 'fonts/david3.fon',0 
fontfilename27:
    dc.b 'fonts/david4.fon',0 
fontfilename28:
    dc.b 'fonts/david5.fon',0 
fontfilename29:
    dc.b 'fonts/david6.fon',0 
fontfilename30:
    dc.b 'fonts/david7.fon',0 
fontfilename31:
    dc.b 'fonts/david8.fon',0 
fontfilename32:
    dc.b 'fonts/david9.fon',0 

;interviews
fontfilename33:
    dc.b 'fonts/dennis.fon',0

;ntsc news
fontfilename34:
    dc.b 'fonts/ntsc1.fon',0 
fontfilename35:
    dc.b 'fonts/ntsc2.fon',0 

;forgotten above
fontfilename36:
    dc.b 'fonts/review.fon',0
    
fontfilenames:
    dc.l fontfilename0,fontfilename1,fontfilename2,fontfilename3
    dc.l fontfilename4,fontfilename5,fontfilename6,fontfilename7
    dc.l fontfilename8,fontfilename9,fontfilename10,fontfilename11
    dc.l fontfilename12,fontfilename13,fontfilename14,fontfilename15
    dc.l fontfilename16,fontfilename17,fontfilename18,fontfilename19
    dc.l fontfilename20,fontfilename21,fontfilename22,fontfilename23
    dc.l fontfilename24,fontfilename25,fontfilename26,fontfilename27
    dc.l fontfilename28,fontfilename29,fontfilename30,fontfilename31
    dc.l fontfilename32,fontfilename33,fontfilename34,fontfilename35
    dc.l fontfilename36
    ENDIF ;custom fonts

