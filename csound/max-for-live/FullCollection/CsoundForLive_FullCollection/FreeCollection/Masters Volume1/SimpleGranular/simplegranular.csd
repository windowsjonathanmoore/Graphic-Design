;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple Granular
;;	Adapted from the QuteCsound Example:
;;		"SF Granular"
;;		by Joachim Heintz
;;	And influenced by the examples of Øyvind Brandtsegg
;;
;;    Adapted for CsoundForLive by Colman O'Reilly
;;    www.csoundforlive.com
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

turnon 1
gksamplepos	init 0

instr 1    
ktrig	metro	100
if (ktrig == 1)	then

kchange chnget "change"
gkgrs1 chnget "kgrs1"
gkgrr1 chnget "kgrr1"
gkspeed1 chnget "kspeed"

endif


kSwitch changed kchange
if kSwitch == 1 then

turnoff2 2, 0, 0
endif

giWin1	ftgen		762, 0, 4096, 20, 1, 1
giDisttab	ftgen		0, 0, 32768, 7, 0, 32768, 1	
giCosine	ftgen		0, 0, 8193, 9, 1, 1, 90	
giPan		ftgen		0, 0, 32768, -21, 1

giWin1	ftgen		1, 0, 4096, 20, 1, 1		; Hamming
giWin2	ftgen		2, 0, 4096, 20, 2, 1		; von Hann
giWin3	ftgen		3, 0, 4096, 20, 3, 1		; Triangle (Bartlett)
giWin4	ftgen		4, 0, 4096, 20, 4, 1		; Blackman (3-term)
giWin5	ftgen		5, 0, 4096, 20, 5, 1		; Blackman-Harris (4-term)
giWin6	ftgen		6, 0, 4096, 20, 6, 1		; Gauss
giWin7	ftgen		7, 0, 4096, 20, 7, 1, 6	; Kaiser
giWin8	ftgen		8, 0, 4096, 20, 8, 1		; Rectangle
giWin9	ftgen		9, 0, 4096, 20, 9, 1		; Sync



endin


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SoundFile Granular Synthesizer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 2
gSfilename 	chnget 	"filename"
giFilep1	ftgen		401, 0, 0, -1, gSfilename, 0, 0, 1

kspeed1	= gkspeed1 
kgrr1		= gkgrr1
kgrs1		= gkgrs1

iwin			= 762
igksamplepos	= 0
ifiltab		= giWin1
kspeed		= kspeed1
kgrainrate		= kgrr1
kgrainsize		= kgrs1
kcent			= 1
kgrainamp		= 1
kdist			= .5
kposrand		= 0
kcentrand		= 0
kpan			= 1
icosintab		= giCosine
idisttab		= giDisttab
iFile 		= giFilep1
kwaveform		= iFile
imax_grains		= 200 


;; Unused Constants:
async			= 0	
kenv2amt		= 1
ienv2tab 		= iwin
ienv_attack		= -1
ienv_decay		= -1
ksustain_amount 	= 0.5
ka_d_ratio		= 0.5
igainmasks		= -1
ksweepshape		= 0
iwavfreqstarttab 	= -1
iwavfreqendtab 	= -1
awavfm		= 0
ifmamptab		= -1
kfmenv		= -1
icosine		= giCosine
kTrainCps		= kgrainrate
knumpartials	= 1
kchroma		= 1
krandommask		= 0
iwaveamptab		= -1
kwavekey		= 1
kamp 			= .3
kcentrand rand kcentrand
ichannelmasks 	= giPan
arndpos 		= 0
tableiw 0, 		0, giPan
tableiw 32766, 	1, giPan


ifilen tableng iFile
ifildur		= ifilen / sr
iorig			= 1 / ifildur
kwavfreq		= iorig * cent(kcentrand)		
afilposphas phasor kspeed / ifildur, igksamplepos
asamplepos		= afilposphas

agrL1, agrR1	partikkel kgrainrate, kdist, giDisttab, async, kenv2amt, ienv2tab, \
		ienv_attack, ienv_decay, ksustain_amount, ka_d_ratio, kgrainsize, kamp, igainmasks, \
		kwavfreq, ksweepshape, iwavfreqstarttab, iwavfreqendtab, awavfm, \
		ifmamptab, kfmenv, icosine, kTrainCps, knumpartials, \
		kchroma, ichannelmasks, krandommask, kwaveform, kwaveform, kwaveform, kwaveform, \
		iwaveamptab, asamplepos, asamplepos, asamplepos, asamplepos, \
		kwavekey, kwavekey, kwavekey, kwavekey, imax_grains

outs agrL1, agrR1
endin


instr 3
turnoff2 2, 0, 0
gSfilename chnget "filename" ;redundancy to make sure gSfilename always has a value.
endin


</CsInstruments>
<CsScore>
f0 60000
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
  <uuid>{1befd26a-fafa-4729-8c72-38739c9b84f7}</uuid>
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
