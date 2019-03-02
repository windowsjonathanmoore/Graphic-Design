;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Compander
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
0dbfs		=	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then
gkthreshold chnget "thresh"
gkcomp1 chnget "comp1"
gkcomp2 chnget "comp2"
gkrtime chnget "rtime"
gkftime chnget "ftime"
gkgain chnget "gain"
endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr 1
ainL, ainR ins

kthreshold tonek gkthreshold, 10
kcomp1 tonek gkcomp1, 10
kcomp2 tonek gkcomp2, 10
krtime tonek gkrtime, 10
kftime tonek gkftime, 10

ktrig	changed	kcomp1, kcomp2, krtime, kftime
if ktrig=1 then
reinit	UPDATE
endif
	
UPDATE:
aCompL	dam		ainL, kthreshold, i(kcomp1), i(kcomp2), i(krtime), i(kftime)
aCompR	dam		ainR, kthreshold, i(kcomp1), i(kcomp2), i(krtime), i(kftime)
rireturn

aoutL balance aCompL, ainL
aoutR balance aCompR, ainR

aoutL clip aoutL, 0, .95
aoutR clip aoutR, 0, .95 

outs		aoutL*gkgain, aoutR*gkgain
endin

</CsInstruments>
<CsScore>
f0 60000
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
  <uuid>{f38e5cac-055c-4e4e-8f2f-d53ab2ff8afb}</uuid>
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
