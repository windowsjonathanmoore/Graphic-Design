;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Butterworth Filts
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
0dbfs		=	1

instr	1
ktrig	metro	100
if (ktrig == 1)	then
gktype chnget "type"	
gkfreq chnget "freq"
gkband chnget "band"
gkgain chnget "gain"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 60000
endif
endin

instr 2
kfreq tonek gkfreq, 10
kband tonek gkband, 10
kgain tonek gkgain, 10

ainL, ainR ins

kChanged changed gktype
if kChanged == 1 then
reinit TYPE
endif
TYPE:

if gktype == 0 then
aoutL butterlp ainL, kfreq
aoutR butterlp ainR, kfreq
elseif gktype == 1 then
aoutL butterhp ainL, kfreq
aoutR butterhp ainR, kfreq
elseif gktype == 2 then
aoutL butterbp ainL, kfreq, kband
aoutR butterbp ainR, kfreq, kband
elseif gktype == 3 then
aoutL butterbr ainL, kfreq, kband
aoutR butterbr ainR, kfreq, kband
endif
rireturn

aoutL balance aoutL, ainL
aoutR balance aoutR, ainR
 
outs aoutL*kgain, aoutR*kgain

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
  <uuid>{e17dff78-0966-4976-9feb-1bcb4e7cedae}</uuid>
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
