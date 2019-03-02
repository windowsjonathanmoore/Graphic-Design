;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	DownSamp
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
ksmps = 16
nchnls	=	2
0dbfs		=	1

instr 1
ktrig	metro	100
if (ktrig == 1)	then
gkbit chnget "kbit"
gkswitch chnget "switch"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 60000
endif
endin

instr 2
aSigL, aSigR ins

kvalues 	pow	2, ((gkbit)*15)+1	
k16bit 	pow	2, 16	

aoutL	= (int((aSigL*32768*kvalues)/k16bit)/32768)*(k16bit/kvalues)
aoutR	= (int((aSigR*32768*kvalues)/k16bit)/32768)*(k16bit/kvalues)

if gkswitch == 1 then
	aoutL balance aoutL, aSigL
	aoutR balance aoutR, aSigR
elseif gkswitch == 0 then
	aoutL clip aoutL, 0, .95
	aoutR clip aoutR, 0, .95
endif

outs aoutL, aoutR
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
  <uuid>{cadbbb94-accf-4a77-8362-2be25f03e6ed}</uuid>
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
