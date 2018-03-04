;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Sample Freeze
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
kr = 4410
ksmps = 10
nchnls = 2
0dbfs = 1

turnon 1

instr 1
ktrig	metro	100
if (ktrig == 1)	then
kresample 	chnget "kpitch"
gkresample tonek kresample, 20
gktimewarp 	chnget "itimewarp"
gimode	= 1

kchange chnget "change"
endif

kSwitch changed kchange
if kSwitch == 1 then
;reinit START
turnoff2 2, 0, 0
endif

endin

instr 2

gSfilename	chnget "filename"
gir		ftgen		1, 0, 2097152, 1, gSfilename, 0, 0, 0
gis		ftgen		2, 0, 16384, 9, 0.5, 1, 0
ichn		filenchnls		gSfilename

ibeg = 0
iwsize = 4410
irandw = 882
ioverlap = 15
ifn2 = 2

if ichn == 1 then
aoutL sndwarp .6, gktimewarp, gkresample, 1, ibeg, iwsize, irandw, ioverlap, 2, gimode
aoutR = aoutL
else
aoutL, aoutR sndwarpst .6, gktimewarp, gkresample, 1, ibeg, iwsize, irandw, ioverlap, 2, gimode
endif
rireturn

outs aoutL, aoutR
endin

instr 3
turnoff2 2, 0, 0
gSfilename chnget "filename" ;redundancy to make sure gSfilename always has a value.
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
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBConsole">
  <objectName/>
  <x>10</x>
  <y>10</y>
  <width>400</width>
  <height>500</height>
  <uuid>{f1a97649-0415-4d46-bf1d-cf21a15774f8}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <font>Courier</font>
  <fontsize>8</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
