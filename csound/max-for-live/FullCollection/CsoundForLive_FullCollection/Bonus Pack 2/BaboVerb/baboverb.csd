;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;; 	Ball Within The Box Reverb
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
kr = 441
nchnls	=	2
0dbfs		=	1

turnon 1

instr 1
gkx init 1
gky init 1
gkz init 1
gkxsize init 1
gkysize init 1
gkzsize init 1


ktrig	metro	100
if (ktrig == 1)	then

gkx chnget "xvalue"
gky chnget "yvalue"
gkz chnget "zvalue"
gkxsize chnget "xsize"
gkysize chnget "ysize"
gkzsize chnget "zsize"


endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, .3, 60000
endif
endin


instr 2
ainL, ainR ins
ainput = (ainL + ainR)*.5

denorm ainput

kSwitch changed gkxsize, gkysize, gkzsize, gkx, gky, gkz
if kSwitch=1 then	
reinit START	
endif

START:
aoutL,aoutR babo ainput*0.9, gkx, gky, gkz, i(gkxsize), i(gkysize), i(gkzsize)
rireturn

aoutL dcblock2 aoutL
aoutR dcblock2 aoutR

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
  <uuid>{4cfbbcf6-0826-41d4-8691-793cb4d2011b}</uuid>
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
