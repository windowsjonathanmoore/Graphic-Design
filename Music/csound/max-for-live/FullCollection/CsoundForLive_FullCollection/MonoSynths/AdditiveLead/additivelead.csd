;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Additive 30 Lead
;;		based on the QuteCsound Example:		
;;		"Harmonic Additive Synthesis 1"
;;		by Iain McCurdy
;;	
;;	Adaptation for CsoundForLive by Colman O'Reilly
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
0dbfs 	= 	1

massign 1, 2

instr	1
gisine		ftgen	0, 0, 4096, 10, 1				;A SINE WAVE

ktrig	metro	100
if (ktrig == 1)	then
gkampatt	chnget	"attack"
gkampattlev	chnget	"attlev"
gkampdec	chnget	"decay1"
gkampdeclev	chnget	"declev"
gkampdec2	chnget	"decay2"
gkampslev	chnget	"sustain"
gkamprel	chnget	"release"
gkmoddel	chnget	"deltime"
gkmodrise	chnget	"risetime"
gkPartAmp1	chnget 	"partamp1"
gkPartAmp2	chnget 	"partamp2"
gkPartAmp3	chnget 	"partamp3"
gkPartAmp4	chnget 	"partamp4"
gkPartAmp5	chnget 	"partamp5"
gkPartAmp6	chnget 	"partamp6"
gkPartAmp7	chnget 	"partamp7"
gkPartAmp8	chnget 	"partamp8"
gkPartAmp9	chnget 	"partamp9"
gkPartAmp10	chnget 	"partamp10"
gkPartAmp11	chnget 	"partamp11"
gkPartAmp12	chnget 	"partamp12"
gkPartAmp13	chnget 	"partamp13"
gkPartAmp14	chnget 	"partamp14"
gkPartAmp15	chnget 	"partamp15"
gkPartAmp16	chnget 	"partamp16"
gkPartAmp17	chnget 	"partamp17"
gkPartAmp18	chnget 	"partamp18"
gkPartAmp19	chnget 	"partamp19"
gkPartAmp20	chnget 	"partamp20"
gkPartAmp21	chnget 	"partamp21"
gkPartAmp22	chnget 	"partamp22"
gkPartAmp23	chnget 	"partamp23"
gkPartAmp24	chnget 	"partamp24"
gkPartAmp25	chnget 	"partamp25"
gkPartAmp26	chnget 	"partamp26"
gkPartAmp27	chnget 	"partamp27"
gkPartAmp28	chnget 	"partamp28"
gkPartAmp29	chnget 	"partamp29"
gkPartAmp30	chnget 	"partamp30"
gkmodrate	chnget	"modrate"
gkvibdep	chnget	"vibdep"
gktremdep	chnget	"tremdep"
gkfqstart 	chnget "fqstart"
gkfqtime 	chnget "fqtime"
gkfqend 	chnget "fqend"
gklfotype 	chnget "lfotype"
gkspread 	chnget "spread"
gkdetune 	chnget "detune"
gklfoamp 	chnget "lfoamp"
gklforate 	chnget "lforate"
gkq 		chnget "resonance"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkatt 	chnget "att"
gkdec 	chnget "dec"
gksus 	chnget "sus"
gkrel 	chnget "rel"

gkporttime chnget "glide"
endif
endin


instr	2
;;Tuning Block:
    
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
gkfund1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
gkfund2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
giamp ampmidi 1
gkenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
schedkwhen      1,           0,       1,       3,      0,   3600
endin

instr 3
kporttime linseg	0, (.01), 1, (1), 1
kporttime	= kporttime * gkporttime
kfrq1	portk	gkfund1, kporttime
kfrq2	portk	gkfund2, kporttime

;;Monophonic Part:
kreltrig	release
gkinstrcount 	active 2
if		gkinstrcount!=0||kreltrig=1	kgoto	GO
turnoff
GO:
kPartAmp1	= 	gkPartAmp1
kPartAmp2	= 	gkPartAmp2
kPartAmp3	= 	gkPartAmp3
kPartAmp4	= 	gkPartAmp4
kPartAmp5	= 	gkPartAmp5
kPartAmp6	= 	gkPartAmp6
kPartAmp7	= 	gkPartAmp7
kPartAmp8	= 	gkPartAmp8
kPartAmp9	= 	gkPartAmp9
kPartAmp10	= 	gkPartAmp10
kPartAmp11	= 	gkPartAmp11
kPartAmp12	= 	gkPartAmp12
kPartAmp13	= 	gkPartAmp13
kPartAmp14	= 	gkPartAmp14
kPartAmp15	= 	gkPartAmp15
kPartAmp16	= 	gkPartAmp16
kPartAmp17	= 	gkPartAmp17
kPartAmp18	= 	gkPartAmp18
kPartAmp19	= 	gkPartAmp19
kPartAmp20	= 	gkPartAmp20
kPartAmp21	= 	gkPartAmp21
kPartAmp22	= 	gkPartAmp22
kPartAmp23	= 	gkPartAmp23
kPartAmp24	= 	gkPartAmp24
kPartAmp25	= 	gkPartAmp25
kPartAmp26	= 	gkPartAmp26
kPartAmp27	= 	gkPartAmp27
kPartAmp28	= 	gkPartAmp28
kPartAmp29	= 	gkPartAmp29
kPartAmp30	= 	gkPartAmp30

igainscale = 1

kmodrate	= gkmodrate
kvibdep	= gkvibdep
ktremdep	= gktremdep

klfo lfo gklfoamp, gklforate, i(gklfotype)
kfilt expseg i(gkfqstart), i(gkfqtime), i(gkfqend), 6000, i(gkfqend)
	
kTremPhase	= .5
kmodenv	linseg	0, i(gkmoddel), 0, i(gkmodrise), 1, 1, 1
kvib		oscili	kvibdep*kmodenv, kmodrate, gisine	
kvib		= kvib + 1							
ktrem		oscili	ktremdep*kmodenv, kmodrate, gisine, i(kTremPhase)
ktrem		= 1-(ktrem+ktremdep)		
kfund1	= kfrq1*kvib
kfund2	= kfrq2*kvib											
kamp		= giamp*ktrem*gkenv	
	
apart1		oscili	kamp*kPartAmp1,  kfund1+klfo, 		 gisine , -1
apart2		oscili	kamp*kPartAmp2,  kfund1+(kfund1)+klfo, 	 gisine, -1
apart3		oscili	kamp*kPartAmp3,  kfund1+(kfund1*2)+klfo,  gisine, -1
apart4		oscili	kamp*kPartAmp4,  kfund1+(kfund1*3)+klfo,  gisine, -1
apart5		oscili	kamp*kPartAmp5,  kfund1+(kfund1*4)+klfo,  gisine, -1
apart6		oscili	kamp*kPartAmp6,  kfund1+(kfund1*5)+klfo,  gisine, -1
apart7		oscili	kamp*kPartAmp7,  kfund1+(kfund1*6)+klfo,  gisine, -1
apart8		oscili	kamp*kPartAmp8,  kfund1+(kfund1*7)+klfo,  gisine, -1
apart9		oscili	kamp*kPartAmp9,  kfund1+(kfund1*8)+klfo,  gisine, -1
apart10      	oscili	kamp*kPartAmp10, kfund1+(kfund1*9)+klfo,  gisine, -1
apart11      	oscili	kamp*kPartAmp11, kfund1+(kfund1*10)+klfo, gisine, -1
apart12      	oscili	kamp*kPartAmp12, kfund1+(kfund1*11)+klfo, gisine, -1
apart13      	oscili	kamp*kPartAmp13, kfund1+(kfund1*12)+klfo, gisine, -1
apart14      	oscili	kamp*kPartAmp14, kfund1+(kfund1*13)+klfo, gisine, -1
apart15      	oscili	kamp*kPartAmp15, kfund1+(kfund1*14)+klfo, gisine, -1
apart16      	oscili	kamp*kPartAmp16, kfund2+(kfund2*15)+klfo, gisine, -1
apart17      	oscili	kamp*kPartAmp17, kfund2+(kfund2*16)+klfo, gisine, -1
apart18      	oscili	kamp*kPartAmp18, kfund2+(kfund2*17)+klfo, gisine, -1
apart19      	oscili	kamp*kPartAmp19, kfund2+(kfund2*18)+klfo, gisine, -1
apart20      	oscili	kamp*kPartAmp20, kfund2+(kfund2*19)+klfo, gisine, -1
apart21      	oscili	kamp*kPartAmp21, kfund2+(kfund2*20)+klfo, gisine, -1
apart22      	oscili	kamp*kPartAmp22, kfund2+(kfund2*21)+klfo, gisine, -1
apart23      	oscili	kamp*kPartAmp23, kfund2+(kfund2*22)+klfo, gisine, -1
apart24      	oscili	kamp*kPartAmp24, kfund2+(kfund2*23)+klfo, gisine, -1
apart25      	oscili	kamp*kPartAmp25, kfund2+(kfund2*24)+klfo, gisine, -1
apart26      	oscili	kamp*kPartAmp26, kfund2+(kfund2*25)+klfo, gisine, -1
apart27      	oscili	kamp*kPartAmp27, kfund2+(kfund2*26)+klfo, gisine, -1
apart28      	oscili	kamp*kPartAmp28, kfund2+(kfund2*27)+klfo, gisine, -1
apart29      	oscili	kamp*kPartAmp29, kfund2+(kfund2*28)+klfo, gisine, -1
apart30      	oscili	kamp*kPartAmp30, kfund2+(kfund2*29)+klfo, gisine, -1

aout1	=	apart1 + apart2 + apart3 + apart4 + apart5 + apart6 + apart7 + apart8 + apart9 + apart10 + apart11 + apart12 + apart13 + apart14 + apart15
aout2 =	apart16 + apart17 + apart18 + apart19 + apart20 + apart21 + apart22 + apart23 + apart24 + apart25 + apart26 + apart27 + apart28 + apart29 + apart30

aoutA moogladder aout1, kfilt, gkq
aoutB moogladder aout2, kfilt, gkq

aout1 balance aoutA, aout1
aout2 balance aoutB, aout2

;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

outs	aoutL * igainscale, aoutR * igainscale
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
  <uuid>{c61d56cf-b7a7-4fc2-a5a0-20ced730cb1e}</uuid>
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
