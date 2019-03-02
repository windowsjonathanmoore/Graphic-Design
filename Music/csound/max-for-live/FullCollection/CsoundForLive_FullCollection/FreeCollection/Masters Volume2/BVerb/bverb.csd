;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	BVerb
;;	by Richard Boulanger
;;		an adaptation of the instrument "Swirl" from
;;		"Trapped in Convert"
;;	
;;	Adapted for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr		=	44100
ksmps		=	128
nchnls	=	2
0dbfs		=	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then

gkpan chnget "pan"
gkrvt chnget "reverb"
gkmix chnget "incoming"
gkfco chnget "damp"
endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 99999
endif
endin

instr 1
ainL, ainR ins
asig = (ainL + ainR)*.5

k1  oscil     .5, gkpan, 1
k2 = .5 + k1
k3 =         1 - k2
asig, asig1 reverbsc    asig, asig, gkrvt, gkfco

aoutL =      (ainL * (1-gkmix)) + (asig * k2 *gkmix)
aoutR = (((asig * k3) * (-1))*gkmix)+(ainR * (1-gkmix))

aoutL dcblock2 aoutL
aoutR dcblock2 aoutR
outs aoutL, aoutR
endin
</CsInstruments>
<CsScore>
f1  0 16384 10   1

f0 99999


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
  <uuid>{4212c8f3-5976-4e58-b13d-d4aeaa33b190}</uuid>
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
