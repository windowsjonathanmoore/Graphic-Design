;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	SampledFM
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
0dbfs		=	1

turnon 3
massign 1, 2


instr 1
ktrig	metro	100
if (ktrig == 1)	then

gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"
gkatt1 chnget "att1"
gkdec1 chnget "dec1"
gksus1 chnget "sus1"
gkrel1 chnget "rel1"
gklfotype chnget "lfotype"
gkindex	chnget	"Index"
gkCarRatio	chnget  	"Carrier_Frequency"
gkModRatio	chnget  	"Modulator_Frequency"
gkCarAmp	chnget	"Carrier_Amplitude"
gkspread chnget "spread"
gkdetune chnget "detune"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkvoices chnget "voices"
gkfco chnget "fco"
gktable chnget "table"
gkchange chnget "change"
gkdelfo chnget "lfodelay"
gkfiltatt chnget "filtatt"
gkfiltdec chnget "filtdec"
gkfiltsus chnget "filtsus"
gkfiltrel chnget "filtrel"
gkfqstart chnget "fqstart"
gkfiltadsrbypass chnget "filtadsrbypass"
endif
endin

instr	2
Sfilename 	chnget 	"filename"    
gifile	ftgen		2, 0, 0, -1, Sfilename, 0, 0, 1

ktablecps = sr/ftlen(gifile)

;;Tuning Block:;;;;;;;;;;;;;;;;;;;;;;;;;;
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kbasefreq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kbasefreq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
iamp ampmidi 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10
kdelfo tonek gkdelfo, 10
kindex tonek gkindex, 10
kq tonek gkq, 10
kCarRatio tonek gkCarRatio, 10
kModRatio tonek gkModRatio, 10
kspread tonek gkspread, 10
	
kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
kenv1 madsr i(gkatt1), i(gkdec1), i(gksus1), i(gkrel1)	;mod env
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)  

kpeakdeviation = kbasefreq1 * kindex
aModulator	poscil kpeakdeviation*kenv1, ktablecps * kModRatio, 2
		
aout1	poscil gkCarAmp*kenv, ((kbasefreq1 * kCarRatio) + aModulator) + klfo, 1
aout2	poscil gkCarAmp*kenv, ((kbasefreq2 * kCarRatio) + aModulator) + klfo, 1			

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
aoutL = ((aout1 * kspread) + (aout2 * (1 - kspread))) *.5  
aoutR = ((aout1 * (1-kspread)) + (aout2 * kspread))   *.5

outs aoutL, aoutR										
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
f1  0 4096 10   1
i1 0 		99999
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
  <uuid>{9affdb78-9d0d-4513-b597-527a3e3b1a5e}</uuid>
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
