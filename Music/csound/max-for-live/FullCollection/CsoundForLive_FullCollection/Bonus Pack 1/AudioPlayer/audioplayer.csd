;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	AudioPlayer
;;
;;	by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr		=	44100
kr = 4410
nchnls	=	2
0dbfs 	= 	1

turnon 1
instr 1
ktrig	metro	100
if (ktrig == 1)	then
giloop	chnget "kloop"
gkpitch chnget "kpitch"
kchange chnget "change"
endif

kSwitch changed kchange
if kSwitch == 1 then
turnoff2 2, 0, 0

endif


endin


instr 2
kpitch tonek gkpitch, 20
gSfilename chnget "filename"
ichn	filenchnls		gSfilename

if ichn == 1 then
ainL diskin2 gSfilename, gkpitch ,0, giloop 
ainR = ainL
else
ainL, ainR diskin2 gSfilename, gkpitch ,0, giloop 
endif

outs ainL, ainR
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
  <uuid>{1befd26a-fafa-4729-8c72-38739c9b84f7}</uuid>
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
