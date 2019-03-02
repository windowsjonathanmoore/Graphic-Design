;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;; 	Waveguide Reverb
;;	based on the work of Sean Costello
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

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then

gkcut chnget "kcut"
gkwetL chnget "kwetL"
gkwetR chnget "kwetR"

endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 99999
endif
endin

instr 1
ainL, ainR ins

kwetL tonek gkwetL, 10
kwetR tonek gkwetR, 10

aL, aB reverbsc ainL, ainL, kwetL, gkcut
ac, aR reverbsc ainR, ainR, kwetR, gkcut

aoutL = aL+(1-kwetL)*ainL
aoutR = aR+(1-kwetR)*ainR

aoutL dcblock2 aoutL
aoutR dcblock2 aoutR

outs aoutL, aoutR
endin

</CsInstruments>
<CsScore>
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
  <uuid>{4cfbbcf6-0826-41d4-8691-793cb4d2011b}</uuid>
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
