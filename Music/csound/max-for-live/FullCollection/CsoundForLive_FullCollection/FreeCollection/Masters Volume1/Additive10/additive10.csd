;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Additive 10
;;		based on the QuteCsound Example:		
;;		"Harmonic Additive Synthesis 1"
;;		by Iain McCurdy
;;	
;;	Expanded for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
-old parser
</CsOptions>
<CsInstruments>
sr		=	44100
ksmps		=	16
nchnls	=	2
0dbfs 	= 	1

gisine	ftgen	0, 0, 4096, 10, 1				;Sine Wave
turnon 22
turnon 10
instr	2
irnd1	gauss 1	
irnd2	gauss 1
irnd3	gauss 1
irnd4	gauss 1
irnd5	gauss 1
irnd6	gauss 1
irnd7	gauss 1
irnd8	gauss 1
irnd9	gauss 1
irnd10 gauss 1	

krnd chnget "rnd"	

gkrnd1	=	1+(irnd1*krnd) 
gkrnd2	=	1+(irnd2*krnd) 
gkrnd3	=	1+(irnd3*krnd) 
gkrnd4	=	1+(irnd4*krnd) 
gkrnd5	=	1+(irnd5*krnd) 
gkrnd6	=	1+(irnd6*krnd) 
gkrnd7	=	1+(irnd7*krnd) 
gkrnd8	=	1+(irnd8*krnd) 
gkrnd9	=	1+(irnd9*krnd) 
gkrnd10	=	1+(irnd10*krnd) 
endin

instr 10
ktrig	metro	100
if (ktrig == 1)	then

gkatt 	chnget "att"
gkdec 	chnget "dec"
gksus 	chnget "sus"
gkrel 	chnget "rel"
gklfotype 	chnget "lfotype"
gkspread 	chnget "spread"
gkdetune 	chnget "detune"
gklfoamp 	chnget "lfoamp"
gklforate 	chnget "lforate"
gkq 		chnget "resonance"
gkPartAmp1	chnget "partamp1"			;all 0-1
gkPartAmp2	chnget "partamp2"
gkPartAmp3	chnget "partamp3"
gkPartAmp4	chnget "partamp4"
gkPartAmp5	chnget "partamp5"
gkPartAmp6	chnget "partamp6"
gkPartAmp7	chnget "partamp7"
gkPartAmp8	chnget "partamp8"
gkPartAmp9	chnget "partamp9"
gkPartAmp10	chnget "partamp10"
gkwarp	chnget "warp"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkcut chnget "kcut"
gkharm chnget "kharm"
gkvoices chnget "voices"
gkdelfo chnget "lfodelay"
gkfco chnget "fco"
gkfiltatt chnget "filtatt"
gkfiltdec chnget "filtdec"
gkfiltsus chnget "filtsus"
gkfiltrel chnget "filtrel"
gkfiltadsrbypass chnget "filtadsrbypass"
endif
endin

instr	1
kcut tonek gkcut, 10
kharm tonek gkharm, 10
kspread tonek gkspread, 10
kdetune tonek gkdetune, 10
kq tonek gkq, 10

;;Tuning Block:;;;;;;;;;;;;;;;;;;;;;;;;;;
gkbend pchbend 0, 2
kcenttmp = gkcenttmp
ksemi = gksemi
imidinn notnum
kcent = kcenttmp * 0.01
kfrq1 = cpsmidinn(imidinn + ksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + ksemi + kcent + kdetune + gkbend)
iamp ampmidi 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

igainscale = .5

kPartAmp1	= gkPartAmp1
kPartAmp2	= gkPartAmp2
kPartAmp3	= gkPartAmp3
kPartAmp4	= gkPartAmp4
kPartAmp5	= gkPartAmp5
kPartAmp6	= gkPartAmp6
kPartAmp7	= gkPartAmp7
kPartAmp8	= gkPartAmp8
kPartAmp9	= gkPartAmp9
kPartAmp10	= gkPartAmp10
kwarp	= gkwarp	;0-2

klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay

kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)


apart1	oscili	iamp*kPartAmp1*kenv,  (kfrq1 * gkrnd1)+klfo, gisine	
apart2	oscili	iamp*kPartAmp2*kenv,  ((kfrq1+(kfrq1*kwarp))   * gkrnd2)+klfo,	gisine
apart3	oscili	iamp*kPartAmp3*kenv,  ((kfrq1+(kfrq1*2*kwarp)) * gkrnd3)+klfo,	gisine
apart4	oscili	iamp*kPartAmp4*kenv,  ((kfrq1+(kfrq1*3*kwarp)) * gkrnd4)+klfo,	gisine 
apart5	oscili	iamp*kPartAmp5*kenv,  ((kfrq1+(kfrq1*4*kwarp)) * gkrnd5)+klfo,	gisine
apart6	oscili	iamp*kPartAmp6*kenv,  ((kfrq2+(kfrq2*5*kwarp)) * gkrnd6)+klfo,	gisine
apart7	oscili	iamp*kPartAmp7*kenv,  ((kfrq2+(kfrq2*6*kwarp)) * gkrnd7)+klfo, gisine
apart8	oscili	iamp*kPartAmp8*kenv,  ((kfrq2+(kfrq2*7*kwarp)) * gkrnd8)+klfo,	gisine 
apart9	oscili	iamp*kPartAmp9*kenv,  ((kfrq2+(kfrq2*8*kwarp)) * gkrnd9)+klfo, gisine 
apart10   	oscili	iamp*kPartAmp10*kenv, ((kfrq2+(kfrq2*9*kwarp)) * gkrnd10)+klfo,gisine 
	
aout1 =	apart1 + apart2 + apart3 + apart4 + apart5
aout2 = 	apart6 + apart7 + apart8 + apart9 + apart10
		
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

outs	aoutL*igainscale, aoutR*igainscale
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
i2 0 60000	
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
  <uuid>{51f65fb2-83ae-4e0d-9c9e-58c20d6680e6}</uuid>
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
