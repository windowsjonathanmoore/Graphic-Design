;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	ClassicFilt
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

gkfreq chnget "cornerfreq"
gktype chnget "type"
gkkind chnget "kind"
gknpol	chnget "npol"
gkgain chnget "gain"

endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr 1

ainL, ainR ins

kfreq tonek gkfreq, 10
kgain tonek gkgain, 10

kSwitch changed gktype, gkkind, gknpol
if kSwitch=1 then	
reinit START	
endif

START:
aoutL clfilt ainL, kfreq, i(gktype), i(gknpol), i(gkkind)
aoutR clfilt ainR, kfreq, i(gktype), i(gknpol),i(gkkind)
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
  <uuid>{52407aa0-3e16-4d84-be26-c980b1eb0d30}</uuid>
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
