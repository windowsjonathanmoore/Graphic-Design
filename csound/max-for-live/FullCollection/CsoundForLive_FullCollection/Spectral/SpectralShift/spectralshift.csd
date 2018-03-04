;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	FqRescale
;;	by Iain McCurdy
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
sr 		= 	44100			
ksmps 	= 	128
nchnls 	= 	2		
0dbfs		=	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then
gkshift 	chnget "scale"
gklofreq	chnget "lofreq"
gkform	chnget "formants"
gkscale	chnget "rescale"
gkswitch chnget "switch"
gkoutgain chnget "gain"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 99999
endif
endin


instr 1
ainL, ainR 	ins

kfftsize init 1024

kshift tonek gkshift, 10
kscale tonek gkscale, 10
koutgain tonek gkoutgain, 10

koverlap = kfftsize/4
kwinsize = kfftsize

igain = 1

kSwitch	changed kfftsize, gkform
if kSwitch=1 then	
reinit START	
endif

START:
fsigL1	pvsanal	ainL, i(kfftsize), i(koverlap), i(kwinsize), 1
fsigL2 	pvshift	fsigL1, kshift, gklofreq, i(gkform), igain
fsigL3	pvscale 	fsigL2, kscale, i(gkform), igain

fsigR1	pvsanal	ainR, i(kfftsize), i(koverlap), i(kwinsize), 1
fsigR2 	pvshift	fsigR1, kshift, gklofreq, i(gkform), igain
fsigR3	pvscale 	fsigR2, kscale, i(gkform), igain

aoutL 	pvsynth  	fsigL3
aoutR 	pvsynth  	fsigR3
rireturn


if gkswitch == 1 then
	aoutL balance aoutL, ainL*.8
	aoutR balance aoutR, ainR*.8
	aoutL = aoutL * koutgain
	aoutR = aoutR * koutgain
elseif gkswitch == 0 then
aoutL = aoutL * koutgain
aoutR = aoutR * koutgain
	aoutL clip aoutL, 0, .95
	aoutR clip aoutR, 0, .95
endif

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
