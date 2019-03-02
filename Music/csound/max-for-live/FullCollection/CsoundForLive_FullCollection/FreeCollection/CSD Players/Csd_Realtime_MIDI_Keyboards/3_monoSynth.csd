<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>

nchnls	=	2


;*** MidiMonoSyn, Version A: 1 osc, 1 filter, pitch and vel portamento

#define ON 		#1#
#define OFF 		#0#
#define NOTEON		#144#	;*** midi status num for note on
#define NOTEOFF	#128# 	;*** midi status num for note off


						;*** values for synthstate to keep track of what's happening
#define NEWDETACHED #1#		
#define DETACHED	#2#
#define NEWLEGATO   #3#
#define LEGATO		#4#	
#define NEWRELEASE  #5#
#define RELEASING	#6#


	instr 128

;*** dummy instr to catch the annoyning default midi routing
;*** if this is not here, instr 130 gets turned on and off by the keyboard
;*** Once Istvan's new massign 0,0 fix is in CsoundAV we can get rid of this, yay!

	endin


	instr 130

;**********************************************************************************************
;**********************************************************************************************
;*** Control variable initialization. Change these as desired

;*** The stuff here can be turned into real time controls in later versions

iampatt		init		0.01
iampdec		init		0.3
iampsus		init		0.6
iamprel		init		0.5
iampmute		init		0.005		;*** time to damp previous note

idetfrqprt	init		0.001		;*** pitch portamento for non legato
ilegfrqprt	init		0.1			;*** pitch portamento time for legato

kvolume		init		20000		;*** amp value for full velocity. ( 1 )

ichan		init		1			;*** which midi channel to pay attention to		


;**********************************************************************************************
;*** Variable initialization. This only happens once. Don't change these.


kactive		init		0			;*** number of active midi notes
ksynstate		init		$NEWRELEASE 	;*** starts as playing with envelopes closed

kampenv		init		0			;*** amp env starts at 0
kamprelenv	init		0.001		;*** release env starts at 0 so we hear silence 
kamp			init		0.001		;*** final kamp ( either main env or rel env )
kfrq			init		440			;*** need some dummy starting pitch 

ifrqprt		init		0.001		;*** meaningless initialization
		
;*** Note, ksynstate tells us what is happening. 
;*** It only lasts for one kpass for new notes.

;**********************************************************************************************
;**********************************************************************************************
;*** Midi Parser section.

;*** This section receives midi input and decides what state the synth is in.
;*** You can change this section to change how midi input is interpreted.
;*** In this version any held note will keep the synth in legato and playing
;*** the most recently played note.


;*** Get any waiting midi message
kstat, kchan, kdata1, kdata2	midiin

;*** ignore messages on other channels
if ( kchan != ichan ) kgoto DoneMidiIn

;*** if we get a note on and vel is not 0, goto note on section
if ( ( kstat == $NOTEON ) && ( kdata2 != 0 ) ) kgoto NoteOn

;*** if we get a note off or note on vel 0, goto note off section
if ( ( kstat == $NOTEOFF ) || ( ( kstat == $NOTEON ) && ( kdata2 == 0 ) ) ) kgoto NoteOff 

;*** any other incoming midi messages are ignored for now
kgoto DoneMidiIn


;*** Note on section
NoteOn:

	;*** increment kactive ( active note counter )
	kactive = kactive + 1

	;*** if this is the only active note, we have a new detached note
	ksynstate = ( kactive == 1 ? $NEWDETACHED : ksynstate )
	
	;*** if there are other active notes, we have a new legato note
	ksynstate = ( kactive > 1 ? $NEWLEGATO : ksynstate )
	
	kgoto DoneMidiIn
		
		
;*** Note off section
NoteOff:

	;*** if there is more than one note playing, ignore this note off
	;*** or if no notes are playing, ignore the note off ( in case of panic button )
	if ( ( kactive > 1 ) || ( kactive == 0 ) ) kgoto IgnoreNoteOff

	;*** otherwise, decrement kactive 
	kactive = kactive - 1
	
	;*** and set ksynstate to $NEWRELEASE
	ksynstate = $NEWRELEASE
	
	kgoto DoneMidiIn
	
	
IgnoreNoteOff:

	;*** we update the active note counter, but don't do anything else
	;*** the note counter is held at minimum 0
	kactive = ( kactive <= 0 ? 0 : kactive - 1 )


DoneMidiIn:


;**********************************************************************************************
;**********************************************************************************************
;*** New Note section:

;*** For a new detached note we need to restart the envelopes and the portamento ramps.
;*** For a new legato note we restart the portamento ramps, but not the envelopes.

;*** The reinit code only affects anything on a reinit pass, else it is ignored.
;***	However the reinit section must also enclose the envelope code so it restarts.
;*** When we are not actually reiniting, we pass through the envelope code as well.


;**********************************************************************************************
;*** Amp env section

;*** if we are in a release stage, skip to release env section
if ( ksynstate == $NEWRELEASE || ksynstate == $RELEASING ) kgoto ReleaseSection


;*** If this is the first kpass of a new detached note, kgoto to the NewAmpEnv reinit
;*** On all other passes we must continue to the AmpEnv section

if ( ksynstate == $NEWDETACHED ) kgoto NewAmpEnv
	kgoto AmpEnv

;*** The reinit section. We only get here on a new detached note.
NewAmpEnv:

	;*** on a new detached note we must reinit the envelopes
	reinit NewAmpEnv

	;*** freezing of any controls for detached notes goes here, ie env values

	;*** freeze last amp value, new env starts from there.
	iampstrt		init		i( kamp )
	

;*** The actual amp env section, we get here on both reinit and continuing passes
;*** However, the reinit pass *restarts* the envelope. 
AmpEnv:

	;*** Amp envelope section, we must hit this on all passes

	;*** Envelope starts from the last value used, 0.001 if a note finished the release
	;*** Envelope just ends parked on the sus level.	
	;*** Uncomment whichever version of the env you want to use
	
	;*** "String damping" version of the env
	;*** quickly goes to 0.001 before the attack
	kampenv	linseg	iampstrt, iampmute, 0.001, iampatt, 1, iampdec, iampsus, 1, iampsus	 

	;*** "Continuous sound" version of the env
	;*** env starts from last value. long release time will change slope of attack
	;kampenv	linseg	iampstrt, iampatt, 1, iampdec, iampsus, 1, iampsus
	
	;*** End the reint pass for the NewAmpEnv
	;*** ( This has no effect during non reinit passes )
	rireturn


;*** skip the release section
kgoto DoneAmpControl


;**********************************************************************************************
;*** The Release Envelope section.

;*** The release env starts from the last amp value used, and closes to 0.0001
;*** Between notes ( after release time ) it is held at 0.0001 so we hear silence.

;*** On the first kpass of a release we do the reinit section and the release env code.
;*** On subsequent kpasses we hop ahead to the release env code.

ReleaseSection:

if ( ksynstate == $NEWRELEASE ) kgoto NewRelease	
	kgoto Releasing

NewRelease:

	;*** reinit the release env, only happens on $NEWRELEASE passes
	reinit NewRelease

	;*** freeze the ampenv starting points here
	iampstrt	init	i( kamp )	
	
		
Releasing:

	;*** release env starts from last amp value used and parks on 0.0001
	kamprelenv	expseg	iampstrt, iamprel, 0.0001, 1, 0.0001

	;*** end the reinit pass, this has no effect on $RELEASING passes
	rireturn


;*** ( label we hop to when skipping the release code )
DoneAmpControl:


;**********************************************************************************************
;**********************************************************************************************
;*** Pitch and Velocity portamento section

;*** We have finished the env code. Now we do the pitch ramp code
;*** Note: we should be here on all passes, even release passes, as we might
;*** play a very short note with a long port time, and have the pitch still
;*** be gliding during the release stage.


;*** On either new detached or new legato notes, we must reinit the frq ramps
;*** We merely choose which port time to use based on detached or legato
if ( ksynstate == $NEWDETACHED || ksynstate == $NEWLEGATO ) kgoto NewFrq
	
	;*** on all other passes continue the pitch ramps
	kgoto FrqRamp
	
NewFrq:

	;*** start the reinit pass from NewFrq
	reinit NewFrq

	;*** freeze the starting pitch for the portamento
	;*** the start pitch is the last used pitch from the previous note
	;*** this is working
	ifrqstrt 	init		i( kfrq )

	;*** choose which portamento speed to use
	isynstate	init		i( ksynstate )
	ifrqprt	= 		( isynstate == $NEWDETACHED ? idetfrqprt : ilegfrqprt ) 

	;*** freeze the destination pitch from the midi note number
	inotenum	init		i( kdata1 )
	
	;*** convert the midi note num to cps, ( thanks Istvan! )
	ifrqdest	init		cpsoct( inotenum * 0.08333333 + 3 )		


;*** we get here on all passes, including the reinit ones	
FrqRamp:	
	
	;*** the pitch ramp straightens out on the destination pitch
	kfrq		expseg	ifrqstrt, ifrqprt, ifrqdest, 1, ifrqdest

	;*** end the NewFrq reinit pass
	rireturn


;**********************************************************************************************
;**********************************************************************************************
;*** Sound Section

;*** The envelopes and pitch ramps have been generated, now we make some noise.

;*** Three detuned oscillators so we can hear beating
asig1	oscil	0.33, kfrq, 1
asig2	oscil	0.33, kfrq * 0.995, 2
asig3	oscil	0.33, kfrq * 1.005, 3

;*** Combine the oscillators
asigcomp	=		asig1 + asig2 + asig3

;*** choose which envelope we should use based on ksynstate
kamp 	= 	( ksynstate == $NEWRELEASE || ksynstate == $RELEASING ? kamprelenv : kampenv )

;*** amplify using linear interpolation of the envelope for smoothness
asigout	=		asigcomp * a(kamp) * kvolume

;*** output the signal
		outs		asigout, asigout
		

;*** debugging stuff, uncomment this to watch the parser in action		
;printks "Active notes:	 %5.0f 	", 0.2, kactive 
;printks "Synstate:	 %5.0f \\n", 0.2, ksynstate


;**********************************************************************************************
;**********************************************************************************************
;*** Update the synstate.

;*** $NEWRELEASE will change to $RELEASING
;*** $NEWDETACHED and $NEWLEGATO will change to $PLAYING

ksynstate = ( ksynstate == $NEWDETACHED ? $DETACHED : ksynstate )
ksynstate = ( ksynstate == $NEWLEGATO ? $LEGATO : ksynstate )
ksynstate = ( ksynstate == $NEWRELEASE ? $RELEASING : ksynstate )


;*** That's it! 


		endin



</CsInstruments>
<CsScore>

;*** a simple additive synthesis waveform for this example
f1 	0 4096 10 	1.0	0.2	0.85	0.15	0.7 0.1  0.55 0.05 0.4 0.0  0.25 0.0 0.1
f2	0 4096 10		1.0	0.3	0.7  0.25 0.6 0.2  0.5  0.1  0.4 0.05 0.3  0.0 0.2 
f3  	0 4096 10		1.0  0.1  0.9  0.08 0.7 0.06 0.5  0.04 0.3 0.02 0.1  0.01 0.05

;*** turn on the instrument, for some reason ihold won't work with reinits
i130 0 1000		

e
 

</CsScore>

</CsoundSynthesizer>
