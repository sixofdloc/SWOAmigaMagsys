;=============================================================================
    ;expects logo number in d0
LoadLogoNumber:
    add.b #$30,d0
    lea logobasename,a0
    move.b d0,6(a0)
    move.b #$61,7(a0)
    bsr.w LoadLogo
;lock:
 ;   jmp lock
    rts

LoadLogo:
    ;load plane 1
    lea logobasename,a0
    move.l a0,d1
    move.l #LoadBuffer,d2
    move.l #2560,d3
    move.l #Backdrop_plane_1,d4
    bsr.w LoadPackedFile

    ;load plane 2
    lea logobasename,a0
    move.b #$62,7(a0)
    move.l a0,d1
    move.l #LoadBuffer,d2
    move.l #2560,d3
    move.l #Backdrop_plane_2,d4
    bsr.w LoadPackedFile

    ;load plane 3
    lea logobasename,a0
    move.b #$63,7(a0)
    move.l a0,d1
    move.l #LoadBuffer,d2
    move.l #2560,d3
    move.l #Backdrop_plane_3,d4
    bsr.w LoadPackedFile

    ;load plane 4
    lea logobasename,a0
    move.b #$64,7(a0)
    move.l a0,d1
    move.l #LoadBuffer,d2
    move.l #2560,d3
    move.l #Backdrop_plane_4,d4
    bsr.w LoadPackedFile

    ;load palette
    lea logobasename,a0
    move.b #$65,7(a0)
    move.l a0,d1
    move.l #palette_temp,d2
    move.l #64,d3
    bsr.w LoadFile

    ;copy palette into copperlist    
    lea palette_temp,a0
    lea LogoPalette,a1
    move.l #64,d1
paletteloop:
    move.b (a0)+,(a1)+
    dbra d1,paletteloop
    rts

;LoadFile
;   Expects Filename Addr in d1
;   Expects Dest Addr in d2
;   Expects MaxLen in d3
lf_fn:
    dc.l 0
lf_dest:
    dc.l 0
lf_maxlen:
    dc.l 0
    
LoadFile:
    move.l d1,lf_fn             
    move.l d2,lf_dest           
    move.l d3,lf_maxlen
    moveq #0,d6                 ;filesize or 0 if not ok
    move.l lf_fn,d1
    move.l #MODE_OLDFILE,d2     ;mode_old - file must exist
    CALLDOS Open            
    cmp #0,d0
    beq error    
    move.l d0,d5                ;copy file handle
    move.l d5,d1                ;filehdl
    move.l lf_dest,d2           ;addr
    move.l lf_maxlen,d3         ;maxlen cap
    CALLDOS Read         
    cmp.l #-1,d0 
    beq.s .notok
    move.l d1,d6
    move.l d5,d1
    CALLDOS Close
    rts                ;loading ok! (set to size!)
.notok: 
    CALLDOS Close        
error
    CALLDOS IoErr
    move.l d0,d1
    move.l #ErrorText,d2
    CALLDOS PrintFault

    move.l #0,d0
errorLoop
    move.w d0,$dff180
    add.w #1,d0
    jmp errorLoop
    rts    

;=============================================================================
; LoadPackedFile - Loads a cranker-packed file and depacks it
; returns 0 in d0 on error
; returns unpacked filesize on successful load
; expects d1 = pointer to filename
;         d2 = location of load buffer (where packed data goes)
;         d3 = maximum file size
;         d4 = location to unpack to (final destination)
lpf_finaldest:
    dc.l 0
lpf_databufferloc:
    dc.l 0
lpf_unpackedsize:
    dc.l 0

LoadPackedFile: 

    ;cache final destination and buffer location
    move.l d2,lpf_databufferloc
    move.l d4,lpf_finaldest 

    ;Load file
    bsr.w LoadFile
    ;set depack pointers
    move.l lpf_databufferloc,d0
    move.l d0,a0  
    move.l lpf_finaldest,d0
    move.l d0,a1
    ;cache unpacked file size
    move.l #0,lpf_unpackedsize
    move.w 2(a0),d0
    move.l d0,lpf_unpackedsize

    cmp.b #$b0,(a0)     ;check for signature byte
    bne LoadPackedFile_err

    ;depacker address is buffer + 4
    add.l #4,a0
    jsr lzodecrunch  ;depack file

    move.l lpf_unpackedsize,d0 ;returned unpacked file size
    rts
LoadPackedFile_err:
    move.l 0,d0
    rts

;=============================================================================
; LoadFont - loads the font associated with an article
; expects d0 = Font # to load

LoadFont ;expects font # in d0
    lea fontfilenames,a0
    move.l a0,d1
    asl #2,d0
    add.l d0,d1
    move.l d1,a0
    move.l (a0),d1
    move.l #UpperFont,d2
    move.l #$400,d3
    bsr.w LoadFile
    rts

;=============================================================================
; LoadArticle - Loads a specified article from cranker packed format
; expects d0 = Number of article to load

CurrentArticle:
    dc.l 0
    
LoadArticle ;expects article # in d0
    move.l d0,CurrentArticle
    move.l #1,loading_article
    jsr ClearTextArea

    ;find our filename
    lea articlefilenames,a0
    move.l a0,d1
    asl.l #2,d0
    add.l d0,d1
    move.l d1,a0
    move.l (a0),d1

    move.l #LoadBuffer,d2
    move.l #$FFFF,d3
    move.l #Article,d4
    ;load the packed article
    bsr.w LoadPackedFile
    ;unpacked size is in d0
    divu #40,d0
    move.l d0,article_rows
    move.l #0,loading_article
    move.l #0,current_top_row
    move.l CurrentArticle,d0
    bsr.w LoadFont
    rts

ClearArticleArea
    lea Article,a0
    move.l #$FFFF,d0
caa_loop
    move.l #0,(a0)+
    dbra d0,caa_loop
    rts
    
FindArticleSize
    lea Article,a0
    moveq.l #0,d6
fas_loop
    move.l (a0)+,d0
    add.l #1,d6
    cmp.l #0,d0
    bne fas_loop
    rts
    
;=============================================================================    
LoadModNumber: ;expects mod # in d0
    move.l d0,current_song
    move.l #1,loading_music
    IFNE MUSIC_SYSTEM
        WaitVRT
        WaitVRT
        jsr PT_End
    ELSE 
       move.l _PlaySidBase,d0
        cmp.l #0,d0
        beq nosidplayloadmod
        CALLPLAYSID StopSong
nosidplayloadmod
    ENDIF
    move.l current_song,d0
    lea modfilenames,a0
    move.l a0,d1
    asl.l #2,d0
    add.l d0,d1
    move.l d1,a0
    move.l (a0),d1
    bsr.w LoadMod
    move.l d6,music_file_len
    bsr.w InitMusic
    move.l #0,loading_music
;lock
;    jmp lock
    rts
    
LoadMod: 
    ;jmp LoadMod
    ;move.l #modfilename,d1
    move.l #Module,d2
    move.l #256000,d3
    bsr.w LoadFile
    rts

