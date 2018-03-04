;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Spectral Morph
;;		Inspired by the work of Iain McCurdy
;;	Adapted for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
-old parser
</CsOptions>
<CsInstruments>
sr		=	44100
ksmps		=	256
nchnls	=	2
0dbfs		=	1

instr 1
gainL, gainR ins

ktrig	metro	100
if (ktrig == 1)	then
gkampint chnget "ampint"
gkfrqint chnget "frqint"
gkgain1 chnget "gain1"
gkgain2 chnget "gain2"
gkloop chnget "kloop"
gkspeed chnget "speed"

endif
endin



instr 2
kampint tonek gkampint, 20
kfrqint tonek gkfrqint, 20
kgain1 tonek gkgain1, 20
kgain2 tonek gkgain2, 20

kampint = kampint * 0.001
kfrqint = kfrqint * 0.001

gSfilename chnget "filename"
ichn	filenchnls gSfilename

kswitch changed gkloop
if kswitch == 1 then
reinit START
endif
START:
if ichn == 1 then
	adiskinL diskin2 gSfilename, gkspeed ,0, i(gkloop)
	adiskinR = adiskinL
else
	adiskinL, adiskinR diskin2 gSfilename, gkspeed ,0, i(gkloop)
endif
rireturn
ifftsize = 1024

fsigL1 pvsanal gainL*kgain1, ifftsize, ifftsize/4, ifftsize, 1
fsigR1 pvsanal gainR*kgain1, ifftsize, ifftsize/4, ifftsize, 1
fsigL2 pvsanal adiskinL*kgain2, ifftsize, ifftsize/4, ifftsize, 1
fsigR2 pvsanal adiskinR*kgain2, ifftsize, ifftsize/4, ifftsize, 1

foutL pvsmorph fsigL1, fsigL2, kampint, kfrqint
foutR pvsmorph fsigR1, fsigR2, kampint, kfrqint

aoutL pvsynth foutL
aoutR pvsynth foutR

outs aoutL, aoutR

endin

instr 3
turnoff2 2, 0, 0
gSfilename chnget "filename" ;redundancy to make sure gSfilename always has a value.
endin


instr 4 ;;; ACTIVE monitoring instrument.
kactive active 2
if kactive == 0 then
outs gainL, gainR
endif

if kactive > 1 then
turnoff2 2, 1, 0
endif

endin


</CsInstruments>
<CsScore>
i1 0 99999
i4 0 99999

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
  <uuid>{92339812-90b8-4da6-a4bb-61365d2d5e51}</uuid>
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
