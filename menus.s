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
MENU_ACTION_LOGO        EQU 6


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
    dc.b 'Editorial by Scorpion',0
main_menu_option1
    dc.b 'Editorial by Nafcom',0
main_menu_option2
    dc.b 'Information',0
main_menu_option3
    dc.b 'Articles',0
main_menu_option4
    dc.b 'Exit Menu',0
main_menu_option5
    dc.b 'Exit Magazine',0
main_menu_end:
    EVEN

;=============================================================================
;articles menu structure
articles_menu
    dc.l 6  ;top option #
    dc.l articles_menu_optionaddrs
    dc.l articles_menu_lengths
    dc.l articles_menu_title
    dc.l articles_menu_option0-articles_menu_title ;len of title
    dc.l articles_menu_actions
    dc.l articles_menu_params
articles_menu_optionaddrs:
    dc.l articles_menu_option0,articles_menu_option1
    dc.l articles_menu_option2,articles_menu_option3
    dc.l articles_menu_option4,articles_menu_option5
    dc.l articles_menu_option6
articles_menu_lengths
    dc.l (articles_menu_option1 - articles_menu_option0)-1
    dc.l (articles_menu_option2 - articles_menu_option1)-1
    dc.l (articles_menu_option3 - articles_menu_option2)-1
    dc.l (articles_menu_option4 - articles_menu_option3)-1
    dc.l (articles_menu_option5 - articles_menu_option4)-1
    dc.l (articles_menu_option6 - articles_menu_option5)-1
    dc.l (articles_menu_end     - articles_menu_option6)-1
articles_menu_actions:
    dc.l MENU_ACTION_SPAWNMENU, MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU, MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU, MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_CLOSEMENU
articles_menu_params:
    dc.l party_menu,games_scene_menu
    dc.l games_news_menu, interviews_menu
    dc.l ntsc_menu,main_menu
    dc.l 0
articles_menu_title:
    dc.b 'ARTICLES MENU',0
articles_menu_option0
    dc.b 'Party Scene',0
articles_menu_option1
    dc.b 'Games Scene',0
articles_menu_option2
    dc.b 'Games News',0
articles_menu_option3
    dc.b 'Interviews',0
articles_menu_option4
    dc.b 'NTSC Scene',0
articles_menu_option5
    dc.b 31,'Back',0
articles_menu_option6
    dc.b 'Exit Menu',0
articles_menu_end:
    EVEN


;=============================================================================
;party menu structure
party_menu
    dc.l 5  ;top option #
    dc.l party_menu_optionaddrs
    dc.l party_menu_lengths
    dc.l party_menu_title
    dc.l party_menu_option0-party_menu_title ;len of title
    dc.l party_menu_actions
    dc.l party_menu_params
party_menu_optionaddrs:
    dc.l party_menu_option0,party_menu_option1
    dc.l party_menu_option2,party_menu_option3
    dc.l party_menu_option4,party_menu_option5
party_menu_lengths
    dc.l (party_menu_option1-party_menu_option0)-1
    dc.l (party_menu_option2-party_menu_option1)-1
    dc.l (party_menu_option3-party_menu_option2)-1
    dc.l (party_menu_option4-party_menu_option3)-1
    dc.l (party_menu_option5-party_menu_option4)-1
    dc.l (party_menu_end-party_menu_option5)-1
party_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
party_menu_params
    dc.l 3,4,5,6,main_menu,0
party_menu_title:
    dc.b 'PARTY MENU',0
party_menu_option0
    dc.b 'Syntax 2017 Report',0
party_menu_option1
    dc.b 'Revision 2017 Report',0
party_menu_option2
    dc.b 'Homecon',0
party_menu_option3
    dc.b 'Play Expo 2017',0
party_menu_option4
    dc.b 31,'Back',0
party_menu_option5
    dc.b 'Exit Menu',0
party_menu_end:
    EVEN

;=============================================================================
;games scene menu structure
games_scene_menu 

;=============================================================================
;games scene menu structure
games_news_menu 

;=============================================================================
;games scene menu structure
interviews_menu 

;=============================================================================
;John Chowning menu structure
john_menu 

;=============================================================================
;Christian Spanik menu structure
chris_menu 

;=============================================================================
;David Pleasance menu structure
david_menu 


;=============================================================================
;games scene menu structure
ntsc_menu 
    
;=============================================================================
;logo menu structure
logo_menu
    dc.l 4  ;top option #
    dc.l logo_menu_optionaddrs
    dc.l logo_menu_lengths
    dc.l logo_menu_title
    dc.l logo_menu_option0-logo_menu_title ;len of title
    dc.l logo_menu_actions
    dc.l logo_menu_params
logo_menu_optionaddrs:
    dc.l logo_menu_option0,logo_menu_option1,logo_menu_option2,logo_menu_option3
    dc.l logo_menu_option4
logo_menu_lengths
    dc.l (logo_menu_option1-logo_menu_option0)-1,(logo_menu_option2-logo_menu_option1)-1
    dc.l (logo_menu_option3-logo_menu_option2)-1,(logo_menu_option4-logo_menu_option3)-1
    dc.l (logo_menu_end-logo_menu_option4)-1
logo_menu_actions
    dc.l MENU_ACTION_LOGO,MENU_ACTION_LOGO,MENU_ACTION_LOGO,MENU_ACTION_LOGO
    dc.l MENU_ACTION_CLOSEMENU
logo_menu_params
    dc.l 0,1,2,3,0
logo_menu_title:
    dc.b 'LOGO MENU',0
logo_menu_option0
    dc.b 'Logo 1 by JSL',0
logo_menu_option1
    dc.b 'Logo 2 by JSL',0
logo_menu_option2
    dc.b 'Logo 3 by JSL',0
logo_menu_option3
    dc.b 'Logo 4 by Nodepond',0
logo_menu_option4
    dc.b 'Exit Menu',0
logo_menu_end:
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

