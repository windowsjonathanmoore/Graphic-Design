;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Moog Filts	
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

instr	1
ktrig	metro	100
if (ktrig == 1)	then
gktype chnget "type"	; 0=lp, 1=hp, 2=bp, 3=br	
gkfreq chnget "freq"
gkq chnget "q"
gkdist chnget "dist"
gkgain chnget "gain"
gkrezzyq chnget "rezzyQ"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 60000
endif
endin

instr 2
kfreq tonek gkfreq, 20
kq tonek gkq, 20
kdist tonek gkdist, 20
kgain tonek gkgain, 20
krezzyq tonek gkrezzyq, 20

ainL, ainR ins

kChanged changed gktype
if kChanged == 1 then
reinit TYPE
endif
TYPE:
if gktype == 0 then
aoutL moogvcf2 ainL, kfreq, kq
aoutR moogvcf2 ainR, kfreq, kq

elseif gktype == 1 then
aoutL moogladder ainL, kfreq, kq
aoutR moogladder ainR, kfreq, kq

elseif gktype == 2 then
aoutL lpf18 ainL, kfreq, kq, kdist
aoutR lpf18 ainR, kfreq, kq, kdist

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
