;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Modeled Analog Kick Drum
;;
;;	by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr	 =	44100
ksmps	 =	1
nchnls	=	2
0dbfs = 1

turnon 22

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then
gkbrr		chnget	"bitraterelease"
gklpfilt	chnget	"lpfilt"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
endif

endin

instr 1 ;; Analog Kick Drum

imidinn notnum
kcent = gkcenttmp * 0.01
ifrq = cpsmidinn(imidinn + i(gksemi) + i(kcent))

iamp ampmidi 1


;ifrq cpsmidi

/*
iatt = i(kfrq)
isus = i(kfrq)/4
*/

iatt = ifrq
isus = ifrq / 4


klpfilt tonek gklpfilt, 20

kcps linseg iatt, .005, isus	 	;; Quick Pitch envelope
kamp expsegr 1, .5, 0.001, .01, 0.001		;; Amplitude envelope
kbR linseg 2, .01, i(gkbrr)+1	 	;; BitRate envelope

aout foscil .9, kcps, .25, .99, 3, 1
;out oscil .9, kcps, 1


kin downsamp aout ;; Downsampler
kin = kin + 1 
kin = kin*(kbR/2) 
kin = int(kin) 
aout upsamp kin
aout = aout*(2/kbR) - 1 
aout butterlp aout, klpfilt


outs aout*(kamp*iamp), aout*(kamp*iamp)
endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr 22
kinstr init 1
kactive active kinstr
if kactive > 24 then
turnoff2 kinstr, 1, 0.1
endif
endin

</CsInstruments>
<CsScore>
f1 0 4096 10 1

f0 60000

t 0 130 ;tempo
e

i1 0 1
i1 1 1
i1 2 1
i1 3 1
i1 4 1

</CsScore>
</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>22</y>
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
  <uuid>{802e1878-0edf-4a3e-9622-95856052aea2}</uuid>
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
<MacOptions>
Version: 3
Render: Real
Ask: Yes
Functions: ioObject
Listing: Window
WindowBounds: 72 179 400 200
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 slider1
</MacGUI>
