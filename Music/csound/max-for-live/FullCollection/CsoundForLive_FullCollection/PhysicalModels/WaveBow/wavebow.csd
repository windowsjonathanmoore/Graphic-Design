;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Wave Bow
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

turnon 2
massign 1, 3


instr 1
ktrig	metro	100
if (ktrig == 1)	then
gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"
gklfotype chnget "lfotype"
gkspread chnget "spread"
gkdetune chnget "detune"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkvoices chnget "voices"

gkpressure chnget "pressure"
gkpos chnget "position"
gkvibf chnget "vibrato"
gkvibamp chnget "vibamp"

gkdelfo chnget "lfodelay"
gkfco chnget "fco"
gkfiltatt chnget "filtatt"
gkfiltdec chnget "filtdec"
gkfiltsus chnget "filtsus"
gkfiltrel chnget "filtrel"
gkfiltadsrbypass chnget "filtadsrbypass"

endif
endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 2
kinstr init 3
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin


instr 3
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay

iampfix = .35
iamp ampmidi 1
kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)

;; Thanks to Iain McCurdy for creating this pitch section I adapted for this instrument.

ioct	octmidi
iSemitoneBendRange = 2
imin = 0
imax = iSemitoneBendRange * .0833333
kbend	pchbend	imin, imax	
kfrq1	=	cpsoct(ioct+ kbend + klfo)
kfrq2	=	cpsoct(ioct+ kbend + gkdetune + klfo)

aout1 wgbow kenv, kfrq1, gkpressure, gkpos, gkvibf, .005, 1
aout2 wgbow kenv, kfrq2, gkpressure, gkpos, gkvibf, .005, 1

if gkfiltadsrbypass == 0 then
aoutA moogladder aout1, gkfco, gkq*.99
aoutB moogladder aout2, gkfco, gkq*.99
aout1 balance aoutA, aout1
aout2 balance aoutB, aout2
else
kfilt madsr i(gkfiltatt), i(gkfiltdec), i(gkfiltsus), i(gkfiltrel)
aout1 moogladder aout1, kfilt*gkfco, gkq*.99
aout2 moogladder aout2, kfilt*gkfco, gkq*.99
aout1 clip aout1, 0, .99
aout2 clip aout2, 0, .99
endif


;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

aoutL dcblock2 aoutL
aoutR dcblock2 aoutR

outs aoutL*iampfix, aoutR*iampfix
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
  <uuid>{312eef82-ebc4-4a90-9953-5a15501af166}</uuid>
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
