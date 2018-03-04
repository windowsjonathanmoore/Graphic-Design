;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Tap Delay
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
sr 		= 	44100			
ksmps 	= 	16
nchnls 	= 	2		
0dbfs		=	1


instr 10
ktrig	metro	100
if (ktrig == 1)	then
gkdlt chnget "dlt"
gkmix chnget "wet"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 99999
endif
endin


instr 1
ainL, ainR ins
	
;;Left:	
abufferL	delayr	10
adelsigL 	deltap	gkdlt
		delayw	ainL	
	
;;Right:
abufferR	delayr	10
adelsigR 	deltap	gkdlt
		delayw	ainR	
	
aoutL		ntrpol	ainL, adelsigL, gkmix
aoutR		ntrpol	ainR, adelsigR, gkmix
	
aoutL dcblock2 aoutL
aoutR dcblock2 aoutR
outs	aoutL, aoutR
endin

</CsInstruments>
<CsScore>
i10 0 99999

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
  <uuid>{f1a7e142-f11a-4340-826f-fdc934906eb3}</uuid>
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
