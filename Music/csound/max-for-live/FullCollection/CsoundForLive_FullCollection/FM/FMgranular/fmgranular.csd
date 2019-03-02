;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	FMgranular
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

giWin1		ftgen		1, 0, 4096, 20, 1, 1		; Hamming
giWave1		ftgen		10,0, 16384,10, 1			; Sine

instr 1
gkatt chnget "att"		
gkdec chnget "dec"		
gksus chnget "sus"		
gkrel chnget "rel"		
gkatt1 chnget "att1"		
gkdec1 chnget "dec1"		
gksus1 chnget "sus1"		
gkrel1 chnget "rel1"			
gklfotype chnget "lfotype"	
gkindex	chnget "Index"	
gkCarRatio	chnget "Carrier_Frequency"	
gkModRatio	chnget "Modulator_Frequency"	
gkCarAmp	= .5
gkspread chnget "spread"	
gkdetune chnget "detune"	
gklfoamp chnget "lfoamp"	
gklforate chnget "lforate"	
gkq chnget "resonance"		
gkcenttmp chnget "cents"	
gksemi chnget "semitones"	
gkvoices chnget "voices"	

gkmoddens chnget "modgrainrate"	
gkmodampdev chnget "modampdev"	
gkmodpitchdev chnget "modpitchdev"	
gkmodsize chnget "modsize" 

gkcardens chnget "cargrainrate"
gkcarampdev chnget "carampdev"	
gkcarpitchdev chnget "carpitchdev"	
gkcarsize chnget "carsize"	
gkdelfo chnget "lfodelay"
gkfco chnget "fco"
gkfiltatt chnget "filtatt"
gkfiltdec chnget "filtdec"
gkfiltsus chnget "filtsus"
gkfiltrel chnget "filtrel"
gkfqstart chnget "fqstart"
gkfiltadsrbypass chnget "filtadsrbypass"
endin




instr	2

;;Tuning Block:;;;;;;;;;;;;;;;;;;;;;;;;;;
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kbasefreq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kbasefreq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay

kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
kenv1 madsr i(gkatt1), i(gkdec1), i(gksus1), i(gkrel1)	;mod envg
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)    

kmoddens tonek gkmoddens, 20
kmodampdev tonek gkmodampdev, 20
kmodpitchdev tonek gkmodpitchdev, 20
kmodsize tonek gkmodsize, 20
kcardens tonek gkcardens, 20
kcarampdev tonek gkcarampdev, 20
kcarpitchdev tonek gkcarpitchdev, 20
kcarsize tonek gkcarsize, 20
kModRatio tonek gkModRatio, 20
kCarRatio tonek gkCarRatio, 20
kCarAmp tonek gkCarAmp, 20

kpeakdeviation = kbasefreq1 * gkindex

;; Modulator Section:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
aModulator grain kpeakdeviation*kenv1, kbasefreq1 * kModRatio, kmoddens, kmodampdev, kmodpitchdev, kmodsize, 10, 1, .5, 1


;; Carrier Section:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
aout1 grain kCarAmp, ((kbasefreq1 * kCarRatio) + aModulator) + klfo, kcardens, kcarampdev, kcarpitchdev, kcarsize, 10, 1, .5
aout2 grain kCarAmp, ((kbasefreq2 * kCarRatio) + aModulator) + klfo, kcardens, kcarampdev, kcarpitchdev, kcarsize, 10, 1, .5


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
endif

;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

iampfix = .7
outs aoutL*iampfix*kenv, aoutR*iampfix*kenv										
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
f 1 0 16384 10 1
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
  <uuid>{7242f5e3-e832-41c5-9450-acd4716eda31}</uuid>
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
