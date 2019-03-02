;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	RingMod
;;	by Iain McCurdy
;;
;;	Adapted for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
-old parser
</CsOptions>
<CsInstruments>
sr		=	44100
ksmps		=	16
nchnls	=	2
0dbfs		=	1

giWet		ftgen	0,0,1024,-7,0,512,1,512,1
giDry		ftgen	0,0,1024,-7,1,512,1,512,0
giWave1		ftgen		1,0, 16384,10, 1		
giWave2		ftgen 	2,0, 16384, 7, 1, 16384, -1 
giWave3 		ftgen		3,0, 16384, 9, 1, 3, 0, 3, 1, 0, 9, 0,.3333, 180 
giWave4		ftgen		4, 0, 4096, 20, 3, 1		
giWave5		ftgen		5, 0, 4096, 20, 6, 1		

instr 1
ktrig	metro	100
if (ktrig == 1)	then
gk1 chnget "mix"		
gk2L chnget "freq1"
gk2R chnget "freq2"		
gk3 chnget "env"		
kwaveL chnget "modwaveL"
gkwaveL = kwaveL + 1
kwaveR chnget "modwaveR"
gkwaveR = kwaveR + 1
endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0.01, 60000
endif
endin

instr	2
ainL, ainR ins

k1 tonek gk1, 10
k2L tonek gk2L, 10
k2R tonek gk2R, 10
k3 tonek gk3, 10

kswitch changed gkwaveL, gkwaveR
if kswitch == 1 then
reinit START
endif

START:

kWet		table	k1, giWet, 1
kDry		table	k1, giDry, 1
kporttime	linseg	0,0.001,0.02
kModFrqL	portk	k2L, kporttime
kModFrqR	portk k2R, kporttime
kRMSL	rms		ainL	
kRMSR	rms		ainR
kModFrqL	=	kModFrqL + (cpsoct(kRMSL*k3*100))
kModFrqR	=		kModFrqR + (cpsoct(kRMSR*k3*100))

aModL	poscil	1, kModFrqL, i(gkwaveL) 
aModR	poscil	1, kModFrqR, i(gkwaveR) 					
aoutL	sum		ainL*kDry, ainL*aModL*kWet			
aoutR	sum		ainR*kDry, ainR*aModR*kWet		
rireturn	
	outs aoutL, aoutR
	
	endin

</CsInstruments>
<CsScore>
f1  0 16384 10   1
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
  <uuid>{927ad31f-b106-46a9-8b36-9cdb97b4e590}</uuid>
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
