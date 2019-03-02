;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Spectral Blur
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
ksmps		=	128
nchnls	=	2
0dbfs		=	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then
gkblurtimeL chnget "kblurL"
gkblurtimeR chnget "kblurR"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 99999
endif
endin

instr 1
ainL, ainR ins

ifftsize	= 1024
ioverlap	= ifftsize*.25
iwinsize	= ifftsize
iwinshape	= 0	
fftinL	pvsanal ainL, ifftsize, ioverlap, iwinsize, iwinshape
fftinR	pvsanal ainR, ifftsize, ioverlap, iwinsize, iwinshape
fftblurL	pvsblur fftinL, gkblurtimeL, 1
fftblurR	pvsblur fftinR, gkblurtimeR, 1 
aoutL	pvsynth fftblurL
aoutR	pvsynth fftblurR	

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
