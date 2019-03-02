;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Variable Delay
;;
;;	by Colman O'Reilly
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
0dbfs 	= 	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then
gkloop chnget "looptime"
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
igain = .4
ainL, ainR ins

kwetL tonek gkwetL, 20
kwetR tonek gkwetR, 20
kloop tonek gkloop, 20

kwetL = kwetL * 5 + 0.001
kwetR = kwetR * 5 + 0.001

denorm ainL, ainR
aL vcomb ainL, kwetL, kloop, 5
aR vcomb ainR, kwetR, kloop, 5

aoutL = (aL+(1-kwetL)*ainL)*igain
aoutR = (aR+(1-kwetR)*ainR)*igain

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
  <uuid>{f5075753-a780-4cd6-8984-161f54d15deb}</uuid>
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
