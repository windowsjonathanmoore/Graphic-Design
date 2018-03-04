;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	MultiFlanger
;;	by Steven Cook
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
ksmps		=	16
nchnls	=	2
0dbfs		=	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then

gkdep1	chnget "kdep" 
gkrat1	chnget "krat"
gkfdbk1 	chnget "kfdbk"

endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr	1
ainL, ainR ins

kdep1	= gkdep1
krat1	= gkrat1
kfdbk1 = gkfdbk1
	
klevl    = .4	
kdepth   = (kdep1+.5)/1000
krate    = krat1		
kfeed    = kfdbk1				
imode    = 22		
 
asaw1    oscili  kdepth, krate, imode      
asaw2    oscili  kdepth, krate, imode, .25  
asaw3    oscili  kdepth, krate, imode, .5  
asaw4    oscili  kdepth, krate, imode, .75 
 
asin1    oscili  1, krate, 33 
asin2    oscili  1, krate, 33, .25          
asin3    oscili  1, krate, 33, .5        
asin4    oscili  1, krate, 33, .75  
 
adel1L    flanger  ainL, asaw1, kfeed, 1 
adel2L    flanger  ainL, asaw2, kfeed, 1
adel3L    flanger  ainL, asaw3, kfeed, 1
adel4L    flanger  ainL, asaw4, kfeed, 1
 
aflangeL  = adel1L*asin1 + adel2L*asin2 + adel3L*asin3 + adel4L*asin4
aflangeL  dcblock  aflangeL
 
adel1R    flanger  ainR, asaw1, kfeed, 1 
adel2R    flanger  ainR, asaw2, kfeed, 1 
adel3R    flanger  ainR, asaw3, kfeed, 1 
adel4R    flanger  ainR, asaw4, kfeed, 1
 
aflangeR  = adel1R*asin1 + adel2R*asin2 + adel3R*asin3 + adel4R*asin4
aflangeR  dcblock  aflangeR
 
adirectL  = ainL*(asin1 + asin2 + asin3 + asin4)
adirectR  = ainR*(asin1 + asin2 + asin3 + asin4)

aoutL = (aflangeL + adirectL)*klevl
aoutR = (aflangeR + adirectR)*klevl

aoutL balance aoutL, ainL
aoutR balance aoutR, ainR
 	
 	outs aoutL, aoutR
 	
 	endin


</CsInstruments>
<CsScore>
f22 0 4097 -7 0 4096 1
f33 0 4097 19 .5 1 0 0
f0 99999

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
  <uuid>{9d15349d-c596-426c-94b4-c05a3b31afa8}</uuid>
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
