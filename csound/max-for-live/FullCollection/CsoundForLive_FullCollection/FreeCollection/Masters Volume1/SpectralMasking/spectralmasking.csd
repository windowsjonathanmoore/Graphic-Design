;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Spectral Masking
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
sr = 44100
ksmps = 16
nchnls = 2
0dbfs = 1

turnon 10

gifftsize	=		1024
gitab		ftgen		0, 0, gifftsize, 7, 1, gifftsize, 1

instr 10
ktrig	metro	1000
if (ktrig == 1)	then

gklevelL	chnget	"limitL"
gklevelR	chnget	"limitR"
gksensitivity chnget "sensitivity"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr 1
ainL, ainR ins


fsigL		pvsanal	ainL, gifftsize, gifftsize/4, gifftsize, 0

klevelL	tonek gklevelL, 10
fstencilL	pvstencil	fsigL, 0, klevelL, gitab
aoutL		pvsynth	fstencilL

fsigR		pvsanal	ainR, gifftsize, gifftsize/4, gifftsize, 0

klevelR	tonek gklevelR, 10
fstencilR	pvstencil	fsigR, 0, klevelR, gitab
aoutR		pvsynth	fstencilR


		outs		aoutL, aoutR
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
  <uuid>{21faae05-faa0-44ae-bbfc-87a792ba09ae}</uuid>
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
