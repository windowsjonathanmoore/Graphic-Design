;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Mandolike
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
0dbfs 	= 	1


turnon 2

instr 10
ktrig	metro	100
if (ktrig == 1)	then
gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"
gklfotype chnget "lfotype"
gkspread chnget "spread"
gkdetune chnget "detune"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkvoices chnget "voices"
gkpos chnget "pos" ;0 to 1, .4
gksize chnget "body" ;0 to 2
gkloop chnget "loop"
gkdelfo chnget "lfodelay"
gkfco chnget "fco"
gkfiltatt chnget "filtatt"
gkfiltdec chnget "filtdec"
gkfiltsus chnget "filtsus"
gkfiltrel chnget "filtrel"
gkfiltadsrbypass chnget "filtadsrbypass"

endif

endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr 2
kinstr init 1
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin


instr 1
;Tuning Block:
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune +gkbend)
iamp ampmidi 1

klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay

kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)

icps cpsmidi
aout1 mandol kenv*iamp, (kfrq1+klfo), gkpos, 1, gkloop, gksize, 1, icps*.5
aout2 mandol kenv*iamp, (kfrq2+klfo), gkpos, 1, gkloop, gksize, 1, icps*.5

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

aouL dcblock2 aoutL
aoutR dcblock2 aoutR
outs aoutL*2, aoutR*2

endin



</CsInstruments>
<CsScore>
f1 0 8192 1 "mandpluk.aiff" 0 0 0

i10 0 99999
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
  <uuid>{722c67dd-16f3-419b-8d72-510916b98764}</uuid>
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
