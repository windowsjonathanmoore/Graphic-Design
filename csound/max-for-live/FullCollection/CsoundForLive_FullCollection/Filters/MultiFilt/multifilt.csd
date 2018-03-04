;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	MultiFilt
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
ksmps		=	16
nchnls	=	2
0dbfs 	= 	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then

gkfreq chnget "cutoff"
gkkind chnget "type"
gkq chnget "q" ;Q / BW
gkslope chnget "slope" ;0 - 1
gkgain chnget "gain"


gkparagain		chnget 	"paragain"

endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr 1
kgain tonek gkgain, 20
kfreq tonek gkfreq, 20
kparagain tonek gkparagain, 20
kq tonek gkq, 20
kslope tonek gkslope, 20

if gkkind == 0 then
	kfilter = 0 ;res low pass
elseif gkkind == 1 then
	kfilter = 2 ;res hi pass
elseif gkkind == 2 then
	kfilter = 4 ;bandpass
elseif gkkind == 3 then
	kfilter = 6 ;bandreject
elseif gkkind == 4 then
	kfilter = 8 ;peaking EQ
elseif gkkind == 5 then
	kfilter = 10 ;lowshelf EQ
elseif gkkind == 6 then
	kfilter = 12 ;hishelf EQ
endif
	
ainL, ainR ins

kfreq tonek gkfreq, 20

kSwitch changed kfilter
if kSwitch=1 then	
reinit START	
endif

START:
aoutL rbjeq ainL, kfreq, kparagain, kq, 1, i(kfilter)
aoutR rbjeq ainR, kfreq, kparagain, kq, 1, i(kfilter)
rireturn

aoutL balance aoutL, ainL
aoutR balance aoutR, ainR

outs aoutL*kgain, aoutR*kgain

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
  <uuid>{4a2b6222-2333-43f4-a09f-bb56f1bfad73}</uuid>
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
