;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	String Resonator
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
kr = 4410
nchnls	=	2
0dbfs		=	1

turnon 1
instr 1
ktrig	metro	100
if (ktrig == 1)	then
gkfrq1	chnget "kfrq1"
gkfrq2	chnget "kfrq2"
gkfeed	chnget "feedback"
endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 99999
endif
endin

instr 2
igainfix = .4 
ainL, ainR ins

ainL butterlp ainL, 10000
ainR butterlp ainR, 10000

kfrq1 tonek gkfrq1, 5
kfrq2 tonek gkfrq2, 5

kchanged changed gkfeed
if kchanged == 1 then
reinit START
endif
START:
aL	streson ainL, kfrq1, i(gkfeed)
aR	streson ainR, kfrq1, i(gkfeed)
aoutL	streson aL*.5, kfrq2, i(gkfeed)
aoutR	streson aR*.5, kfrq2, i(gkfeed)
rireturn
;aL 	clip aL, 1, .95
;aR 	clip aR, 1, .95

;aoutL balance aL, ainL
;aoutR balance aR, ainR
aoutL dcblock2 aoutL
aoutR dcblock2 aoutR
	
outs aoutL*igainfix, aoutR*igainfix
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
  <uuid>{382d23a8-6ff2-4b78-b387-6bb830d6ce44}</uuid>
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
