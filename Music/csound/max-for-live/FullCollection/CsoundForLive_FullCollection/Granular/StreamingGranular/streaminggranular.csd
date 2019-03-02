;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	StreamingGranular
;;
;;	Adapted from the QuteCsound Example:
;;		"Live Granular" by Joachim Heintz
;;		joachimheintz.de
;;	Adapted for CsoundForLive by Colman O'Reilly
;;		www.csoundforlive.com
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
giLiveBuf	ftgen		0, 0, 16384, 2, 0			
giDisttab	ftgen		0, 0, 32768, 7, 0, 32768, 1
giCosine	ftgen		0, 0, 8193, 9, 1, 1, 90
giMaxGrLen	=		0.1

  opcode PartikkelSimpB, a, iakkkkkkkiii
ifiltab, apnter, kgrainamp, kgrainrate, kgrainsize, kdist, kcent, kposrand, kcentrand, icosintab, idisttab, iwin	xin
kamp		= 		kgrainamp * 0dbfs
kcentrand	rand 		kcentrand
iorig		= 		1 / (ftlen(ifiltab)/sr)
kwavfreq	= 		iorig * cent(kcent + kcentrand)	
kposrand	=		(kposrand/1000) * (sr/ftlen(ifiltab))
arndpos	linrand	kposrand
asamplepos	=		apnter + arndpos 
imax_grains	= 		1000
async		=		0
awavfm	=		0
aout		partikkel 	kgrainrate, kdist, idisttab, async, 1, iwin, \
				-1, -1, 0, 0, kgrainsize, kamp, -1, \
				kwavfreq, 0, -1, -1, awavfm, \
				-1, -1, icosintab, kgrainrate, 1, \
				1, -1, 0, ifiltab, ifiltab, ifiltab, ifiltab, \
				-1, asamplepos, asamplepos, asamplepos, asamplepos, \
				1, 1, 1, 1, imax_grains
		xout		aout
  endop



instr 1
aL, aR ins
aLiveInPre = (aL + aR)*.5

kLiveInGain	chnget	"LiveInGain"
aLiveInPost	=		aLiveInPre * kLiveInGain
iphasfreq	=		1 / (ftlen(giLiveBuf) / sr)
kfreeze	chnget	"freeze"
kphasfreq	=		(kfreeze == 1 ? 0 : iphasfreq)
awritpnt	phasor		kphasfreq
tablew aLiveInPost, awritpnt, giLiveBuf, 1, 0, 1
event_i	"i", 2, giMaxGrLen, -1, iphasfreq
gkTrigDisp	metro		10
gkdbrange	= 50

gkgrainrate		chnget	"grainrate"
kgrainsize		chnget	"grainsize"
gkcent		chnget	"transp"
gkgrainamp		chnget	"gain"
gkdist		chnget	"dist"
gkposrand		chnget	"posrand"
gkcentrand		chnget	"centrand"
kgrainfine		chnget	"grainfine"
gkgrainsize = kgrainsize * kgrainfine

kwinshape	chnget	"winshape"
		event_i	"i", 10, 0, -1, i(kwinshape)+1
kchanged	changed	kwinshape
 if kchanged == 1 then
		event		"i", -10, 0, -1
		event		"i", 10, 0, -1, kwinshape+1
 endif
endin

instr 2
iphasfreq	=		p4 
kfreeze	chnget	"freeze"
kphasfreq	=		(kfreeze == 1 ? 0 : iphasfreq)
areadpnt	phasor		kphasfreq
		chnset		areadpnt, "readpnt"
endin

instr 10
igainfix = .5

iwin		=		p4 
ifiltab	=		giLiveBuf
apnt		init		0
icosintab	=		giCosine
idisttab	=		giDisttab 
apnt		chnget "readpnt"

agrain 	PartikkelSimpB 	ifiltab, apnt, gkgrainamp, gkgrainrate, gkgrainsize,\
					gkdist, gkcent, gkposrand, gkcentrand, icosintab, idisttab, iwin
		outs		agrain*igainfix, agrain*igainfix


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
  <uuid>{882cdd0e-a90b-49fe-b62b-b8ad0d4f1443}</uuid>
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
