;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Spectral Bin Shifter
;;		Inspired by the work of Iain McCurdy
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
ksmps = 100
nchnls	=	2
0dbfs		=	1

instr 1

gifftsize = 1024

ginoosc init 256

ktrig	metro	100
if (ktrig == 1)	then
gknoosc chnget "nooscs"
gkfmod chnget "pitch"
gkbinoffset chnget "binoffset"
gkbinincr chnget "binincr"
endif

kchanged1 changed gknoosc, gkbinoffset, gkbinincr
if kchanged1 == 1 then
reinit LIMIT
endif
LIMIT:
ginoosc limit i(gknoosc), 0, (((gifftsize*0.5)+1)-i(gkbinoffset))/i(gkbinincr)
rireturn

kevent init 1
if (kevent == 1) then
kevent = 7
gknoosc = gknoosc+1
endif


kchanged changed gknoosc, gkbinoffset, gkbinincr
if kchanged == 1 then
turnoff2 2, 0, 0
event "i", 2, 0.1, 60000
endif

endin

instr 2
kbinoffset init 1
kbinincr init 1
kfmod init 1
kginoosc init 1
gainL, gainR ins
iampfix = 1
knoosc = int(gknoosc)
kfmod tonek gkfmod, 20
kbinoffset = int(gkbinoffset)
kbinincr = int (gkbinincr)

fsigL pvsanal gainL, gifftsize, gifftsize/4, gifftsize, 1
fsigR pvsanal gainR, gifftsize, gifftsize/4, gifftsize, 1
       
aoutL pvsadsyn fsigL, ginoosc, kfmod, i(kbinoffset), i(kbinincr)
aoutR pvsadsyn fsigR, ginoosc, kfmod, i(kbinoffset), i(kbinincr)

aoutL balance aoutL, gainL
aoutR balance aoutR, gainR

aoutL clip aoutL, 0, .99
aoutR clip aoutR, 0, .99

outs aoutL*iampfix, aoutR*iampfix
endin

</CsInstruments>
<CsScore>
i1 0 99999


</CsScore>
</CsoundSynthesizer>

<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>30</width>
 <height>105</height>
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
  <uuid>{9c9ec4c4-7af8-4444-b0f1-97336a582249}</uuid>
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
<MacOptions>
Version: 3
Render: Real
Ask: Yes
Functions: ioObject
Listing: Window
WindowBounds: -900 -770 98 28
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 slider1
</MacGUI>
