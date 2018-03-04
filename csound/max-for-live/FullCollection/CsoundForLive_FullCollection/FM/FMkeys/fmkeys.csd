;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	FM Keys
;;
;;	by Colman O'Reilly
;;	www.colmanoreilly.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr		=	44100
ksmps		=	16
nchnls	=	2
0dbfs		=	1

turnon 3
massign 1, 2

instr 1
ktrig	metro	100
if (ktrig == 1)	then

gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"
gkspread chnget "spread"
gkdetune chnget "detune"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gklfotype chnget "lfotype"
gkvoices chnget "voices"

gkinstr chnget "instr"
gkc1 chnget "index"
gkvdepth chnget "vibdep"
gkvrate chnget "vibrate"
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

instr 2
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
kfrqb31 = cpsmidinn(imidinn + gksemi + kcent + gkbend - 19)
kfrqb32 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend - 19)
iamp ampmidi .2

igain = 2.5
kc1 tonek gkc1, 10
kvdepth tonek gkvdepth, 10
kvrate tonek gkvrate, 10
kdelfo tonek gkdelfo, 10
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10

kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)

if gkinstr == 0 then
	aout1 fmb3 iamp*kenv, kfrqb31+klfo, kc1, 5, kvdepth, kvrate, 1, 1, 1, 1, 1 
	aout2 fmb3 iamp*kenv, kfrqb32+klfo, kc1, 5, kvdepth, kvrate, 1, 1, 1, 1, 1 
elseif gkinstr == 1 then
	aout1 fmrhode iamp*kenv, kfrq1+klfo, kc1, 0, gkvdepth, gkvrate, 1, 1, 1, 2, 1 
	aout2 fmrhode iamp*kenv, kfrq2+klfo, kc1, 0, gkvdepth, gkvrate, 1, 1, 1, 2, 1 
elseif gkinstr == 2 then
	aout1 fmwurlie iamp*kenv, kfrq1+klfo, kc1, 1, kvdepth, kvrate, 1, 1, 1, 2, 1 
	aout2 fmwurlie iamp*kenv, kfrq2+klfo, kc1, 1, kvdepth, kvrate, 1, 1, 1, 2, 1 
endif

if gkfiltadsrbypass == 0 then
aoutA moogladder aout1, gkfco, gkq*.99
aoutB moogladder aout2, gkfco, gkq*.99
aout1 balance aoutA, aout1
aout2 balance aoutB, aout2
else
kfilt madsr i(gkfiltatt), i(gkfiltdec), i(gkfiltsus), i(gkfiltrel)
aout1 moogladder aout1, kfilt*gkfco, gkq
aout2 moogladder aout2, kfilt*gkfco, gkq
aout1 clip aout1, 0, 1
aout2 clip aout2, 0, 1
imoregain = 3
aout1 = aout1 * imoregain
aout2 = aout2 * imoregain
endif

;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

outs aoutL*igain, aoutR*igain
endin


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 3
kinstr init 2
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin


</CsInstruments>
<CsScore>
f 1 0 32768 10 1
f 2 0 256 1 "fwavblnk.aiff" 0 0 0

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
  <uuid>{fe7cb11d-72af-4704-89d7-f4bef24e85c6}</uuid>
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
