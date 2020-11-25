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
    dc.l ((main_menu_params - main_menu_actions)/4)-1 ; number of menu options in this menu
    dc.l main_menu_optionaddrs
    dc.l main_menu_lengths
    dc.l main_menu_title
    dc.l main_menu_option0 - main_menu_title ;len of title
    dc.l main_menu_actions
    dc.l main_menu_params
main_menu_optionaddrs:
    dc.l main_menu_option0,main_menu_option1,main_menu_articles,main_menu_information
    dc.l main_menu_exit_menu,main_menu_exit_magazine
main_menu_lengths
    dc.l (main_menu_option1-main_menu_option0)-1,(main_menu_articles-main_menu_option1)-1
    dc.l (main_menu_information-main_menu_articles)-1,(main_menu_exit_menu-main_menu_information)-1
    dc.l (main_menu_exit_magazine-main_menu_exit_menu)-1,(main_menu_end-main_menu_exit_magazine)-1
main_menu_actions
    dc.l MENU_ACTION_ARTICLE ;Editorial
    dc.l MENU_ACTION_ARTICLE ;Feedback
    dc.l MENU_ACTION_SPAWNMENU ;Articles
    dc.l MENU_ACTION_ARTICLE ; Information
    dc.l MENU_ACTION_CLOSEMENU ;Exit Menu
    dc.l MENU_ACTION_EXITMAGSYS ;Exit Magazine
main_menu_params
    dc.l 0 ;editorial
    dc.l 1 ;feedback
    dc.l articles_menu
    dc.l 2 ;information
    dc.l 0,0 ;exit menu, exit magazine
main_menu_title:
    dc.b 'MAIN MENU',0
main_menu_option0
    dc.b 'Editorial',0
main_menu_option1
    dc.b 'Feedback',0
main_menu_articles
    dc.b 'Articles',0
main_menu_information
    dc.b 'Information',0
main_menu_exit_menu
    dc.b 'Exit Menu',0
main_menu_exit_magazine
    dc.b 'Exit Magazine',0
main_menu_end:
    EVEN

;=============================================================================
;articles menu structure
articles_menu
    dc.l ((articles_menu_params - articles_menu_actions)/4)-1 ; number of menu options in this menu
    dc.l articles_menu_optionaddrs
    dc.l articles_menu_lengths
    dc.l articles_menu_title
    dc.l articles_menu_option0-articles_menu_title ;len of title
    dc.l articles_menu_actions
    dc.l articles_menu_params
articles_menu_optionaddrs:
    dc.l articles_menu_option0,articles_menu_option1
    dc.l articles_menu_option2,articles_menu_option3
    dc.l articles_menu_option4
    dc.l articles_menu_back,articles_menu_exit ;back, exit
articles_menu_lengths
    dc.l (articles_menu_option1 - articles_menu_option0)-1
    dc.l (articles_menu_option2 - articles_menu_option1)-1
    dc.l (articles_menu_option3 - articles_menu_option2)-1
    dc.l (articles_menu_option4 - articles_menu_option3)-1
    dc.l (articles_menu_back - articles_menu_option4)-1
    dc.l (articles_menu_exit - articles_menu_back)-1,(articles_menu_end  - articles_menu_exit)-1 ;back, exit
articles_menu_actions:
    dc.l MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU ;back, exit
articles_menu_params:
    dc.l party_menu
    dc.l games_menu
    dc.l hardware_menu
    dc.l interviews_menu
    dc.l music_scene_menu
    dc.l main_menu, 0 ;back, exit
articles_menu_title:
    dc.b 'ARTICLES',0
articles_menu_option0
    dc.b 'Party Scene',0
articles_menu_option1
    dc.b 'Games Scene',0
articles_menu_option2
    dc.b 'Hardware Scene',0
articles_menu_option3
    dc.b 'Interviews',0
articles_menu_option4
    dc.b 'Music Scene',0
articles_menu_back
    dc.b 31,'Back',0
articles_menu_exit
    dc.b 'Exit Menu',0
articles_menu_end:
    EVEN


;=============================================================================
;party menu structure
party_menu
    dc.l ((party_menu_params - party_menu_actions)/4)-1 ; number of menu options in this menu
    dc.l party_menu_optionaddrs
    dc.l party_menu_lengths
    dc.l party_menu_title
    dc.l party_menu_option0-party_menu_title ;len of title
    dc.l party_menu_actions
    dc.l party_menu_params
party_menu_optionaddrs:
    dc.l party_menu_option0
    dc.l party_menu_back
    dc.l party_menu_exit
party_menu_lengths
    dc.l (party_menu_back-party_menu_option0)-1
    dc.l (party_menu_exit-party_menu_back)-1,(party_menu_end-party_menu_exit)-1 ;back, exit
party_menu_actions
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU ;back, exit
party_menu_params
    dc.l 13
    dc.l main_menu, 0 ;back, exit
party_menu_title:
    dc.b 'PARTY SCENE',0
party_menu_option0
    dc.b 'Gamescom 2019 Report',0
party_menu_back
    dc.b 31,'Back',0
party_menu_exit
    dc.b 'Exit Menu',0
party_menu_end:
    EVEN

;=============================================================================
;games scene menu structure
games_menu 
    dc.l ((games_menu_params - games_menu_actions)/4)-1 ; number of menu options in this menu
    dc.l games_menu_optionaddrs
    dc.l games_menu_lengths
    dc.l games_menu_title
    dc.l games_menu_option0-games_menu_title ;len of title
    dc.l games_menu_actions
    dc.l games_menu_params
games_menu_optionaddrs:
    dc.l games_menu_option0
    dc.l games_menu_option1
    dc.l games_menu_option2
    dc.l games_menu_option3
    dc.l games_menu_option4
    dc.l games_menu_option5

    dc.l games_menu_back,games_menu_exit
games_menu_lengths
    dc.l (games_menu_option1-games_menu_option0)-1
    dc.l (games_menu_option2-games_menu_option1)-1
    dc.l (games_menu_option3-games_menu_option2)-1
    dc.l (games_menu_option4-games_menu_option3)-1
    dc.l (games_menu_option5-games_menu_option4)-1
    dc.l (games_menu_back-games_menu_option5)-1

    dc.l (games_menu_exit-games_menu_back)-1,(games_menu_end-games_menu_exit)-1
games_menu_actions
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE

    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
games_menu_params
    dc.l 14
    dc.l 15
    dc.l 16
    dc.l 17
    dc.l 18
    dc.l 19
    dc.l main_menu,0
games_menu_title:
    dc.b 'GAMES SCENE',0
games_menu_option0
    dc.b 'Game News 1',0
games_menu_option1
    dc.b 'Game News 2',0
games_menu_option2
    dc.b 'Game News 3',0
games_menu_option3
    dc.b 'Game News 4',0
games_menu_option4
    dc.b 'Game News 5',0
games_menu_option5
    dc.b 'TheC64 Programming Challenge',0
games_menu_back
    dc.b 31,'Back',0
games_menu_exit
    dc.b 'Exit Menu',0
games_menu_end:
    EVEN

;=============================================================================
;games news menu structure
hardware_menu 
    dc.l ((hardware_menu_params - hardware_menu_actions)/4)-1 ; number of menu options in this menu
    dc.l hardware_menu_optionaddrs
    dc.l hardware_menu_lengths
    dc.l hardware_menu_title
    dc.l hardware_menu_option0-hardware_menu_title ;len of title
    dc.l hardware_menu_actions
    dc.l hardware_menu_params
hardware_menu_optionaddrs:
    dc.l hardware_menu_option0
    dc.l hardware_menu_back, hardware_menu_exit ;back, exit
hardware_menu_lengths
    dc.l (hardware_menu_back-hardware_menu_option0)-1
    dc.l (hardware_menu_exit-hardware_menu_back)-1, (hardware_menu_end-hardware_menu_exit)-1 ;back, exit
hardware_menu_actions
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU ;back, exit
hardware_menu_params
    dc.l 20
    dc.l main_menu,0 ;back, exit
hardware_menu_title:
    dc.b 'HARDWARE SCENE',0
hardware_menu_option0
    dc.b 'TheC64 Unboxing',0
hardware_menu_back
    dc.b 31,'Back',0
hardware_menu_exit
    dc.b 'Exit Menu',0
hardware_menu_end:
    EVEN

;=============================================================================
;interviews menu structure
interviews_menu 
    dc.l ((interviews_menu_params - interviews_menu_actions)/4)-1 ; number of menu options in this menu
    dc.l interviews_menu_optionaddrs
    dc.l interviews_menu_lengths
    dc.l interviews_menu_title
    dc.l interviews_menu_option0-interviews_menu_title ;len of title
    dc.l interviews_menu_actions
    dc.l interviews_menu_params
interviews_menu_optionaddrs:
    dc.l interviews_menu_option0
    dc.l interviews_menu_option1
    dc.l interviews_menu_back,interviews_menu_exit ;back, exit
interviews_menu_lengths
    dc.l (interviews_menu_option1-interviews_menu_option0)-1
    dc.l (interviews_menu_back-interviews_menu_option1)-1
    dc.l (interviews_menu_exit-interviews_menu_back)-1,(interviews_menu_end-interviews_menu_exit)-1 ;back, exit
interviews_menu_actions
    dc.l MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU ;back, exit
interviews_menu_params
    dc.l wolfgang_menu
    dc.l biggi_menu
    dc.l main_menu,0 ;back, exit
interviews_menu_title:
    dc.b 'INTERVIEWS',0
interviews_menu_option0
    dc.b 'Wolfgang Back',0
interviews_menu_option1
    dc.b 'Biggi Lechtermann',0
interviews_menu_back
    dc.b 31,'Back',0
interviews_menu_exit
    dc.b 'Exit Menu',0
interviews_menu_end:
    EVEN

;=============================================================================
;Wolfgang Back menu structure
wolfgang_menu 
    dc.l ((wolfgang_menu_params - wolfgang_menu_actions)/4)-1 ; number of menu options in this menu
    dc.l wolfgang_menu_optionaddrs
    dc.l wolfgang_menu_lengths
    dc.l wolfgang_menu_title
    dc.l wolfgang_menu_option0-wolfgang_menu_title ;len of title
    dc.l wolfgang_menu_actions
    dc.l wolfgang_menu_params
wolfgang_menu_optionaddrs:
    dc.l wolfgang_menu_option0,wolfgang_menu_option1
    dc.l wolfgang_menu_option2,wolfgang_menu_option3
    dc.l wolfgang_menu_option4,wolfgang_menu_option5
    dc.l wolfgang_menu_back,wolfgang_menu_exit ;back, exit
wolfgang_menu_lengths
    dc.l (wolfgang_menu_option1-wolfgang_menu_option0)-1
    dc.l (wolfgang_menu_option2-wolfgang_menu_option1)-1
    dc.l (wolfgang_menu_option3-wolfgang_menu_option2)-1
    dc.l (wolfgang_menu_option4-wolfgang_menu_option3)-1
    dc.l (wolfgang_menu_option5-wolfgang_menu_option4)-1
    dc.l (wolfgang_menu_back-wolfgang_menu_option5)-1
    dc.l (wolfgang_menu_exit-wolfgang_menu_back)-1,(wolfgang_menu_end-wolfgang_menu_exit)-1 ;back, exit
wolfgang_menu_actions
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU ;back, exit
wolfgang_menu_params
    dc.l 3
    dc.l 4
    dc.l 5
    dc.l 6
    dc.l 7
    dc.l 8
    dc.l interviews_menu,0 ;back, exit
wolfgang_menu_title:
    dc.b 'JOHN CHOWNING INTERVIEW',0
wolfgang_menu_option0
    dc.b 'Part 1',0
wolfgang_menu_option1
    dc.b 'Part 2',0
wolfgang_menu_option2
    dc.b 'Part 3',0
wolfgang_menu_option3
    dc.b 'Part 4',0
wolfgang_menu_option4
    dc.b 'Part 5',0
wolfgang_menu_option5
    dc.b 'Part 6',0
wolfgang_menu_back
    dc.b 31,'Back',0
wolfgang_menu_exit
    dc.b 'Exit Menu',0
wolfgang_menu_end:
    EVEN


;=============================================================================
;Biggi Lechtermann menu structure
biggi_menu 
    dc.l ((biggi_menu_params - biggi_menu_actions)/4)-1 ; number of menu options in this menu
    dc.l biggi_menu_optionaddrs
    dc.l biggi_menu_lengths
    dc.l biggi_menu_title
    dc.l biggi_menu_option0-biggi_menu_title ;len of title
    dc.l biggi_menu_actions
    dc.l biggi_menu_params
biggi_menu_optionaddrs:
    dc.l biggi_menu_option0,biggi_menu_option1
    dc.l biggi_menu_option2,biggi_menu_option3
    dc.l biggi_menu_back,biggi_menu_exit ;back, exit
biggi_menu_lengths
    dc.l (biggi_menu_option1-biggi_menu_option0)-1
    dc.l (biggi_menu_option2-biggi_menu_option1)-1
    dc.l (biggi_menu_option3-biggi_menu_option2)-1
    dc.l (biggi_menu_back-biggi_menu_option3)-1
    dc.l (biggi_menu_exit-biggi_menu_back)-1,(biggi_menu_end-biggi_menu_exit)-1 ;back, exit
biggi_menu_actions
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_ARTICLE,MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU ; back, exit
biggi_menu_params
    dc.l 9
    dc.l 10
    dc.l 11
    dc.l 12
    dc.l interviews_menu,0 ;back, exit
biggi_menu_title:
    dc.b 'CHRISTIAN SPANIK INTERVIEW',0
biggi_menu_option0
    dc.b 'Part 1',0
biggi_menu_option1
    dc.b 'Part 2',0
biggi_menu_option2
    dc.b 'Part 3',0
biggi_menu_option3
    dc.b 'Part 4',0
biggi_menu_back
    dc.b 31,'Back',0
biggi_menu_exit
    dc.b 'Exit Menu',0
biggi_menu_end:
    EVEN



;=============================================================================
;music scene menu structure
music_scene_menu 
    dc.l ((music_scene_menu_params - music_scene_menu_actions)/4)-1 ; number of menu options in this menu
    dc.l music_scene_menu_optionaddrs
    dc.l music_scene_menu_lengths
    dc.l music_scene_menu_title
    dc.l music_scene_menu_option0-music_scene_menu_title ;len of title
    dc.l music_scene_menu_actions
    dc.l music_scene_menu_params
music_scene_menu_optionaddrs:
    dc.l music_scene_menu_option0
    dc.l music_scene_menu_back,music_scene_menu_exit
music_scene_menu_lengths
    dc.l (music_scene_menu_back-music_scene_menu_option0)-1
    dc.l (music_scene_menu_exit-music_scene_menu_back)-1,(music_scene_menu_end-music_scene_menu_exit)-1 ;back, exit
music_scene_menu_actions
    dc.l MENU_ACTION_ARTICLE
    dc.l MENU_ACTION_SPAWNMENU,MENU_ACTION_CLOSEMENU
music_scene_menu_params
    dc.l 21
    dc.l main_menu,0
music_scene_menu_title:
    dc.b 'MUSIC SCENE',0
music_scene_menu_option0
    dc.b 'Welle:Erdball Concert',0
music_scene_menu_back
    dc.b 31,'Back',0
music_scene_menu_exit
    dc.b 'Exit Menu',0
music_scene_menu_end:
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
    dc.b 'Beautiful Moment by Richard',0
music_menu_option1
    dc.b 'Carribean Trip by Richard',0
music_menu_option2
    dc.b 'Dystopian Shock by Richard',0
music_menu_option3
    dc.b 'My Honeybee by Crome',0
music_menu_option4
    dc.b 'Silence',0
music_menu_option5
    dc.b 'Exit Menu',0
music_menu_end:
    EVEN

