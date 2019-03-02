;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Wave Terrain Lead
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
ksmps		=	128
nchnls	=	2
0dbfs		=	1

massign 1, 3

giKybdScaling	ftgen	0,0,128,5,1,32,1,96,0.4
giExp1		ftgen	0, 0, 129, -25, 0, 1.0, 128, 8000.0

instr	1
ktrig	metro	10
if (ktrig == 1)	then

gkcx		chnget	"XCentre"
gkcy		chnget	"YCentre"
gkrx		chnget	"XRadius"
gkry		chnget	"YRadius"
gkamp	=2
gkatt		chnget	"Attack"
gkrel		chnget	"Release"
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
gkfqstart 	chnget "fqstart"
gkfqtime 	chnget "fqtime"
gkfqend 	chnget "fqend"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkdetune chnget "detune"	
gkspread chnget "spread"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gkporttime chnget "glide"
	endif
kon init 1
if kon == 1 then
kon = 9
event "i", 2, 0, 60000	
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
			rireturn	
endin

instr	3
;;Tuning Block:
    
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
gkfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
gkfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
giamp ampmidi 1

gkRadEnv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)	
schedkwhen      1,           0,       1,       4,      0,   3600
endin

instr 4
kporttime1 linseg	0, (.01), 1, (1), 1
kporttime1	= kporttime1 * gkporttime
kfrq1	portk	gkfrq1, kporttime1
kfrq2	portk	gkfrq2, kporttime1
	
	
	
;;Monophonic Part:
kreltrig	release
gkinstrcount 	active 3
if		gkinstrcount!=0||kreltrig=1	kgoto	GO
turnoff
GO:
ioutfix = 1.2
iporttime			=		0.05
kporttime			linseg	0, 0.01, iporttime
iMIDIActiveValue	=		1
iMIDIflag	= 0

klfo lfo gklfoamp, gklforate, i(gklfotype)
kfilt expseg i(gkfqstart), i(gkfqtime), i(gkfqend), 6000, i(gkfqend)

kcx		portk	gkcx, kporttime
kcy		portk	gkcy, kporttime
krx		portk	gkrx, kporttime	
kry		portk	gkry, kporttime

krxJit	jspline	gkJitX,1,10
kryJit	jspline	gkJitY,1,10	
	
asigL	wterrain	giamp,  kfrq1+klfo, kcx, kcy, krx*gkRadEnv*(1+krxJit), kry*gkRadEnv*(1+kryJit), giwave1, giwave2
asigR	wterrain	giamp,  kfrq2+klfo, kcx, kcy, krx*gkRadEnv*(1+krxJit), kry*gkRadEnv*(1+kryJit), giwave1, giwave2
asigL	dcblock	asigL	
asigR	dcblock	asigR	

aenv		expseg	0.001, 0.01, 1,1,1
asig1	=		asigL * aenv
asig2	=		asigR * aenv

aoutA moogladder asig1, kfilt, gkq
aoutB moogladder asig2, kfilt, gkq

aout1 balance aoutA, asig1
aout2 balance aoutB, asig2

;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

outs		aoutL*ioutfix, aoutR*ioutfix
endin


</CsInstruments>
<CsScore>
i1 0 99999
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
