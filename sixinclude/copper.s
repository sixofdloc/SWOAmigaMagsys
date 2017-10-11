;=============================================================================
; Copperlist Constants
;=============================================================================
_bltddat     equ $0000   ; Blitter Destination Data (DMA only)
_dmaconr     equ $0002   ; DMA Enable Read
_vposr       equ $0004   ; Vertical Beam Position Read
_vhposr      equ $0006   ; Vert/Horiz Beam Position Read
_dskdatr     equ $0008   ; Disk Data Read (DMA only)
_joy0dat     equ $000a   ; Joystick/Mouse Port 0 Data (read)
_joy1dat     equ $000c   ; Joystick/Mouse Port 1 Data (read)
_clxdat      equ $000e   ; Collision Data (read)
_adkconr     equ $0010   ; Audio/Disk Control Read
_pot0dat     equ $0012   ; Pot Port 0 Data Read
_pot1dat     equ $0012   ; Pot Port 1 Data Read
_potgor      equ $0016   ; Pot Port Data Read
_serdatr     equ $0018   ; Serial Data Input and Status Read
_dskbytr     equ $001a   ; Disk Data Byte and Disk Status Read
_intenar     equ $001c   ; Interrupt Enable (read)
_intreqr     equ $001e   ; Interrupt Request (read)
_dskpt       equ $0020   ; Disk Pointer (write)
_dskpth      equ $0020
_dskptl      equ $0022
_dsklen      equ $0024   ; Disk Data Length
_dskdat      equ $0026   ; Disk DMA Write
_refptr      equ $0028   ; Refresh Pointer (write) DON'T USE!
_vposw       equ $002a   ; Vert Beam Position Write DON'T USE!
_vhposw      equ $002c   ; Vert/Horiz Beam Pos Write DON'T USE!
_copcon      equ $002e   ; Coprocessor Control
_serdat      equ $0030   ; Serial Data Output (write)
_serper      equ $0032   ; Serial Period & Data Bit Control (write)
_potgo       equ $0034   ; Pot Port Data (write)
_joytest     equ $0036   ; JOY0DAT and JOY1DAT Write
_strequ      equ $0038   ; Short Frame Vertical Strobe
_strvbl      equ $003a   ; Normal Vertical Blank Stobe
_strhor      equ $003c   ; Horizontal Sync Strobe
_strlong     equ $003e   ; Long Raster Strobe
_bltcon0     equ $0040   ; Blitter Control Register 0 (write)
_bltcon1     equ $0042   ; Blitter Control Register 1 (write)
_bltafwm     equ $0044   ; Source A First Word Mask (write)
_bltalwm     equ $0046   ; Source A Last Word Mask (write)
_bltcpt      equ $0048   ; Blitter Source C Pointer (write)
_bltcpth     equ $0048
_bltcptl     equ $004a
_bltbpt      equ $004c   ; Blitter Source B Pointer (write)
_bltbpth     equ $004c
_bltbptl     equ $004e
_bltapt      equ $0050   ; Blitter Source A Pointer (write)
_bltapth     equ $0050
_bltaptl     equ $0052
_bltdpt      equ $0054   ; Blitter Destination Pointer (write)
_bltdpth     equ $0054
_bltdptl     equ $0056
_bltsize     equ $0058   ; Blitter Start and Size (write)

_bltcmod     equ $0060   ; Blitter Source C Modulo (write)
_bltbmod     equ $0062   ; Blitter Source B Modulo (write)
_bltamod     equ $0064   ; Blitter Source A Modulo (write)
_bltdmod     equ $0066   ; Blitter Destination Modulo (write)

_bltcdat     equ $0070   ; Blitter Source C Data (write)
_bltbdat     equ $0072   ; Blitter Source B Data (write)
_bltadat     equ $0074   ; Blitter Source A Data (write)

_dsksync     equ $007e   ; Disk Sync Pattern (write)
_cop1lc      equ $0080   ; Copper Program Counter 1 (write)
_cop1lch     equ $0080
_cop1lcl     equ $0082
_cop2lc      equ $0084   ; Copper Program Counter 2 (write)
_cop2lch     equ $0084
_cop2lcl     equ $0086
_copjmp1     equ $0088   ; Copper Jump Strobe 1
_copjmp2     equ $0088   ; Copper Jump Strobe 2
_copins      equ $008c   ; Copper Instruction Identity (write)
_diwstrt     equ $008e   ; Display Window Start (write)
_diwstop     equ $0090   ; Display Window Stop (write)
_ddfstrt     equ $0092   ; Display Data Fetch Start (write)
_ddfstop     equ $0094   ; Display Data Fetch Stop (write)
_dmacon      equ $0096   ; DMA Control (write)
_clxcon      equ $0098   ; Collision Control (write)
_intena      equ $009a   ; Interrupt Enable (write)
_intreq      equ $009c   ; Interrupt Request (write)
_adkcon      equ $009e   ; Audio/Disk Control (write)
_aud0lc      equ $00a0   ; Channel 0 Waveform Address (write)
_aud0lch     equ $00a0
_aud0lcl     equ $00a2
_aud0len     equ $00a4   ; Channel 0 Waveform Length (write)
_aud0per     equ $00a6   ; Channel 0 Period (write)
_aud0vol     equ $00a8   ; Channel 0 Volume (write)
_aud0dat     equ $00aa   ; Channel 0 Data (write)

_aud1lc      equ $00b0   ; Channel 1 Waveform Address (write)
_aud1lch     equ $00b0
_aud1lcl     equ $00b2
_aud1len     equ $00b4   ; Channel 1 Waveform Length (write)
_aud1per     equ $00b6   ; Channel 1 Period (write)
_aud1vol     equ $00b8   ; Channel 1 Volume (write)
_aud1dat     equ $00ba   ; Channel 1 Data (write)

_aud2lc      equ $00c0   ; Channel 2 Waveform Address (write)
_aud2lch     equ $00c0
_aud2lcl     equ $00c2
_aud2len     equ $00c4   ; Channel 2 Waveform Length (write)
_aud2per     equ $00c6   ; Channel 2 Period (write)
_aud2vol     equ $00c8   ; Channel 2 Volume (write)
_aud2dat     equ $00ca   ; Channel 2 Data (write)

_aud3lc      equ $00d0   ; Channel 3 Waveform Address (write)
_aud3lch     equ $00d0
_aud3lcl     equ $00d2
_aud3len     equ $00d4   ; Channel 3 Waveform Length (write)
_aud3per     equ $00d6   ; Channel 3 Period (write)
_aud3vol     equ $00d8   ; Channel 3 Volume (write)
_aud3dat     equ $00da   ; Channel 3 Data (write)

_bpl1pt      equ $00e0   ; Bitplane 1 Pointer (write)
_bpl1pth     equ $00e0
_bpl1ptl     equ $00e2
_bpl2pt      equ $00e4   ; Bitplane 2 Pointer (write)
_bpl2pth     equ $00e4
_bpl2ptl     equ $00e6
_bpl3pt      equ $00e8   ; Bitplane 3 Pointer (write)
_bpl3pth     equ $00e8
_bpl3ptl     equ $00ea
_bpl4pt      equ $00ec   ; Bitplane 4 Pointer (write)
_bpl4pth     equ $00ec
_bpl4ptl     equ $00ee
_bpl5pt      equ $00f0   ; Bitplane 5 Pointer (write)
_bpl5pth     equ $00f0
_bpl5ptl     equ $00f2
_bpl6pt      equ $00f4   ; Bitplane 6 Pointer (write)
_bpl6pth     equ $00f4
_bpl6ptl     equ $00f6

_bplcon0     equ $0100   ; Bitplane Control Register 0 (write)
_bplcon1     equ $0102   ; Bitplane Control Register 1 (write)
_bplcon2     equ $0104   ; Bitplane Control Register 2 (write)

_bpl1mod     equ $0108   ; Bitplane Modulo 1 (write)
_bpl2mod     equ $010a   ; Bitplane Modulo 2 (write)

_bpl1dat     equ $0110   ; Bitplane Data Register 1 (write)
_bpl2dat     equ $0112   ; Bitplane Data Register 2 (write)
_bpl3dat     equ $0114   ; Bitplane Data Register 3 (write)
_bpl4dat     equ $0116   ; Bitplane Data Register 4 (write)
_bpl5dat     equ $0118   ; Bitplane Data Register 5 (write)
_bpl6dat     equ $011a   ; Bitplane Data Register 6 (write)

_spr0pt      equ $0120   ; Sprite Pointer 0 (write)
_spr0pth     equ $0120
_spr0ptl     equ $0122
_spr1pt      equ $0124   ; Sprite Pointer 1 (write)
_spr1pth     equ $0124
_spr1ptl     equ $0126
_spr2pt      equ $0128   ; Sprite Pointer 2 (write)
_spr2pth     equ $0128
_spr2ptl     equ $012a
_spr3pt      equ $012c   ; Sprite Pointer 3 (write)
_spr3pth     equ $012c
_spr3ptl     equ $012e
_spr4pt      equ $0130   ; Sprite Pointer 4 (write)
_spr4pth     equ $0130
_spr4ptl     equ $0132
_spr5pt      equ $0134   ; Sprite Pointer 5 (write)
_spr5pth     equ $0134
_spr5ptl     equ $0136
_spr6pt      equ $0138   ; Sprite Pointer 6 (write)
_spr6pth     equ $0138
_spr6ptl     equ $013a
_spr7pt      equ $013c   ; Sprite Pointer 7 (write)
_spr7pth     equ $013c
_spr7ptl     equ $013e

_spr0pos     equ $0140   ; Sprite Position 0 (write)
_spr0ctl     equ $0142   ; Sprite Control 0 (write)
_spr0data    equ $0144   ; Sprite Data A Register 0 (write)
_spr0datb    equ $0146   ; Sprite Data B Register 0 (write)
_spr1pos     equ $0148   ; Sprite Position 1 (write)
_spr1ctl     equ $014a   ; Sprite Control 1 (write)
_spr1data    equ $014c   ; Sprite Data A Register 1 (write)
_spr1datb    equ $014e   ; Sprite Data B Register 1 (write)
_spr2pos     equ $0150   ; Sprite Position 2 (write)
_spr2ctl     equ $0152   ; Sprite Control 2 (write)
_spr2data    equ $0154   ; Sprite Data A Register 2 (write)
_spr2datb    equ $0156   ; Sprite Data B Register 2 (write)
_spr3pos     equ $0158   ; Sprite Position 3 (write)
_spr3ctl     equ $015a   ; Sprite Control 3 (write)
_spr3data    equ $015c   ; Sprite Data A Register 3 (write)
_spr3datb    equ $015e   ; Sprite Data B Register 3 (write)
_spr4pos     equ $0160   ; Sprite Position 4 (write)
_spr4ctl     equ $0162   ; Sprite Control 4 (write)
_spr4data    equ $0164   ; Sprite Data A Register 4 (write)
_spr4datb    equ $0166   ; Sprite Data B Register 4 (write)
_spr5pos     equ $0168   ; Sprite Position 5 (write)
_spr5ctl     equ $016a   ; Sprite Control 5 (write)
_spr5data    equ $016c   ; Sprite Data A Register 5 (write)
_spr5datb    equ $016e   ; Sprite Data B Register 5 (write)
_spr6pos     equ $0170   ; Sprite Position 6 (write)
_spr6ctl     equ $0172   ; Sprite Control 6 (write)
_spr6data    equ $0174   ; Sprite Data A Register 6 (write)
_spr6datb    equ $0176   ; Sprite Data B Register 6 (write)
_spr7pos     equ $0178   ; Sprite Position 7 (write)
_spr7ctl     equ $017a   ; Sprite Control 7 (write)
_spr7data    equ $017c   ; Sprite Data A Register 7 (write)
_spr7datb    equ $017e   ; Sprite Data B Register 7 (write)

_color00     equ $0180   ; Color Register 0 (write)
_color01     equ $0182   ; Color Register 1 (write)
_color02     equ $0184   ; Color Register 2 (write)
_color03     equ $0186   ; Color Register 3 (write)
_color04     equ $0188   ; Color Register 4 (write)
_color05     equ $018a   ; Color Register 5 (write)
_color06     equ $018c   ; Color Register 6 (write)
_color07     equ $018e   ; Color Register 7 (write)
_color08     equ $0190   ; Color Register 8 (write)
_color09     equ $0192   ; Color Register 9 (write)
_color10     equ $0194   ; Color Register 10 (write)
_color11     equ $0196   ; Color Register 11 (write)
_color12     equ $0198   ; Color Register 12 (write)
_color13     equ $019a   ; Color Register 13 (write)
_color14     equ $019c   ; Color Register 14 (write)
_color15     equ $019e   ; Color Register 15 (write)
_color16     equ $01a0   ; Color Register 16 (write)
_color17     equ $01a2   ; Color Register 17 (write)
_color18     equ $01a4   ; Color Register 18 (write)
_color19     equ $01a6   ; Color Register 19 (write)
_color20     equ $01a8   ; Color Register 20 (write)
_color21     equ $01aa   ; Color Register 21 (write)
_color22     equ $01ac   ; Color Register 22 (write)
_color23     equ $01ae   ; Color Register 23 (write)
_color24     equ $01b0   ; Color Register 24 (write)
_color25     equ $01b2   ; Color Register 25 (write)
_color26     equ $01b4   ; Color Register 26 (write)
_color27     equ $01b6   ; Color Register 27 (write)
_color28     equ $01b8   ; Color Register 28 (write)
_color29     equ $01ba   ; Color Register 29 (write)
_color30     equ $01bc   ; Color Register 30 (write)
_color31     equ $01be   ; Color Register 31 (write)
_beamcon0    equ $01dc   ; Video Beam Control 0 (write)

_brstmod     equ $01fc ;aga compat burst mode
_bplcon4    equ $010c

_copwait equ $fffe
