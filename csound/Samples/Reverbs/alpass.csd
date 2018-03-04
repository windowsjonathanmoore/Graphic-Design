alpass.csd
Written by Iain McCurdy, 2006

<CsoundSynthesizer>

<CsOptions>
-idevaudio -odevaudio -b400
</CsOptions>

<CsInstruments>

sr 		= 	44100	;SAMPLE RATE
ksmps 		= 	32	;NUMBER OF AUDIO SAMPLES IN EACH CONTROL CYCLE
nchnls 		= 	2	;NUMBER OF CHANNELS (2=STEREO)
0dbfs		=	1

;FLTK INTERFACE CODE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FLcolor	255, 255, 255, 0, 0, 0
;					LABEL   | WIDTH | HEIGHT | X | Y
				FLpanel	"alpass",  500,    250,    0,  0
 
;SWITCHES                       				ON | OFF | TYPE | WIDTH | HEIGHT | X | Y | OPCODE | INS | STARTTIM | IDUR
gkOnOff,ihOnOff			FLbutton	"On/Off",	1,    0,   22,     140,     25,    5,  5,    0,      1,      0,       -1
FLsetColor2	255, 255, 50, ihOnOff		;SET SECONDARY COLOUR TO YELLOW

;GENERAL_TEXT_SETTINGS			SIZE | FONT |  ALIGN | RED | GREEN | BLUE
			FLlabel		13,      1,      3,    255,   255,   255		;LABELS MADE INVISIBLE (I.E. SAME COLOR AS PANEL)

;BUTTON BANKS					TYPE | NUMX | NUMY | WIDTH | HEIGHT | X | Y | OPCODE | INS | STARTTIM | DUR
gkinput, ihinput		FLbutBank	14,     1,     2,     18,      40,   230, 0,   -1

;GENERAL_TEXT_SETTINGS			SIZE | FONT |  ALIGN | RED | GREEN | BLUE
			FLlabel		13,      1,      3,     0,     0,     0			;LABELS MADE VISIBLE AGAIN

;TEXT BOXES						TYPE | FONT | SIZE | WIDTH | HEIGHT | X |  Y
ih		 	FLbox  	"Input", 		1,       5,    14,     50,      20, 180,   0
ih		 	FLbox  	"Drum Loop", 		1,       5,    14,     75,      20, 250,   0
ih		 	FLbox  	"Live    ", 		1,       5,    14,     75,      20, 250,  20

;VALUE DISPLAY BOXES			LABEL  | WIDTH | HEIGHT | X | Y
idlpt				FLvalue	" ",      100,     20,    5,  75
idrvt				FLvalue	" ",      100,     20,    5, 125
idmix				FLvalue	" ",      100,     20,    5, 175
idamp				FLvalue	" ",      100,     20,    5, 225

;SLIDERS					            			MIN     | MAX | EXP | TYPE |  DISP   | WIDTH | HEIGHT | X   | Y
gklpt,ihlpt			FLslider 	"Loop Time (i-rate)",		1/sr,      0.1,  -1,   23,   idlpt,     490,    25,      5,    50
gkrvt,ihrvt			FLslider 	"Reverb Time",			0.000001,   10,  -1,   23,   idrvt,     490,    25,      5,   100
gkmix,ihmix			FLslider 	"Dry / Wet Mix",		0,      1,        0,   23,   idmix,     490,    25,      5,   150
gkamp,ihamp			FLslider 	"Output Amplitude Scaling",	0,     10,        0,   23,   idamp,     490,    25,      5,   200
gkingain,ihingain		FLslider 	"Live Input Gain",		0,      1,        0,   23,      -1,     140,    20,    350,     5

;SET INITIAL VALUES OF FLTK VALUATORS
;						VALUE | HANDLE
				FLsetVal_i	.0096, 	ihlpt
				FLsetVal_i	.06, 	ihrvt
				FLsetVal_i	0.5, 	ihmix
				FLsetVal_i	5, 	ihamp
			
				FLpanel_end
;INSTRUCTIONS AND INFO PANEL
				FLpanel	" ", 500, 360, 512, 0
;TEXT BOXES												TYPE | FONT | SIZE | WIDTH | HEIGHT | X | Y
ih		 	FLbox  	"                          alpass                             ", 	1,      5,     14,    490,    20,     5,  0
ih		 	FLbox  	"-------------------------------------------------------------", 	1,      5,     14,    490,    20,     5,  20
ih		 	FLbox  	"alpass reverberates with a flat frequency response.          ", 	1,      5,     14,    490,    20,     5,  40
ih		 	FLbox  	"'Loop Time' (in seconds) determines the density of the       ", 	1,      5,     14,    490,    20,     5,  60
ih		 	FLbox  	"reverberation and thereby the colour of the reverberation    ", 	1,      5,     14,    490,    20,     5,  80
ih		 	FLbox  	"which will contain ilpt (loop time) x sr/2 resonance peaks   ", 	1,      5,     14,    490,    20,     5, 100
ih		 	FLbox  	"between 0 and sr/2 hz. spaced ilpt (loop time) apart.        ", 	1,      5,     14,    490,    20,     5, 120
ih		 	FLbox  	"'Reverb Time' defines the time (in seconds) it will take for ", 	1,      5,     14,    490,    20,     5, 140
ih		 	FLbox  	"a sound to decay to 1/1000 (-60dB) of its initial strength.  ", 	1,      5,     14,    490,    20,     5, 160
ih		 	FLbox  	"                                                             ", 	1,      5,     14,    490,    20,     5, 180
ih		 	FLbox  	"                  +->-[FEEDFORWARD]->-+                      ", 	1,      5,     14,    490,    20,     5, 200
ih		 	FLbox  	"                  |                   |                      ", 	1,      5,     14,    490,    20,     5, 220
ih		 	FLbox  	"                  |      +-----+      |                      ", 	1,      5,     14,    490,    20,     5, 240
ih		 	FLbox  	"        INPUT-->--+------+DELAY+------+-->OUTPUT             ", 	1,      5,     14,    490,    20,     5, 260
ih		 	FLbox  	"                  |      +-----+      |                      ", 	1,      5,     14,    490,    20,     5, 280
ih		 	FLbox  	"                  |                   |                      ", 	1,      5,     14,    490,    20,     5, 300
ih		 	FLbox  	"                  +-<--[FEEDBACK]--<--+                      ", 	1,      5,     14,    490,    20,     5, 320
ih		 	FLbox  	"                                                             ", 	1,      5,     14,    490,    20,     5, 340

				FLpanel_end

				FLrun	;RUN THE FLTK WIDGET THREAD
;END OF FLTK INTERFACE CODE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr	1	;PLAYS FILE AND OUTPUTS GLOBAL VARIABLES
	if gkOnOff=0	then
		turnoff	;TURN THIS INSTRUMENT OFF IMMEDIATELY
	endif

	if	gkinput==0	then	;IF INPUT 'Seashore' IS SELECTED...
		gaSigL	diskin2	"loop.wav",    1,       0,         1	;GENERATE 2 AUDIO SIGNALS FROM A STEREO SOUND FILE (NOTE THE USE OF GLOBAL VARIABLES)		
		gaSigR	=	gaSigL
	else				;OTHERWISE
		asigL, asigR	ins	;TAKE INPUT FROM COMPUTER'S AUDIO INPUT
		gaSigL	=	asigL * gkingain	;SCALE USING 'Input Gain' SLIDER
		gaSigR	=	asigR * gkingain	;SCALE USING 'Input Gain' SLIDER
	endif						;END OF CONDITIONAL BRANCHING	
endin

instr	2	;REVERB - ALWAYS ON
	kSwitch		changed	gklpt	;GENERATE A MOMENTARY '1' PULSE IN OUTPUT 'kSwitch' IF ANY OF THE SCANNED INPUT VARIABLES CHANGE. (OUTPUT 'kSwitch' IS NORMALLY ZERO)
	if	kSwitch=1	then	;IF kSwitch=1 THEN
		reinit	UPDATE		;BEGIN A REINITIALIZATION PASS FROM LABEL 'UPDATE'
	endif				;END OF CONDITIONAL BRANCHING
	UPDATE:				;A LABEL
	iskip		=		0
	insmps		=		0
	;OUTPUT		OPCODE | INPUT | REVERB_TIME | LOOP_TIME_(DELAY_TIME)
	aresL		alpass	gaSigL, gkrvt, i(gklpt)	, iskip, insmps
	aresR		alpass	gaSigR, gkrvt, i(gklpt)	, iskip, insmps
	aresL		tone	aresL,800
	aresR		tone	aresR,800
	arvbL,arvbR	reverbsc	aresL,aresR,0.1,8000
	aresL	ntrpol	aresL,arvbL,gkmix
	aresR	ntrpol	aresR,arvbR,gkmix
	rireturn			;RETURN TO PERFORMANCE TIME PASSES
			outs	aresL * gkamp, aresR * gkamp	;SEND comb OUTPUT TO THE AUDIO OUTPUTS AND SCALE USING THE FLTK SLIDER VARIABLE gkamp
	clear	gaSigL, gaSigR	;CLEAR GLOBAL AUDIO VARIABLES
endin
  	
</CsInstruments>

<CsScore>
;INSTR | START | DURATION
i  2       0       3600	;INSTRUMENT 1 PLAYS FOR 1 HOUR
</CsScore>

</CsoundSynthesizer>