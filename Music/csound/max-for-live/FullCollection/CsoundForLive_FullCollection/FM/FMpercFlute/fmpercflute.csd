;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	FM PercFlute
;;
;;	by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr		=	44100
ksmps		=	16
nchnls	=	2
0dbfs 	= 	1

turnon 1
turnon 2
massign 1, 3


instr 1
ktrig	metro	100
if (ktrig == 1)	then
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"
gkc1 chnget "index"
gkvdepth chnget "vibdep"
gkvrate chnget "vibrate"

gkspread chnget "spread"
gkdetune chnget "detune"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gklfotype chnget "lfotype"
gkvoices chnget "voices"
gkdelfo chnget "lfodelay"
gkfco chnget "fco"
gkfiltatt chnget "filtatt"
gkfiltdec chnget "filtdec"
gkfiltsus chnget "filtsus"
gkfiltrel chnget "filtrel"
gkfqstart chnget "fqstart"
gkfiltadsrbypass chnget "filtadsrbypass"

endif
endin


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 2
kinstr init 3
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin

instr 3
;Tuning Block:
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
iamp ampmidi .5

kc1 tonek gkc1, 10
kdelfo tonek gkdelfo, 10
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10

igain = 1.2

kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)

aout1 fmpercfl iamp*kenv, kfrq1+klfo, kc1, 1, 1, 1, 1, 1, 1, 1, 2 
aout2 fmpercfl iamp*kenv, kfrq2+klfo, kc1, 1, 1, 1, 1, 1, 1, 1, 2 

if gkfiltadsrbypass == 0 then
aoutA moogladder aout1, gkfco, gkq*.99
aoutB moogladder aout2, gkfco, gkq*.99
aout1 balance aoutA, aout1
aout2 balance aoutB, aout2
else
kfilt madsr i(gkfiltatt), i(gkfiltdec), i(gkfiltsus), i(gkfiltrel)
aout1 moogladder aout1, kfilt*gkfco, gkq*.99
aout2 moogladder aout2, kfilt*gkfco, gkq*.99
aout1 clip aout1, 0, .99
aout2 clip aout2, 0, .99
endif

;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

outs aoutL*igain, aoutR*igain

endin


</CsInstruments>
<CsScore>
f0 60000
f 1 0 32768 10 1
f 3 0 128 10 1
f 2 0 256 1 "fwavblnk.aiff" 0 0 0


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
  <uuid>{07524501-a29e-46db-959c-5594a5c45c22}</uuid>
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
