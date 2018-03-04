;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Modal
;;	by Iain McCurdy
;;
;;	Adapted for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
-old parser
</CsOptions>
<CsInstruments>
sr		=	44100
ksmps		=	256
nchnls	=	2
0dbfs		=	1


massign 1, 3
			zakinit	3,3	


gkQ			init		0.0

turnon 99
turnon 22
gisine		ftgen	0,0,131072,10,1


girtos1		ftgen	0,0,2, -2,	1,	1
girtos2		ftgen	0,0,-6,-2,	1,	2.89,	4.95,	6.99,	8.01,	9.02
girtos3		ftgen	0,0,-6,-2,	1, 	2.0, 	3.01, 	4.01, 	4.69, 	5.63
girtos4		ftgen	0,0,-6,-2,	1, 	3.932, 	9.538,	16.688,	24.566,	31.147
girtos5		ftgen	0,0,-7,-2,	1, 	2.77828,	5.18099, 	8.16289,	11.66063,	15.63801,	19.99
girtos6		ftgen	0,0,-24,-2,	1,	1.026513174725,	1.4224916858532,	1.4478690202098,	1.4661959580455,	1.499452545408,	1.7891839345101,	1.8768994627782,	1.9645945254541,	1.9786543873113,	2.0334612432847,	2.1452852391916,	2.1561524686621,	2.2533435661294,	2.2905090816065,	2.3331798413917,	2.4567715528268,	2.4925556408289,	2.5661806088514,	2.6055768738808,	2.6692760296751,	2.7140956766436,	2.7543617293425,	2.7710411870043 
girtos7		ftgen	0,0,-6,-2,	1, 	3.2, 	6.23, 	6.27, 	9.92, 	14.15
girtos8		ftgen	0,0,-4,-2,	1, 	1.47, 	2.09, 	2.56
girtos9		ftgen	0,0,-10,-2,	272/437,	538/437,	874/437,	1281/437,	1755/437,	2264/437,	2813/437,	3389/437,	4822/437,	5255/437
girtos10		ftgen	0,0,-4,-2,	1, 1.47, 2.11, 2.57
girtos11		ftgen	0,0,-4,-2,	1, 1.42, 2.11, 2.47
girtos12		ftgen	0,0,-6,-2,	1, 2.572, 4.644, 6.984, 9.723, 12
girtos13		ftgen	0,0,-6,-2,	1, 2.756, 5.423, 8.988, 13.448, 18.680
girtos14		ftgen	0,0,-6,-2,	1, 3.984, 10.668, 17.979, 23.679, 33.642
girtos15		ftgen	0,0,-6,-2,	1, 3.997, 9.469, 15.566, 20.863, 29.440
girtos16		ftgen	0,0,-5,-2,	1, 1.72581, 5.80645, 7.41935, 13.91935
girtos17		ftgen	0,0,-7,-2,	1, 2.66242, 4.83757, 7.51592, 10.64012, 14.21019, 18.14027
girtos18		ftgen	0,0,-5,-2,	1, 2.76515, 5.12121, 7.80681, 10.78409
girtos19		ftgen	0,0,-5,-2,	1, 2.32, 4.25, 6.63, 9.38
girtos20		ftgen	0,0,-22,-2,	1, 1.0019054878049, 1.7936737804878, 1.8009908536585, 2.5201981707317, 2.5224085365854, 2.9907012195122, 2.9940548780488, 3.7855182926829, 3.8061737804878, 4.5689024390244, 4.5754573170732, 5.0296493902439, 5.0455030487805, 6.0759908536585, 5.9094512195122, 6.4124237804878, 6.4430640243902, 7.0826219512195, 7.0923780487805, 7.3188262195122, 7.5551829268293 
girtos21		ftgen	0,0,-24,-2,	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
giQs			ftgen	0,0,-24,-2,	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
giAmps		ftgen	0,0,-24,-2,	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1


opcode	modemodule, 0, akiii	
	ain, kbase, icount, ialgfn, imodes  xin	
	krto		table	icount-1, ialgfn					
	kfrq	=		krto * kbase						

	if	kfrq > 14000 || krto = 0	goto	SKIP						
		kQ		table	icount-1, giQs
		kAmp		table	icount-1, giAmps
		a1		mode		ain, kfrq, gkQ*kQ				
				zawm		a1*kAmp, 0						
		icount	=	icount + 1							
		if	icount <= imodes	then							
			modemodule	ain, kbase, icount, ialgfn, imodes		
		endif											
	SKIP:												
endop											

opcode	modemodulei, 0, akiii	
	ain, kbase, icount, ialgfn, imodes  xin						
	irto		table	icount-1, ialgfn						
	kfrq		=		irto * kbase							

	if	kfrq > 14000	goto	SKIP							
		kQ		table	icount-1, giQs
		kAmp		table	icount-1, giAmps
		a1		mode		ain, kfrq, gkQ*kQ		
				zawm		a1*kAmp, 0						
		icount	=	icount + 1							
		if	icount <= imodes	then							
			modemodulei	ain, kbase, icount, ialgfn, imodes		
		endif											
	SKIP:												
endop



instr	1	
	ktrig	metro	100
	if (ktrig == 1)	then
		gkinput	= 0
		
		gkmodes	chnget	"Modes"


gksound	chnget	"Sound"

gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gkcenttmp chnget "cents"
gksemi chnget "semitones"

gkfqstart chnget "fqstart"
gkfqtime chnget "fqtime"
gkfqend chnget "fqend"
gklfotype chnget "lfotype"

gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"
gkvoices chnget "voices"
gkdelfo chnget "lfodelay"


		gkrto1	chnget	"Ratio01"
		gkrto2	chnget	"Ratio02"
		gkrto3	chnget	"Ratio03"
		gkrto4	chnget	"Ratio04"
		gkrto5	chnget	"Ratio05"
		gkrto6	chnget	"Ratio06"
		gkrto7	chnget	"Ratio07"
		gkrto8	chnget	"Ratio08"
		gkrto9	chnget	"Ratio09"
		gkrto10	chnget	"Ratio10"
		gkrto11	chnget	"Ratio11"
		gkrto12	chnget	"Ratio12"
		gkrto13	chnget	"Ratio13"
		gkrto14	chnget	"Ratio14"
		gkrto15	chnget	"Ratio15"
		gkrto16	chnget	"Ratio16"
		gkrto17	chnget	"Ratio17"
		gkrto18	chnget	"Ratio18"
		gkrto19	chnget	"Ratio19"
		gkrto20	chnget	"Ratio20"
		gkrto21	chnget	"Ratio21"
		gkrto22	chnget	"Ratio22"
		gkrto23	chnget	"Ratio23"
		gkrto24	chnget	"Ratio24"

		gkrto1	=	gkrto1 * 0.01
		gkrto2	=	gkrto2 * 0.01
		gkrto3	=	gkrto3 * 0.01
		gkrto4	=	gkrto4 * 0.01
		gkrto5	=	gkrto5 * 0.01
		gkrto6	=	gkrto6 * 0.01
		gkrto7	=	gkrto7 * 0.01
		gkrto8	=	gkrto8 * 0.01
		gkrto9	=	gkrto9 * 0.01
		gkrto10	=	gkrto10 * 0.01
		gkrto11	=	gkrto11 * 0.01
		gkrto12	=	gkrto12 * 0.01
		gkrto13	=	gkrto13 * 0.01
		gkrto14	=	gkrto14 * 0.01
		gkrto15	=	gkrto15 * 0.01
		gkrto16	=	gkrto16 * 0.01
		gkrto17	=	gkrto17 * 0.01
		gkrto18	=	gkrto18 * 0.01
		gkrto19	=	gkrto19 * 0.01
		gkrto20	=	gkrto20 * 0.01
		gkrto21	=	gkrto21 * 0.01
		gkrto22	=	gkrto22 * 0.01
		gkrto23	=	gkrto23 * 0.01
		gkrto24	=	gkrto24 * 0.01


kbase	= 440 
gkbase tonek kbase, 20
		kQ		chnget	"Q"
			gkQ tonek kQ, 20
		
			gkdensity = 10

		gkOutGain	= .7

		;Q sliders
		gkQ1		chnget	"q1"
		gkQ2		chnget	"q2"
		gkQ3		chnget	"q3"
		gkQ4		chnget	"q4"
		gkQ5		chnget	"q5"
		gkQ6		chnget	"q6"
		gkQ7		chnget	"q7"
		gkQ8		chnget	"q8"
		gkQ9		chnget	"q9"
		gkQ10		chnget	"q10"
		gkQ11		chnget	"q11"
		gkQ12		chnget	"q12"
		gkQ13		chnget	"q13"
		gkQ14		chnget	"q14"
		gkQ15		chnget	"q15"
		gkQ16		chnget	"q16"
		gkQ17		chnget	"q17"
		gkQ18		chnget	"q18"
		gkQ19		chnget	"q19"
		gkQ20		chnget	"q20"
		gkQ21		chnget	"q21"
		gkQ22		chnget	"q22"
		gkQ23		chnget	"q23" 
		gkQ24		chnget	"q24"

		;Amp sliders
		gkAmp1	chnget	"amp1"
		gkAmp2	chnget	"amp2"
		gkAmp3	chnget	"amp3"
		gkAmp4	chnget	"amp4"
		gkAmp5	chnget	"amp5"
		gkAmp6	chnget	"amp6"
		gkAmp7	chnget	"amp7"
		gkAmp8	chnget	"amp8"
		gkAmp9	chnget	"amp9"
		gkAmp10	chnget	"amp10"
		gkAmp11	chnget	"amp11"
		gkAmp12	chnget	"amp12"
		gkAmp13	chnget	"amp13"
		gkAmp14	chnget	"amp14"
		gkAmp15	chnget	"amp15"
		gkAmp16	chnget	"amp16"
		gkAmp17	chnget	"amp17"
		gkAmp18	chnget	"amp18"
		gkAmp19	chnget	"amp19"
		gkAmp20	chnget	"amp20"
		gkAmp21	chnget	"amp21"
		gkAmp22	chnget	"amp22"
		gkAmp23	chnget	"amp23"
		gkAmp24	chnget	"amp24"

		ktrig1	changed	gksound	
		if	ktrig1=1	then
			reinit	RESTART
		endif
		RESTART:
		if		i(gksound)==0	then	
			iBase	=	0.5077195	
			iQ		=	0.6666600	
		elseif	i(gksound)==1	then	
			iBase	=	0.3648900	
			iQ		=	0.2329580	
		elseif	i(gksound)==2	then		
			iBase	=	0.5183400
			iQ		=	0.5491000	
		elseif	i(gksound)==3	then		
			iBase	=	0.3765900	
			iQ		=	0.4336500	
		elseif	i(gksound)==4	then		
			iBase	=	0.4350800
			iQ		=	0.7808000	
		elseif	i(gksound)==5	then		
			iBase	=	0.7079800	
			iQ		=	0.3010000	
		elseif	i(gksound)==6	then		
			iBase	=	0.4574400	
			iQ		=	0.7254200	
		elseif	i(gksound)==7	then		
			iBase	=	0.6439000
			iQ		=	0.3333200	
		elseif	i(gksound)==8	then		
			iBase	=	0.5585450	
			iQ		=	0.7669800	
		elseif	i(gksound)==9	then		
			iBase	=	0.7084800	
			iQ		=	0.3333200	
		elseif	i(gksound)==10	then		
			iBase	=	0.7415300	
			iQ		=	0.3920000	
		elseif	i(gksound)==11	then		
			iBase	=	0.6439000	
			iQ		=	0.4923900	
		elseif	i(gksound)==12	then		
			iBase	=	0.5060400	
			iQ		=	0.6666600	
		elseif	i(gksound)==13	then
			iBase	=	0.5598000	
			iQ		=	0.7669800	
		elseif	i(gksound)==14	then		
			iBase	=	0.5598000	
			iQ		=	0.7669800	
		elseif	i(gksound)==15	then		
			iBase	=	0.2049000	
			iQ		=	0.5662750	
		elseif	i(gksound)==16	then		
			iBase	=	0.4987000	
			iQ		=	0.7808000	
		elseif	i(gksound)==17	then		
			iBase	=	0.5928300	
			iQ		=	0.7808000	
		elseif	i(gksound)==18	then		
			iBase	=	0.7048270	
			iQ		=	0.7253370	
		elseif	i(gksound)==19	then		
			iBase	=	0.7577000	
			iQ		=	0.7992690	
		elseif	i(gksound)==20	then		
			iBase	=	0.7577000	
			iQ		=	0.7992690	
		endif 

gialgfn	init		girtos1+i(gksound)				
gimodes	=		ftlen(gialgfn)					

			
	endif
endin



instr	2	
	
#define	WRITE_TO_TABLE(N)
	#
	tablew	gkQ$N, $N-1, giQs						
	tablew	gkAmp$N, $N-1, giAmps					
	tablew	gkrto$N, $N-1, girtos21			
	#
	$WRITE_TO_TABLE(1) 
	$WRITE_TO_TABLE(2) 
	$WRITE_TO_TABLE(3) 
	$WRITE_TO_TABLE(4) 
	$WRITE_TO_TABLE(5) 
	$WRITE_TO_TABLE(6) 
	$WRITE_TO_TABLE(7) 
	$WRITE_TO_TABLE(8) 
	$WRITE_TO_TABLE(9) 
	$WRITE_TO_TABLE(10)
	$WRITE_TO_TABLE(11)
	$WRITE_TO_TABLE(12)
	$WRITE_TO_TABLE(13)
	$WRITE_TO_TABLE(14)
	$WRITE_TO_TABLE(15)
	$WRITE_TO_TABLE(16)
	$WRITE_TO_TABLE(17)
	$WRITE_TO_TABLE(18)
	$WRITE_TO_TABLE(19)
	$WRITE_TO_TABLE(20)
	$WRITE_TO_TABLE(21)
	$WRITE_TO_TABLE(22)
	$WRITE_TO_TABLE(23)
	$WRITE_TO_TABLE(24)
endin

instr	3
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10
kdelfo madsr i(gkdelfo),.001,1,1 
iampfix = 2

	kamp		init		1											
	apulse	mpulse	kamp, 0										

imidinn notnum
kcent = gkcenttmp * 0.01
kbase = cpsmidinn(imidinn + gksemi + kcent)
iamp ampmidi 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)
kfilt expseg i(gkfqstart), i(gkfqtime), i(gkfqend), 6000, i(gkfqend)
												
	icount	init		1											
			modemodulei	apulse, kbase+klfo, icount, gialgfn, gimodes		
	aout		zar		0											
									
	aout1		=		(aout*gkOutGain) / gimodes

aoutA moogladder aout1, kfilt, gkq

aout1 balance aoutA, aout1

				outs			aout1*kenv*iamp*iampfix, aout1*kenv*iamp*iampfix
			zacl		0, 0	
endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 22
kinstr init 3
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
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
  <uuid>{93709e27-092f-41a2-8321-45e695dac2ab}</uuid>
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
