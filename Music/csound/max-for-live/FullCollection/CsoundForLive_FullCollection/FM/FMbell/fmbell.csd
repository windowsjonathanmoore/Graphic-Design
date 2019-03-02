;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	FmBell
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
ksmps		=	128
nchnls	=	2
0dbfs 	= 	1


giWin1 ftgen 1, 0, 16384, 10, 1		; Sine

garevL init 0
garevR init 0

turnon 22
turnon 3

instr 10 


ktrig	metro	100
if (ktrig == 1)	then

gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"

gklfotype chnget "lfotype"
gkmeth1 chnget "meth" ;1-6
gkfn chnget "fn" ; 1-10
gkspread chnget "spread"
gkdetune chnget "detune"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkvoices chnget "voices"


gkindex1 chnget "index1"
gkcrossfade chnget "xfade"
gkvdepth chnget "vibdep"
gkvrate chnget "vibrate"
gkrev chnget "reverb"
gkmix chnget "mix"
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

kindex tonek gkindex1, 20
kindex = int(kindex)

aout1 fmbell kenv*iamp, (kfrq1+klfo), kindex, gkcrossfade, gkvdepth, gkvrate, 1, 1, 1, 1, 1
aout2 fmbell kenv*iamp, (kfrq2+klfo), kindex, gkcrossfade, gkvdepth, gkvrate, 1, 1, 1, 1, 1


if gkfiltadsrbypass == 0 then
aoutA moogladder aout1, gkfco, gkq*.99
aoutB moogladder aout2, gkfco, gkq*.99
aout1 balance aoutA, aout1
aout2 balance aoutB, aout2
else
kfilt madsr i(gkfiltatt), i(gkfiltdec), i(gkfiltsus), i(gkfiltrel)
aout1 moogladder aout1, kfilt*gkfco, gkq
aout2 moogladder aout2, kfilt*gkfco, gkq
aout1 clip aout1, 0, .99
aout2 clip aout2, 0, .99
imoregain = 3
aout1 = aout1 * imoregain
aout2 = aout2 * imoregain
endif

;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

outs aoutL, aoutR
garevL = aoutL*gkmix
garevR = aoutR*gkmix

endin

instr 3
aoutL, aoutR reverbsc garevL, garevR, gkrev, 12000
outs aoutL, aoutR
clear garevL, garevR
endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr 22
kinstr init 1
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin

</CsInstruments>
<CsScore>
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
