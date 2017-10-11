;=============================================================================
    EVEN
MENU_BASE           EQU 0
MENU_OPTIONADDRS    EQU 4
MENU_OPTIONLENGTHS  EQU 8
MENU_TITLEADDR      EQU 12
MENU_TITLELEN       EQU 16
MENU_ACTIONSADDR    EQU 20
MENU_PARAMSADDR     EQU 24


MENU_ACTION_CLOSEMENU   EQU 0
MENU_ACTION_SPAWNMENU   EQU 1
MENU_ACTION_EXITMAGSYS  EQU 2
MENU_ACTION_ARTICLE     EQU 3
MENU_ACTION_MUSIC       EQU 4
MENU_ACTION_SILENCE     EQU 5

;=============================================================================

modfilename0:
    dc.b 'mus/mod.the realm of love',0
modfilename1:
    dc.b 'mus/mod.chipper i',0
modfilename2:
    dc.b 'mus/mod.cucumber boogie+',0
modfilename3:
    dc.b 'mus/fyc.mod',0

modfilenames:
    dc.l modfilename0,modfilename1,modfilename2,modfilename3

articlefilename0:
    dc.b 'articles/editorial.vdo',0 //
articlefilename1:
    dc.b 'articles/27info.vdo',0 //
articlefilename2:
    dc.b 'articles/feedbag.vdo',0 //
articlefilename3:
    dc.b 'articles/pgdc.vdo',0 //
articlefilename4:
    dc.b 'articles/fanzine.vdo',0 //
articlefilename5:
    dc.b 'articles/nolan.vdo',0 //
articlefilename6:
    dc.b 'articles/istvan.vdo',0 //
articlefilename7:
    dc.b 'articles/gleisner.vdo',0 //
articlefilename8:
    dc.b 'articles/mozer.vdo',0 //
articlefilename9:
    dc.b 'articles/melbourne.vdo',0 //
articlefilename10:
    dc.b 'articles/jonhare.vdo',0 //
articlefilename11:
    dc.b 'articles/polyplay.vdo',0
articlefilename12:
    dc.b 'articles/shotgun.vdo',0 //
articlefilename13:
    dc.b 'articles/ntscnews.vdo',0 //
articlefilename14:
    dc.b 'articles/magfest.vdo',0 //
articlefilename15:
    dc.b 'articles/x16report.vdo',0 //
articlefilename16:
    dc.b 'articles/eccc.vdo',0 //
articlefilename17:
    dc.b 'articles/fastloaders.vdo',0 //
articlefilename18:
    dc.b 'articles/gamesnews.vdo',0 //
articlefilename19:
    dc.b 'articles/gamereviews.vdo',0 //
articlefilename20:
    dc.b 'articles/rgdcreport.vdo',0 //
articlefilename21:
    dc.b 'articles/seuck.vdo',0 //
articlefilename22:
    dc.b 'articles/gametut.vdo',0 //
articlefilename23:
    dc.b 'articles/bbsnews.vdo',0 //
articlefilename24:
    dc.b 'articles/bbsage.vdo',0 //
    
articlefilenames:
    dc.l articlefilename0,articlefilename1,articlefilename2,articlefilename3
    dc.l articlefilename4,articlefilename5,articlefilename6,articlefilename7
    dc.l articlefilename8,articlefilename9,articlefilename10,articlefilename11
    dc.l articlefilename12,articlefilename13,articlefilename14,articlefilename15
    dc.l articlefilename16,articlefilename17,articlefilename18,articlefilename19
    dc.l articlefilename20,articlefilename21,articlefilename22,articlefilename23
    dc.l articlefilename24
;=============================================================================
;main menu structure
main_menu
    dc.l 5  ;top option #
    dc.l main_menu_optionaddrs
    dc.l main_menu_lengths
    dc.l main_menu_title
    dc.l 9 ;len of title
    dc.l main_menu_actions
    dc.l main_menu_params
main_menu_optionaddrs:
    dc.l main_menu_option0,main_menu_option1,main_menu_option2,main_menu_option3
    dc.l main_menu_option4,main_menu_option5
main_menu_lengths
    dc.l (main_menu_option1-main_menu_option0)-1,(main_menu_option2-main_menu_option1)-1
    dc.l (main_menu_option3-main_menu_option2)-1,(main_menu_option4-main_menu_option3)-1
    dc.l (main_menu_option5-main_menu_option4)-1,(main_menu_end-main_menu_option5)-1
main_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE,MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_CLOSEMENU,MENU_ACTION_EXITMAGSYS
main_menu_params
    dc.l 0,1,2,articles_menu,0,0
main_menu_title:
    dc.b 'MAIN MENU',0
main_menu_option0
    dc.b 'Editorial',0
main_menu_option1
    dc.b 'Information',0
main_menu_option2
    dc.b 'Feedbag',0
main_menu_option3
    dc.b 'Articles',0
main_menu_option4
    dc.b 'Exit Menu',0
main_menu_option5
    dc.b 'Exit Magazine',0
main_menu_end:
    EVEN


;=============================================================================
;music menu structure
music_menu
    dc.l 5  ;top option #
    dc.l music_menu_optionaddrs
    dc.l music_menu_lengths
    dc.l music_menu_title
    dc.l music_menu_option0-music_menu_title ;len of title
    dc.l music_menu_actions
    dc.l music_menu_params
music_menu_optionaddrs:
    dc.l music_menu_option0,music_menu_option1,music_menu_option2,music_menu_option3
    dc.l music_menu_option4,music_menu_option5
music_menu_lengths
    dc.l (music_menu_option1-music_menu_option0)-1,(music_menu_option2-music_menu_option1)-1
    dc.l (music_menu_option3-music_menu_option2)-1,(music_menu_option4-music_menu_option3)-1
    dc.l (music_menu_option5-music_menu_option4)-1,(music_menu_end-music_menu_option5)-1
music_menu_actions
    dc.l MENU_ACTION_MUSIC,MENU_ACTION_MUSIC,MENU_ACTION_MUSIC,MENU_ACTION_MUSIC
    dc.l MENU_ACTION_SILENCE, MENU_ACTION_CLOSEMENU
music_menu_params
    dc.l 0,1,2,3,0,0
music_menu_title:
    dc.b 'MUSIC MENU',0
music_menu_option0
    dc.b 'The Realm Of Love',0
music_menu_option1
    dc.b 'Chipper I',0
music_menu_option2
    dc.b 'Cucumber Boogie',0
music_menu_option3
    dc.b 'Feed Your Chicken',0
music_menu_option4
    dc.b 'Silence',0
music_menu_option5
    dc.b 'Exit Menu',0
music_menu_end:
    EVEN
;=============================================================================
;articles menu structure
articles_menu
    dc.l 8  ;top option #
    dc.l articles_menu_optionaddrs
    dc.l articles_menu_lengths
    dc.l articles_menu_title
    dc.l articles_menu_option0-articles_menu_title ;len of title
    dc.l articles_menu_actions
    dc.l articles_menu_params
articles_menu_optionaddrs:
    dc.l articles_menu_option0,articles_menu_option1,articles_menu_option2,articles_menu_option3
    dc.l articles_menu_option4,articles_menu_option5,articles_menu_option6,articles_menu_option7
    dc.l articles_menu_option8
articles_menu_lengths
    dc.l (articles_menu_option1-articles_menu_option0)-1,(articles_menu_option2-articles_menu_option1)-1
    dc.l (articles_menu_option3-articles_menu_option2)-1,(articles_menu_option4-articles_menu_option3)-1
    dc.l (articles_menu_option5-articles_menu_option4)-1,(articles_menu_option6-articles_menu_option5)-1
    dc.l (articles_menu_option7-articles_menu_option6)-1,(articles_menu_option8-articles_menu_option7)-1
    dc.l (articles_menu_end-articles_menu_option8)-1
articles_menu_actions:
    dc.l MENU_ACTION_SPAWNMENU, MENU_ACTION_ARTICLE, MENU_ACTION_SPAWNMENU, MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU, MENU_ACTION_SPAWNMENU, MENU_ACTION_SPAWNMENU,MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_CLOSEMENU
articles_menu_params:
    dc.l interviews_menu, 3, unboxings_menu,4
    dc.l palntsc_menu,games_menu,bbs_menu,main_menu,0
articles_menu_title:
    dc.b 'ARTICLES MENU',0
articles_menu_option0
    dc.b 'Interviews',0
articles_menu_option1
    dc.b 'SWO At PGDC',0
articles_menu_option2
    dc.b 'Unboxings',0
articles_menu_option3
    dc.b 'Fanzine Scene',0
articles_menu_option4
    dc.b 'PAL/NTSC Scene',0
articles_menu_option5
    dc.b 'Games Scene',0
articles_menu_option6
    dc.b 'BBS Scene',0
articles_menu_option7
    dc.b 31,'Back',0
articles_menu_option8
    dc.b 'Exit Menu',0
articles_menu_end:
    EVEN
;=============================================================================
;interviews menu structure
interviews_menu
    dc.l 7  ;top option #
    dc.l interviews_menu_optionaddrs
    dc.l interviews_menu_lengths
    dc.l interviews_menu_title
    dc.l interviews_menu_option0-interviews_menu_title ;len of title
    dc.l interviews_menu_actions
    dc.l interviews_menu_params
interviews_menu_optionaddrs:
    dc.l interviews_menu_option0,interviews_menu_option1,interviews_menu_option2,interviews_menu_option3
    dc.l interviews_menu_option4,interviews_menu_option5,interviews_menu_option6,interviews_menu_option7
interviews_menu_lengths
    dc.l (interviews_menu_option1-interviews_menu_option0)-1,(interviews_menu_option2-interviews_menu_option1)-1
    dc.l (interviews_menu_option3-interviews_menu_option2)-1,(interviews_menu_option4-interviews_menu_option3)-1
    dc.l (interviews_menu_option5-interviews_menu_option4)-1,(interviews_menu_option6-interviews_menu_option5)-1
    dc.l (interviews_menu_option7-interviews_menu_option6)-1,(interviews_menu_end-interviews_menu_option7)-1
interviews_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
interviews_menu_params
    dc.l 5,6,7,8,9,10,articles_menu,0
interviews_menu_title:
    dc.b 'INTERVIEWS MENU',0
interviews_menu_option0
    dc.b 'Nolan Bushnell',0
interviews_menu_option1
    dc.b 'Istvan Hegedes',0
interviews_menu_option2
    dc.b 'Christian Gleisner',0
interviews_menu_option3
    dc.b 'Forrest Mozer',0
interviews_menu_option4
    dc.b 'Darren Melbourne',0
interviews_menu_option5
    dc.b 'Jon Hare',0
interviews_menu_option6
    dc.b 31,'Back',0
interviews_menu_option7
    dc.b 'Exit Menu',0
interviews_menu_end:
    EVEN    
;=============================================================================
;unboxings menu structure
unboxings_menu
    dc.l 3  ;top option #
    dc.l unboxings_menu_optionaddrs
    dc.l unboxings_menu_lengths
    dc.l unboxings_menu_title
    dc.l unboxings_menu_option0-unboxings_menu_title ;len of title
    dc.l unboxings_menu_actions
    dc.l unboxings_menu_params
unboxings_menu_optionaddrs:
    dc.l unboxings_menu_option0,unboxings_menu_option1,unboxings_menu_option2,unboxings_menu_option3
unboxings_menu_lengths
    dc.l (unboxings_menu_option1-unboxings_menu_option0)-1,(unboxings_menu_option2-unboxings_menu_option1)-1
    dc.l (unboxings_menu_option3-unboxings_menu_option2)-1,(unboxings_menu_end-unboxings_menu_option3)-1
unboxings_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
unboxings_menu_params
    dc.l 11,12,articles_menu,0
unboxings_menu_title:
    dc.b 'UNBOXINGS MENU',0
unboxings_menu_option0
    dc.b 'Poly Play',0
unboxings_menu_option1
    dc.b 'Shotgun',0
unboxings_menu_option2
    dc.b 31,'Back',0
unboxings_menu_option3
    dc.b 'Exit Menu',0
unboxings_menu_end:
    EVEN
    
;=============================================================================
;palntsc menu structure
palntsc_menu
    dc.l 6  ;top option #
    dc.l palntsc_menu_optionaddrs
    dc.l palntsc_menu_lengths
    dc.l palntsc_menu_title
    dc.l palntsc_menu_option0-palntsc_menu_title ;len of title
    dc.l palntsc_menu_actions
    dc.l palntsc_menu_params
palntsc_menu_optionaddrs:
    dc.l palntsc_menu_option0,palntsc_menu_option1,palntsc_menu_option2,palntsc_menu_option3
    dc.l palntsc_menu_option4,palntsc_menu_option5,palntsc_menu_option6
palntsc_menu_lengths
    dc.l (palntsc_menu_option1-palntsc_menu_option0)-1,(palntsc_menu_option2-palntsc_menu_option1)-1
    dc.l (palntsc_menu_option3-palntsc_menu_option2)-1,(palntsc_menu_option4-palntsc_menu_option3)-1
    dc.l (palntsc_menu_option5-palntsc_menu_option4)-1,(palntsc_menu_option6-palntsc_menu_option5)-1
    dc.l (palntsc_menu_end-palntsc_menu_option6)-1
palntsc_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
palntsc_menu_params
    dc.l 13,14,15,16,17,articles_menu,0
palntsc_menu_title:
    dc.b 'PAL/NTSC SCENE MENU',0
palntsc_menu_option0
    dc.b 'NTSC News',0
palntsc_menu_option1
    dc.b 'Magfest',0
palntsc_menu_option2
    dc.b 'X16 Report',0
palntsc_menu_option3
    dc.b 'ECCC VCFMW Report',0
palntsc_menu_option4
    dc.b 'The Fastloaders Concert',0
palntsc_menu_option5
    dc.b 31,'Back',0
palntsc_menu_option6
    dc.b 'Exit Menu',0
palntsc_menu_end:
    EVEN    
    
;=============================================================================
;games menu structure
games_menu
    dc.l 6  ;top option #
    dc.l games_menu_optionaddrs
    dc.l games_menu_lengths
    dc.l games_menu_title
    dc.l games_menu_option0-games_menu_title ;len of title
    dc.l games_menu_actions
    dc.l games_menu_params
games_menu_optionaddrs:
    dc.l games_menu_option0,games_menu_option1,games_menu_option2,games_menu_option3
    dc.l games_menu_option4,games_menu_option5,games_menu_option6
games_menu_lengths
    dc.l (games_menu_option1-games_menu_option0)-1,(games_menu_option2-games_menu_option1)-1
    dc.l (games_menu_option3-games_menu_option2)-1,(games_menu_option4-games_menu_option3)-1
    dc.l (games_menu_option5-games_menu_option4)-1,(games_menu_option6-games_menu_option5)-1
    dc.l (games_menu_end-games_menu_option6)-1
games_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
games_menu_params
    dc.l 18,19,20,21,22,articles_menu,0
games_menu_title:
    dc.b 'GAMES SCENE MENU',0
games_menu_option0
    dc.b 'Games News',0
games_menu_option1
    dc.b 'Game Reviews',0
games_menu_option2
    dc.b 'RGDC Report',0
games_menu_option3
    dc.b 'SEUCK Compo',0
games_menu_option4
    dc.b 'Game Making Tutorial',0
games_menu_option5
    dc.b 31,'Back',0
games_menu_option6
    dc.b 'Exit Menu',0
games_menu_end:
    EVEN        
    
;=============================================================================
;bbs menu structure
bbs_menu
    dc.l 3  ;top option #
    dc.l bbs_menu_optionaddrs
    dc.l bbs_menu_lengths
    dc.l bbs_menu_title
    dc.l bbs_menu_option0-bbs_menu_title ;len of title
    dc.l bbs_menu_actions
    dc.l bbs_menu_params
bbs_menu_optionaddrs:
    dc.l bbs_menu_option0,bbs_menu_option1,bbs_menu_option2,bbs_menu_option3
 
bbs_menu_lengths
    dc.l (bbs_menu_option1-bbs_menu_option0)-1,(bbs_menu_option2-bbs_menu_option1)-1
    dc.l (bbs_menu_option3-bbs_menu_option2)-1,(bbs_menu_end-bbs_menu_option3)-1
bbs_menu_actions
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
bbs_menu_params
    dc.l 23,24,articles_menu,0
bbs_menu_title:
    dc.b 'BBS SCENE MENU',0
bbs_menu_option0
    dc.b 'BBS News',0
bbs_menu_option1
    dc.b 'BBS Comes Of Age',0
bbs_menu_option2
    dc.b 31,'Back',0
bbs_menu_option3
    dc.b 'Exit Menu',0
bbs_menu_end:
    EVEN        
    