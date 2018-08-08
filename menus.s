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
    dc.b 'ARTICLES',0
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
    dc.b 'PARTY REPORTS',0
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
    dc.l 5  ;top option #
    dc.l games_scene_menu_optionaddrs
    dc.l games_scene_menu_lengths
    dc.l games_scene_menu_title
    dc.l games_scene_menu_option0-games_scene_menu_title ;len of title
    dc.l games_scene_menu_actions
    dc.l games_scene_menu_params
games_scene_menu_optionaddrs:
    dc.l games_scene_menu_option0,games_scene_menu_option1
    dc.l games_scene_menu_option2,games_scene_menu_option3
    dc.l games_scene_menu_option4,games_scene_menu_option5
games_scene_menu_lengths
    dc.l (games_scene_menu_option1-games_scene_menu_option0)-1
    dc.l (games_scene_menu_option2-games_scene_menu_option1)-1
    dc.l (games_scene_menu_option3-games_scene_menu_option2)-1
    dc.l (games_scene_menu_option4-games_scene_menu_option3)-1
    dc.l (games_scene_menu_option5-games_scene_menu_option4)-1
    dc.l (games_scene_menu_end-games_scene_menu_option5)-1
games_scene_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
games_scene_menu_params
    dc.l 36,7,8,9
    dc.l main_menu,0
games_scene_menu_title:
    dc.b 'GAMES SCENE',0
games_scene_menu_option0
    dc.b 'Game Reviews',0
games_scene_menu_option1
    dc.b '8-bit Philosophy Part 2',0
games_scene_menu_option2
    dc.b 'Let',$27,'s Make a Game 1',0
games_scene_menu_option3
    dc.b 'Let',$27,'s Make a Game 2',0
games_scene_menu_option4
    dc.b 31,'Back',0
games_scene_menu_option5
    dc.b 'Exit Menu',0
games_scene_menu_end:
    EVEN

;=============================================================================
;games news menu structure
games_news_menu 
    dc.l 8  ;top option #
    dc.l games_news_menu_optionaddrs
    dc.l games_news_menu_lengths
    dc.l games_news_menu_title
    dc.l games_news_menu_option0-games_news_menu_title ;len of title
    dc.l games_news_menu_actions
    dc.l games_news_menu_params
games_news_menu_optionaddrs:
    dc.l games_news_menu_option0,games_news_menu_option1
    dc.l games_news_menu_option2,games_news_menu_option3
    dc.l games_news_menu_option4,games_news_menu_option5
    dc.l games_news_menu_option6,games_news_menu_option7
    dc.l games_news_menu_option8
games_news_menu_lengths
    dc.l (games_news_menu_option1-games_news_menu_option0)-1
    dc.l (games_news_menu_option2-games_news_menu_option1)-1
    dc.l (games_news_menu_option3-games_news_menu_option2)-1
    dc.l (games_news_menu_option4-games_news_menu_option3)-1
    dc.l (games_news_menu_option5-games_news_menu_option4)-1
    dc.l (games_news_menu_option6-games_news_menu_option5)-1
    dc.l (games_news_menu_option7-games_news_menu_option6)-1
    dc.l (games_news_menu_option8-games_news_menu_option7)-1
    dc.l (games_news_menu_end-games_news_menu_option8)-1
games_news_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_CLOSEMENU
games_news_menu_params
    dc.l 10,11,12,13,14,15,16
    dc.l main_menu,0
games_news_menu_title:
    dc.b 'GAMES NEWS',0
games_news_menu_option0
    dc.b 'Part 1',0
games_news_menu_option1
    dc.b 'Part 2',0
games_news_menu_option2
    dc.b 'Part 3',0
games_news_menu_option3
    dc.b 'Part 4',0
games_news_menu_option4
    dc.b 'Part 5',0
games_news_menu_option5
    dc.b 'Part 6',0
games_news_menu_option6
    dc.b 'Part 7',0
games_news_menu_option7
    dc.b 31,'Back',0
games_news_menu_option8
    dc.b 'Exit Menu',0
games_news_menu_end:
    EVEN

;=============================================================================
;interviews menu structure
interviews_menu 
    dc.l 5  ;top option #
    dc.l interviews_menu_optionaddrs
    dc.l interviews_menu_lengths
    dc.l interviews_menu_title
    dc.l interviews_menu_option0-interviews_menu_title ;len of title
    dc.l interviews_menu_actions
    dc.l interviews_menu_params
interviews_menu_optionaddrs:
    dc.l interviews_menu_option0,interviews_menu_option1
    dc.l interviews_menu_option2,interviews_menu_option3
    dc.l interviews_menu_option4,interviews_menu_option5
interviews_menu_lengths
    dc.l (interviews_menu_option1-interviews_menu_option0)-1
    dc.l (interviews_menu_option2-interviews_menu_option1)-1
    dc.l (interviews_menu_option3-interviews_menu_option2)-1
    dc.l (interviews_menu_option4-interviews_menu_option3)-1
    dc.l (interviews_menu_option5-interviews_menu_option4)-1
    dc.l (interviews_menu_end-interviews_menu_option5)-1
interviews_menu_actions
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
interviews_menu_params
    dc.l john_menu,chris_menu,33,david_menu
    dc.l main_menu,0
interviews_menu_title:
    dc.b 'INTERVIEWS',0
interviews_menu_option0
    dc.b 'John Chowning',0
interviews_menu_option1
    dc.b 'Christian Spanik',0
interviews_menu_option2
    dc.b 'Dennis Pauler',0
interviews_menu_option3
    dc.b 'David Pleasance',0
interviews_menu_option4
    dc.b 31,'Back',0
interviews_menu_option5
    dc.b 'Exit Menu',0
interviews_menu_end:
    EVEN
;=============================================================================
;John Chowning menu structure
john_menu 
   dc.l 4  ;top option #
    dc.l john_menu_optionaddrs
    dc.l john_menu_lengths
    dc.l john_menu_title
    dc.l john_menu_option0-john_menu_title ;len of title
    dc.l john_menu_actions
    dc.l john_menu_params
john_menu_optionaddrs:
    dc.l john_menu_option0,john_menu_option1
    dc.l john_menu_option2,john_menu_option3
    dc.l john_menu_option4
john_menu_lengths
    dc.l (john_menu_option1-john_menu_option0)-1
    dc.l (john_menu_option2-john_menu_option1)-1
    dc.l (john_menu_option3-john_menu_option2)-1
    dc.l (john_menu_option4-john_menu_option3)-1
    dc.l (john_menu_end-john_menu_option4)-1
john_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_CLOSEMENU
john_menu_params
    dc.l 17,18,19
    dc.l interviews_menu,0
john_menu_title:
    dc.b 'JOHN CHOWNING INTERVIEW',0
john_menu_option0
    dc.b 'Part 1',0
john_menu_option1
    dc.b 'Part 2',0
john_menu_option2
    dc.b 'Part 3',0
john_menu_option3
    dc.b 31,'Back',0
john_menu_option4
    dc.b 'Exit Menu',0
john_menu_end:
    EVEN


;=============================================================================
;Christian Spanik menu structure
chris_menu 
   dc.l 5  ;top option #
    dc.l chris_menu_optionaddrs
    dc.l chris_menu_lengths
    dc.l chris_menu_title
    dc.l chris_menu_option0-chris_menu_title ;len of title
    dc.l chris_menu_actions
    dc.l chris_menu_params
chris_menu_optionaddrs:
    dc.l chris_menu_option0,chris_menu_option1
    dc.l chris_menu_option2,chris_menu_option3
    dc.l chris_menu_option4,chris_menu_option5
chris_menu_lengths
    dc.l (chris_menu_option1-chris_menu_option0)-1
    dc.l (chris_menu_option2-chris_menu_option1)-1
    dc.l (chris_menu_option3-chris_menu_option2)-1
    dc.l (chris_menu_option4-chris_menu_option3)-1
    dc.l (chris_menu_option5-chris_menu_option4)-1
    dc.l (chris_menu_end-chris_menu_option5)-1
chris_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
chris_menu_params
    dc.l 20,21,22,23
    dc.l interviews_menu,0
chris_menu_title:
    dc.b 'CHRISTIAN SPANIK INTERVIEW',0
chris_menu_option0
    dc.b 'Part 1',0
chris_menu_option1
    dc.b 'Part 2',0
chris_menu_option2
    dc.b 'Part 3',0
chris_menu_option3
    dc.b 'Part 4',0
chris_menu_option4
    dc.b 31,'Back',0
chris_menu_option5
    dc.b 'Exit Menu',0
chris_menu_end:
    EVEN


;=============================================================================
;David Pleasance menu structure
david_menu 
    dc.l 10  ;top option #
    dc.l david_menu_optionaddrs
    dc.l david_menu_lengths
    dc.l david_menu_title
    dc.l david_menu_option0-david_menu_title ;len of title
    dc.l david_menu_actions
    dc.l david_menu_params
david_menu_optionaddrs:
    dc.l david_menu_option0,david_menu_option1
    dc.l david_menu_option2,david_menu_option3
    dc.l david_menu_option4,david_menu_option5
    dc.l david_menu_option6,david_menu_option7
    dc.l david_menu_option8,david_menu_option9
    dc.l david_menu_option10
david_menu_lengths
    dc.l (david_menu_option1-david_menu_option0)-1
    dc.l (david_menu_option2-david_menu_option1)-1
    dc.l (david_menu_option3-david_menu_option2)-1
    dc.l (david_menu_option4-david_menu_option3)-1
    dc.l (david_menu_option5-david_menu_option4)-1
    dc.l (david_menu_option6-david_menu_option5)-1
    dc.l (david_menu_option7-david_menu_option6)-1
    dc.l (david_menu_option8-david_menu_option7)-1
    dc.l (david_menu_option9-david_menu_option8)-1
    dc.l (david_menu_option10-david_menu_option9)-1
    dc.l (david_menu_end-david_menu_option10)-1
david_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_CLOSEMENU
david_menu_params
    dc.l 24,25,26,27,28,29,30,31,32
    dc.l interviews_menu,0
david_menu_title:
    dc.b 'DAVID PLEASANCE INTERVIEW',0
david_menu_option0
    dc.b 'Part 1',0
david_menu_option1
    dc.b 'Part 2',0
david_menu_option2
    dc.b 'Part 3',0
david_menu_option3
    dc.b 'Part 4',0
david_menu_option4
    dc.b 'Part 5',0
david_menu_option5
    dc.b 'Part 6',0
david_menu_option6
    dc.b 'Part 7',0
david_menu_option7
    dc.b 'Part 8',0
david_menu_option8
    dc.b 'Part 9',0
david_menu_option9
    dc.b 31,'Back',0
david_menu_option10
    dc.b 'Exit Menu',0
david_menu_end:
    EVEN

;=============================================================================
;ntsc scene menu structure
ntsc_menu 
    dc.l 3  ;top option #
    dc.l ntsc_menu_optionaddrs
    dc.l ntsc_menu_lengths
    dc.l ntsc_menu_title
    dc.l ntsc_menu_option0-ntsc_menu_title ;len of title
    dc.l ntsc_menu_actions
    dc.l ntsc_menu_params
ntsc_menu_optionaddrs:
    dc.l ntsc_menu_option0,ntsc_menu_option1
    dc.l ntsc_menu_option2,ntsc_menu_option3
    
ntsc_menu_lengths
    dc.l (ntsc_menu_option1-ntsc_menu_option0)-1
    dc.l (ntsc_menu_option2-ntsc_menu_option1)-1
    dc.l (ntsc_menu_option3-ntsc_menu_option2)-1
    dc.l (ntsc_menu_end-ntsc_menu_option3)-1
ntsc_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
ntsc_menu_params
    dc.l 34,35
    dc.l main_menu,0
ntsc_menu_title:
    dc.b 'NTSC SCENE',0
ntsc_menu_option0
    dc.b 'NTSC News 1',0
ntsc_menu_option1
    dc.b 'NTSC News 2',0
ntsc_menu_option2
    dc.b 31,'Back',0
ntsc_menu_option3
    dc.b 'Exit Menu',0
ntsc_menu_end:
    EVEN
    
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
    dc.b 'Dreaming City by Richard',0
music_menu_option1
    dc.b 'Like A Moon by Richard',0
music_menu_option2
    dc.b 'Rogue Ninja by Richard',0
music_menu_option3
    dc.b 'The Last Frontier by Richard',0
music_menu_option4
    dc.b 'Silence',0
music_menu_option5
    dc.b 'Exit Menu',0
music_menu_end:
    EVEN

