;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	ResonLP
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
kr		=	4410
ksmps		=	10
nchnls	=	2
0dbfs		=	1

instr 1
ktrig	metro	100
if (ktrig == 1)	then

gkfreq chnget "freq"
gkgain chnget "gain"
gkq chnget "q"
endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 60000
endif
endin

instr 2

kfreq tonek gkfreq, 20
kgain tonek gkgain, 20
kq tonek gkq, 20

ainL, ainR ins
alpL butterlp ainL, kfreq
alpR butterlp ainR, kfreq
aoutLr reson ainL, kfreq, (20+kfreq*kq/8)
aoutRr reson ainR, kfreq, (20+kfreq*kq/8)

aoutL = ((alpL*2) + (aoutLr*kgain))*.5
aoutR = ((alpR*2) + (aoutRr*kgain))*.5

aoutL balance aoutL, ainL
aoutR balance aoutR, ainR

outs aoutL, aoutR
endin

</CsInstruments>
<CsScore>
f1  0 16384 10   1
i1 0 60000

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
  <uuid>{6da4ce28-3383-48ef-a52f-9494f511467f}</uuid>
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
