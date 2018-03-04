;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	WaveTerrain
;;	by Iain McCurdy
;;	
;;	Expanded for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
-old parser
</CsOptions>
<CsInstruments>
sr		=	44100
kr		=	441
ksmps		=	100
nchnls	=	2
0dbfs		=	1

turnon 22

giKybdScaling	ftgen	0,0,128,5,1,32,1,96,0.4
giExp1		ftgen	0, 0, 129, -25, 0, 1.0, 128, 8000.0

instr	10	;GUI
ktrig	metro	10
if (ktrig == 1)	then

gkcx		chnget	"XCentre"
gkcy		chnget	"YCentre"
gkrx		chnget	"XRadius"
gkry		chnget	"YRadius"
gkamp	=2 
gkAtt		chnget	"Attack"
gkRel		chnget	"Release"
gksus		chnget	"sus"
gkdec		chnget	"dec"
gkRvbSnd	chnget	"Reverb"
gkJitX	chnget	"XJitter"
gkJitY	chnget	"YJitter"
;X Wave
gk1_1		chnget	"x1"
gk1_2		chnget	"x2"
gk1_3		chnget	"x3"
gk1_4		chnget	"x4"
gk1_5		chnget	"x5"
gk1_6		chnget	"x6"
gk1_7		chnget	"x7"
gk1_8		chnget	"x8"
gk1_9		chnget	"x9"
gk1_10	chnget	"x10"
gk1_11	chnget	"x11"
gk1_12	chnget	"x12"
;Y Wave
gk2_1		chnget	"y1"
gk2_2		chnget	"y2"
gk2_3		chnget	"y3"
gk2_4		chnget	"y4"
gk2_5		chnget	"y5"
gk2_6		chnget	"y6"
gk2_7		chnget	"y7"
gk2_8		chnget	"y8"
gk2_9		chnget	"y9"
gk2_10	chnget	"y10"
gk2_11	chnget	"y11"
gk2_12	chnget	"y12"
gklfotype 	chnget "lfotype"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkdetune chnget "detune"	
gkspread chnget "spread"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gkvoices chnget "voices"
gkdelfo chnget "lfodelay"

gkfco chnget "fco"
gkfiltatt chnget "filtatt"
gkfiltdec chnget "filtdec"
gkfiltsus chnget "filtsus"
gkfiltrel chnget "filtrel"
gkfqstart chnget "fqstart"
gkfiltadsrbypass chnget "filtadsrbypass"
	endif
endin


instr	2
	ktrig	changed	gk1_1, gk1_2, gk1_3, gk1_4, gk1_5, gk1_6, gk1_7, gk1_8, gk1_9, gk1_10, gk1_11, gk1_12, gk2_1, gk2_2, gk2_3, gk2_4, gk2_5, gk2_6, gk2_7, gk2_8, gk2_9, gk2_10, gk2_11, gk2_12
	if ktrig=1 then
		reinit	UPDATE
	endif	
	UPDATE:

	giwave1	ftgen	1,0,8192,10,i(gk1_1),i(gk1_2),i(gk1_3),i(gk1_4),i(gk1_5),i(gk1_6),i(gk1_7),i(gk1_8),i(gk1_9),i(gk1_10),i(gk1_11),i(gk1_12)
	giwave2	ftgen	2,0,8192,10,i(gk2_1),i(gk2_2),i(gk2_3),i(gk2_4),i(gk2_5),i(gk2_6),i(gk2_7),i(gk2_8),i(gk2_9),i(gk2_10),i(gk2_11),i(gk2_12)
			rireturn											;RETURN FROM REINITIALIZATION PASS
endin

instr 	1
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay

	ioutfix = .15
	iporttime			=		0.05
	kporttime			linseg	0, 0.01, iporttime
	iMIDIActiveValue	=		1
	iMIDIflag			=		0
	
;;Tuning Block:;;;;;;;;;;;;;;;;;;;;;;;;;;
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
iamp ampmidi 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

kRadEnv	madsr i(gkAtt), i(gkdec), i(gksus), i(gkRel)

klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)


kcx		portk	gkcx, kporttime
kcy		portk	gkcy, kporttime
krx		portk	gkrx, kporttime	
kry		portk	gkry, kporttime

krxJit	jspline	gkJitX,1,10
kryJit	jspline	gkJitY,1,10	
	
asigL	wterrain	gkamp,  kfrq1+klfo, kcx, kcy, krx*kRadEnv*(1+krxJit), kry*kRadEnv*(1+kryJit), giwave1, giwave2
asigR	wterrain	gkamp,  kfrq2+klfo, kcx, kcy, krx*kRadEnv*(1+krxJit), kry*kRadEnv*(1+kryJit), giwave1, giwave2
asigL	dcblock	asigL	
asigR	dcblock	asigR	

aenv		expseg	0.001, 0.01, 1,1,1
aout1	=		asigL * aenv
aout2	=		asigR * aenv

if gkfiltadsrbypass == 0 then
aoutA moogladder aout1, gkfco, gkq*.99
aoutB moogladder aout2, gkfco, gkq*.99
aout1 balance aoutA, aout1
aout2 balance aoutB, aout2
else
kfilt madsr i(gkfiltatt), i(gkfiltdec), i(gkfiltsus), i(gkfiltrel)
aout1 moogladder aout1, kfilt*gkfco, gkq*.99
aout2 moogladder aout2, kfilt*gkfco, gkq*.99
aout1 clip aout1, 0, .99
aout2 clip aout2, 0, .99
endif

;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

outs		aoutL*ioutfix, aoutR*ioutfix
endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr 22
kinstr init 1
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin

</CsInstruments>
<CsScore>
i 10		0.0	   99999
i 2 0 99999
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>72</x>
 <y>179</y>
 <width>400</width>
 <height>200</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>slider1</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{a3062e93-3543-46b4-8181-c9345288462d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
