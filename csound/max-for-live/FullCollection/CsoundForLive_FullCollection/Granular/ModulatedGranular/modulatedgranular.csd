;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	ModulatedGranular
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
kr		=	441
nchnls	=	2
0dbfs		=	1

massign 1, 2

giWin1		ftgen		1, 0, 4096, 20, 1, 1		; Hamming
giWin2		ftgen		2, 0, 4096, 20, 2, 1		; von Hann
giWin3		ftgen		3, 0, 4096, 20, 3, 1		; Triangle (Bartlett)
giWin4		ftgen		4, 0, 4096, 20, 4, 1		; Blackman (3-term)
giWin5		ftgen		5, 0, 4096, 20, 5, 1		; Blackman-Harris (4-term)
giWin6		ftgen		6, 0, 4096, 20, 6, 1		; Gauss
giWin7		ftgen		7, 0, 4096, 20, 7, 1, 6	; Kaiser
giWin8		ftgen		8, 0, 4096, 20, 8, 1		; Rectangle
giWin9		ftgen		9, 0, 4096, 20, 9, 1		; Sync
giWave1		ftgen		10,0, 16384,10, 1			; Sine
giWave2		ftgen 	11,0, 16384, 7, 1, 16384, -1 ; Sawtooth
giWave3 		ftgen		12,0, 16384, 9, 1, 3, 0, 3, 1, 0, 9, 0,.3333, 180  	;square-ish
giWave4		ftgen		13, 0, 4096, 20, 3, 1		; Triangle (Bartlett)
giWave5		ftgen		14, 0, 4096, 20, 6, 1		; Gauss

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
gkfqstart chnget "fqstart"	
gkfqtime chnget "fqtime"	
gkfqend chnget "fqend"		
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
gkmodwave chnget "modwave"	
gkmodwin chnget "modwindow"	
gkcardens chnget "cargrainrate"
gkcarampdev chnget "carampdev"	
gkcarpitchdev chnget "carpitchdev"	
gkcarsize chnget "carsize"	
gkcarwave chnget "carwave"	
gkcarwin chnget "carwindow"	
gkdelfo chnget "lfodelay"
gkporttime chnget "glide"
endif
endin


instr	2
;;Tuning Block:
    
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
gkfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
gkfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
giamp ampmidi 1

schedkwhen      1,           0,       1,       3,      0,   3600
endin


instr	3
gkenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)

kporttime linseg	0, (.01), 1, (1), 1
kporttime	= kporttime * gkporttime

kbasefreq1	portk	gkfrq1, kporttime
kbasefreq2	portk	gkfrq2, kporttime
kdelfo tonek gkdelfo, 10
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10	
	
;;Monophonic Part:
kreltrig	release
gkinstrcount 	active 2
if		gkinstrcount!=0||kreltrig=1	kgoto	GO
turnoff
GO:
krel1 = gkrel1 + 0.0001
kenv1 adsr i(gkatt1), i(gkdec1), i(gksus1), i(krel1)
kdelfo adsr i(gkdelfo),.001,1,1
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)
kfilt expseg i(gkfqstart), i(gkfqtime), i(gkfqend), 6000, i(gkfqend)    

kmoddens tonek gkmoddens, 10
kmodampdev tonek gkmodampdev, 10
kmodpitchdev tonek gkmodpitchdev, 10
kmodsize tonek gkmodsize, 10
kcardens tonek gkcardens, 10
kcarampdev tonek gkcarampdev, 10
kcarpitchdev tonek gkcarpitchdev, 10
kcarsize tonek gkcarsize, 10
kindex tonek gkindex, 10

kpeakdeviation = kbasefreq1 * kindex

kenv1 = giamp*kenv1

;; Modulator Section:
;; (extended workaround due to i(k) erroring
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if (gkmodwin == 0 && gkmodwave == 0) then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 1, .5, 1
elseif (gkmodwin == 1 && gkmodwave == 0)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 2, .5, 1
elseif (gkmodwin == 2 && gkmodwave == 0)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 3, .5, 1
elseif (gkmodwin == 3 && gkmodwave == 0)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 4, .5, 1
elseif (gkmodwin == 4 && gkmodwave == 0)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 5, .5, 1
elseif (gkmodwin == 5 && gkmodwave == 0)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 6, .5, 1
elseif (gkmodwin == 6 && gkmodwave == 0)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 7, .5, 1
elseif (gkmodwin == 7 && gkmodwave == 0)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 8, .5, 1
elseif (gkmodwin == 8 && gkmodwave == 0)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 9, .5, 1
elseif (gkmodwin == 9 && gkmodwave == 0)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 10, 10, .5, 1

elseif (gkmodwin == 0 && gkmodwave == 1) then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 1, .5, 1
elseif (gkmodwin == 1 && gkmodwave == 1)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 2, .5, 1
elseif (gkmodwin == 2 && gkmodwave == 1)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 3, .5, 1
elseif (gkmodwin == 3 && gkmodwave == 1)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 4, .5, 1
elseif (gkmodwin == 4 && gkmodwave == 1)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 5, .5, 1
elseif (gkmodwin == 5 && gkmodwave == 1)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 6, .5, 1
elseif (gkmodwin == 6 && gkmodwave == 1)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 7, .5, 1
elseif (gkmodwin == 7 && gkmodwave == 1)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 8, .5, 1
elseif (gkmodwin == 8 && gkmodwave == 1)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 9, .5, 1
elseif (gkmodwin == 9 && gkmodwave == 1)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 11, 10, .5, 1

elseif (gkmodwin == 0 && gkmodwave == 2) then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 1, .5, 1
elseif (gkmodwin == 1 && gkmodwave == 2)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 2, .5, 1
elseif (gkmodwin == 2 && gkmodwave == 2)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 3, .5, 1
elseif (gkmodwin == 3 && gkmodwave == 2)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 4, .5, 1
elseif (gkmodwin == 4 && gkmodwave == 2)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 5, .5, 1
elseif (gkmodwin == 5 && gkmodwave == 2)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 6, .5, 1
elseif (gkmodwin == 6 && gkmodwave == 2)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 7, .5, 1
elseif (gkmodwin == 7 && gkmodwave == 2)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 8, .5, 1
elseif (gkmodwin == 8 && gkmodwave == 2)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 9, .5, 1
elseif (gkmodwin == 9 && gkmodwave == 2)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 12, 10, .5, 1
	
elseif (gkmodwin == 0 && gkmodwave == 3) then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 1, .5, 1
elseif (gkmodwin == 1 && gkmodwave == 3)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 2, .5, 1
elseif (gkmodwin == 2 && gkmodwave == 3)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 3, .5, 1
elseif (gkmodwin == 3 && gkmodwave == 3)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 4, .5, 1
elseif (gkmodwin == 4 && gkmodwave == 3)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 5, .5, 1
elseif (gkmodwin == 5 && gkmodwave == 3)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 6, .5, 1
elseif (gkmodwin == 6 && gkmodwave == 3)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 7, .5, 1
elseif (gkmodwin == 7 && gkmodwave == 3)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 8, .5, 1
elseif (gkmodwin == 8 && gkmodwave == 3)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 9, .5, 1
elseif (gkmodwin == 9 && gkmodwave == 3)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 13, 10, .5, 1
	
elseif (gkmodwin == 0 && gkmodwave == 4) then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 1, .5, 1
elseif (gkmodwin == 1 && gkmodwave == 4)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 2, .5, 1
elseif (gkmodwin == 2 && gkmodwave == 4)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 3, .5, 1
elseif (gkmodwin == 3 && gkmodwave == 4)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 4, .5, 1
elseif (gkmodwin == 4 && gkmodwave == 4)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 5, .5, 1
elseif (gkmodwin == 5 && gkmodwave == 4)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 6, .5, 1
elseif (gkmodwin == 6 && gkmodwave == 4)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 7, .5, 1
elseif (gkmodwin == 7 && gkmodwave == 4)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 8, .5, 1
elseif (gkmodwin == 8 && gkmodwave == 4)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 9, .5, 1
elseif (gkmodwin == 9 && gkmodwave == 4)  then
	aModulator grain kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, kmoddens, kmodampdev, 				kmodpitchdev, kmodsize, 14, 10, .5, 1
endif


;; Carrier Section:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if (gkcarwave == 0 && gkcarwin == 0) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 1, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 1, .5
elseif (gkcarwave == 1 && gkcarwin == 0) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 1, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 1, .5
elseif (gkcarwave == 2 && gkcarwin == 0) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 1, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 1, .5
elseif (gkcarwave == 3 && gkcarwin == 0) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 1, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 1, .5
elseif (gkcarwave == 4 && gkcarwin == 0) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 1, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 1, .5
elseif (gkcarwave == 0 && gkcarwin == 1) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 2, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 2, .5
elseif (gkcarwave == 1 && gkcarwin == 1) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 2, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 2, .5
elseif (gkcarwave == 2 && gkcarwin == 1) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 2, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 2, .5
elseif (gkcarwave == 3 && gkcarwin == 1) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 2, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 2, .5
elseif (gkcarwave == 4 && gkcarwin == 1) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 2, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 2, .5

elseif (gkcarwave == 0 && gkcarwin == 2) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 3, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 3, .5
elseif (gkcarwave == 1 && gkcarwin == 2) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 3, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 3, .5
elseif (gkcarwave == 2 && gkcarwin == 2) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 3, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 3, .5
elseif (gkcarwave == 3 && gkcarwin == 2) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 3, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 3, .5
elseif (gkcarwave == 4 && gkcarwin == 2) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 3, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 3, .5

elseif (gkcarwave == 0 && gkcarwin == 3) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 4, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 4, .5
elseif (gkcarwave == 1 && gkcarwin == 3) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 4, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 4, .5
elseif (gkcarwave == 2 && gkcarwin == 3) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 4, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 4, .5
elseif (gkcarwave == 3 && gkcarwin == 3) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 4, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 4, .5
elseif (gkcarwave == 4 && gkcarwin == 3) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 4, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 4, .5
	
elseif (gkcarwave == 0 && gkcarwin == 4) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 5, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 5, .5
elseif (gkcarwave == 1 && gkcarwin == 4) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 5, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 5, .5
elseif (gkcarwave == 2 && gkcarwin == 4) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 5, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 5, .5
elseif (gkcarwave == 3 && gkcarwin == 4) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 5, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 5, .5
elseif (gkcarwave == 4 && gkcarwin == 4) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 5, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 5, .5
	
elseif (gkcarwave == 0 && gkcarwin == 5) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 6, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 6, .5
elseif (gkcarwave == 1 && gkcarwin == 5) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 6, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 6, .5
elseif (gkcarwave == 2 && gkcarwin == 5) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 6, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 6, .5
elseif (gkcarwave == 3 && gkcarwin == 5) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 6, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 6, .5
elseif (gkcarwave == 4 && gkcarwin == 5) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 6, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 6, .5

elseif (gkcarwave == 0 && gkcarwin == 6) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 7, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 7, .5
elseif (gkcarwave == 1 && gkcarwin == 6) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 7, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 7, .5
elseif (gkcarwave == 2 && gkcarwin == 6) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 7, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 7, .5
elseif (gkcarwave == 3 && gkcarwin == 6) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 7, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 7, .5
elseif (gkcarwave == 4 && gkcarwin == 6) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 7, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 7, .5

elseif (gkcarwave == 0 && gkcarwin == 7) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 8, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 8, .5
elseif (gkcarwave == 1 && gkcarwin == 7) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 8, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 8, .5
elseif (gkcarwave == 2 && gkcarwin == 7) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 8, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 8, .5
elseif (gkcarwave == 3 && gkcarwin == 7) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 8, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 8, .5
elseif (gkcarwave == 4 && gkcarwin == 7) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 8, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 8, .5
	
elseif (gkcarwave == 0 && gkcarwin == 8) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 9, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 9, .5
elseif (gkcarwave == 1 && gkcarwin == 8) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 9, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 11, 9, .5
elseif (gkcarwave == 2 && gkcarwin == 8) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 9, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 12, 9, .5
elseif (gkcarwave == 3 && gkcarwin == 8) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 9, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 10, 9, .5
elseif (gkcarwave == 4 && gkcarwin == 8) then
	aCarrier1 grain gkCarAmp, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 9, .5
	aCarrier2 grain gkCarAmp, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, kcardens, 				kcarampdev, kcarpitchdev, kcarsize, 14, 9, .5
endif

aoutA moogladder aCarrier1*gkenv, kfilt, gkq
aoutB moogladder aCarrier2*gkenv, kfilt, gkq

aout1 balance aoutA, aCarrier1*gkenv
aout2 balance aoutB, aCarrier2*gkenv

;;Spread Section:
kspread tonek gkspread, 10    
aoutL = ((aout1 * kspread) + (aout2 * (1 - kspread))) *.5  
aoutR = ((aout1 * (1-kspread)) + (aout2 * kspread))   *.5

iampfix = .4
outs aoutL*iampfix, aoutR*iampfix								
endin


</CsInstruments>
<CsScore>
f 1 0 4096 10 1
i1 0 60000

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
