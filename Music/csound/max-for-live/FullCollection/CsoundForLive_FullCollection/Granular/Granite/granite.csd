;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Granite
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
kr		=	4410
ksmps		=	10
nchnls	=	2
0dbfs		=	1

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

turnon 2
massign 1, 3
instr 1
ktrig	metro	100
if (ktrig == 1)	then
;;ADSR:
	gkatt chnget "att"
	gkdec chnget "dec"
	gksus chnget "sus"
	gkrel chnget "rel"
;;Filter Over Time:
    	gkfqstart chnget "fqstart"
	gkfqtime chnget "fqtime"
	gkfqend chnget "fqend"
	gkq chnget "resonance"
;;Spread/Detune:
    	gkspread chnget "spread"
	gkdetune chnget "detune"
;;LFO
	gklfoamp chnget "lfoamp"
	gklforate chnget "lforate"
	gklfotype chnget "lfotype"
;;Tune/Voices:
    	gkcenttmp chnget "cents"
	gksemi chnget "semitones"
	gkvoices chnget "voices"
;;Grain Specific:
	gkgrrate chnget "gps"
	gkfrpow chnget "frpow" ; -1 to 1
	gkwave chnget "wave"
	gkwin chnget "win"
	gkgdur chnget "graindur"
	gkrandfrq chnget "randfrq"
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
;;Tuning Block:;;;;;;;;;;;;;;;;;;;;;;;;;;
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
iamp ampmidi 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
kdelfo tonek gkdelfo, 10
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10

kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)

kphs = .5
kfmd tonek gkrandfrq, 20
kfmd1 = kfmd * kfrq1
kfmd2 = kfmd * kfrq2
kgdur tonek gkgdur, 20
kdens tonek gkgrrate, 20
imaxovr = 100
kfrpow tonek gkfrpow, 20
kprpow = 0
kpmd = 0.5
kwave = gkwave + 10

kchange changed gkwin
if kchange == 1 then
reinit START
endif
START:
aout1 grain3 (kfrq1+klfo), kphs, kfmd1, kpmd, kgdur, kdens, imaxovr, kwave, i(gkwin), kfrpow, kprpow, 0, 64
aout2 grain3 (kfrq2+klfo), kphs, kfmd2, kpmd, kgdur, kdens, imaxovr, kwave, i(gkwin), kfrpow, kprpow, 0, 64 
rireturn

if gkfiltadsrbypass == 0 then
aoutA moogladder aout1, gkfco, gkq*.99
aoutB moogladder aout2, gkfco, gkq*.99
aout1 balance aoutA, aout1
aout2 balance aoutB, aout2
else
kfilt madsr i(gkfiltatt), i(gkfiltdec), i(gkfiltsus), i(gkfiltrel)
aout1 moogladder aout1, kfilt*gkfco, gkq*.99
aout2 moogladder aout2, kfilt*gkfco, gkq*.99
aout1 clip aout1, 0, 1
aout2 clip aout2, 0, 1
imoregain = 3
aout1 = aout1 * imoregain
aout2 = aout2 * imoregain
endif

;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

igainfix = .2
outs aoutL*kenv*igainfix, aoutR*kenv*igainfix
endin


</CsInstruments>
<CsScore>
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
  <uuid>{56d8bf0f-da9f-4410-bc56-b2296a6b248b}</uuid>
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
