;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	LowResX
;;
;;	by Richard Boulanger and Colman O'Reilly
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
gkswitch chnget "switch"
gkfreq chnget "freq"
gkq chnget "q"
gkgain chnget "gain"
gklayers chnget "layers" ; 1-9
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 60000
endif
endin

instr 2
kfreq tonek gkfreq, 20
kq tonek gkq, 10
kgain tonek gkgain, 20

ainL, ainR ins
kgate linen .1, .01, p3, .1
kchange changed gklayers
if (kchange == 1) then
reinit START
endif
START:    
aoutL lowresx ainL, kfreq, kq+.013, i(gklayers)
aoutR lowresx ainR, kfreq, kq+.013, i(gklayers)
aoutL = aoutL * kgate
aoutR = aoutR * kgate
rireturn

if gkswitch == 1 then
	aoutL balance aoutL, ainL
	aoutR balance aoutR, ainR
elseif gkswitch == 0 then
	aoutL clip aoutL, 0, .95
	aoutR clip aoutR, 0, .95
endif

 
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
