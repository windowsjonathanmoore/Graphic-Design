;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Spectral Sample and Hold
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

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1


instr	1
ktrig	metro	1000
if (ktrig == 1)	then
gkwaveL chnget "waveL"	
gkwaveR chnget "waveR"	
gkmix chnget "mix"
gkreftm chnget "poll"
gkspread chnget "spread"
gkbalance chnget "balance"

endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 99999
endif
endin


instr 2
ainL, ainR ins

ifftsize = 1024
ioverlap = ifftsize/4
iwinsize = ifftsize


fsig1  pvsanal   ainL, ifftsize, ioverlap, iwinsize, 0
fsig2  pvsanal   ainR, ifftsize, ioverlap, iwinsize, 0
ktrig		metro		1 / gkreftm
if ktrig == 1 then

kcenter1  pvscent fsig1
kcenter2  pvscent fsig2
endif

if gkwaveL == 0 then
aoutL oscili 1, kcenter1, 1
elseif gkwaveL == 1 then
aoutL vco2 1, kcenter1, 0, .5
elseif gkwaveL == 2 then
aoutL vco2 1, kcenter1, 2, .5
elseif gkwaveL == 3 then
aoutL vco2 1, kcenter1, 4, .5
endif

if gkwaveR == 0 then
aoutR oscili 1, kcenter2, 1
elseif gkwaveR == 1 then
aoutR vco2 1, kcenter2, 0, .5
elseif gkwaveR == 2 then
aoutR vco2 1, kcenter2, 2, .5
elseif gkwaveR == 3 then
aoutR vco2 1, kcenter2, 4, .5
endif

aout1 ntrpol ainL, aoutL, gkmix
aout2 ntrpol ainR, aoutR, gkmix

aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

if gkbalance == 1 then
aoutL balance aoutL, ainL
aoutR balance aoutR, ainR
endif

aoutL dcblock2 aoutL
aoutR dcblock2 aoutR

       outs aoutL, aoutR
endin


</CsInstruments>
<CsScore>
f1  0 16384 10   1

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
  <uuid>{d6fb6404-f84b-4c67-afe1-22a75d0c2c36}</uuid>
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
