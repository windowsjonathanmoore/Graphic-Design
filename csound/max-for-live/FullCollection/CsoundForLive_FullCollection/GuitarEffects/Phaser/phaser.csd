;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Phaser
;;
;;	by Richard Boulanger and Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
-old parser
</CsOptions>
<CsInstruments>
sr		=	44100
ksmps		=	10
nchnls	=	2
0dbfs		=	1

instr 1
ktrig	metro	100
if (ktrig == 1)	then

gklfo chnget "lfo"
gkwet chnget "wet"
gkorder chnget "order"
gkfeed chnget "feed"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 60000
endif

endin

instr 2
klfo tonek gklfo, 20
korder tonek gkorder, 20
kwet tonek gkwet, 20
kfeed tonek gkfeed, 20

ainL, ainR ins

kSwitch changed korder
if kSwitch == 1 then
reinit START
endif

START:

kfreq  oscili 5555, klfo, 1
kmod   = kfreq + 6000

aphsL phaser1 ainL, kmod, int(korder), kfeed
aphsR phaser1 ainR, kmod, int(korder), kfeed
rireturn

aoutL ntrpol ainL, aphsL, kwet
aoutR ntrpol ainR, aphsR, kwet

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
  <uuid>{b0e0e7a6-87fe-4a5b-a996-60b52aada3cb}</uuid>
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
