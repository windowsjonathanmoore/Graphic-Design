;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Spectral Freeze
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
sr 		= 	44100		
ksmps 	= 	16
nchnls 	= 	2		
0dbfs		=	1

turnon 10

instr 10
ktrig	metro	100
if (ktrig == 1)	then

gkfreezea chnget "freezeamp"
gkfreezef chnget "freezefreq"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 99999
endif
endin
instr 1
iampfix = .9
ainL, ainR ins

kfftsize init 1024

koverlap = kfftsize/4
kwinsize = kfftsize

ikeepform = 0
igain = 1

kSwitch	changed kfftsize, gkfreezef, gkfreezea
if kSwitch=1 then	
reinit START	
endif

START:
fsigL1	pvsanal	ainL, i(kfftsize), i(koverlap), i(kwinsize), 1
fsigR1	pvsanal	ainR, i(kfftsize), i(koverlap), i(kwinsize), 1
fsigL2 pvsfreeze fsigL1, gkfreezea, gkfreezef
fsigR2 pvsfreeze fsigR1, gkfreezea, gkfreezef
aoutL 	pvsynth  	fsigL2
aoutR 	pvsynth  	fsigR2
rireturn

outs aoutL*iampfix, aoutR*iampfix
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
  <uuid>{b7d49a67-49ef-4ef7-abb4-2b07093d28d3}</uuid>
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