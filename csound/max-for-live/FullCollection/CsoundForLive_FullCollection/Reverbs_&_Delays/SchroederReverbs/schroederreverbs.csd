;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Schroeder Reverbs
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
0dbfs 	= 	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then

gktype chnget "type"
gkcut chnget "kcut"
gkwetL chnget "kwetL"
gkwetR chnget "kwetR"

endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr 1
igain = .3
ainL, ainR ins

kwetL tonek gkwetL, 20
kwetR tonek gkwetR, 20
kcut tonek gkcut, 20

denorm ainL, ainR

if (gktype == 0) then


kwetL = kwetL * 0.005
kwetR = kwetR * 0.005
	
krevfactor =        kwetL
krevfactorR =	 kwetR
ilowpass   =        9000
ioutputscale =      1

idel1     =         1237.000/sr
idel2     =         1381.000/sr
idel3     =         1607.000/sr
idel4     =         1777.000/sr
idel5     =         1949.000/sr
idel6     =         2063.000/sr
idel7     =         307.000/sr
idel8     =         97.000/sr
idel9     =         71.000/sr
idel10    =         53.000/sr
idel11    =         47.000/sr
idel12    =         37.000/sr
idel13    =         31.000/sr

kcsc1     =         .822 * krevfactor
kcsc2     =         .802 * krevfactor
kcsc3     =         .773 * krevfactor
kcsc4     =         .753 * krevfactor
kcsc5     =         .753 * krevfactor
kcsc6     =         .753 * krevfactor

kcsc1r     =         .822 * krevfactorR
kcsc2r     =         .802 * krevfactorR
kcsc3r     =         .773 * krevfactorR
kcsc4r    =         .753 * krevfactorR
kcsc5r     =         .753 * krevfactorR
kcsc6r     =         .753 * krevfactorR

kcsc7     =         .7 * krevfactor
                    
acomb1    comb      ainL, kcsc1, idel1
acomb2    comb      ainL, kcsc2, idel2
acomb3    comb      ainL, kcsc3, idel3
acomb4    comb      ainL, kcsc4, idel4
acomb5    comb      ainL, kcsc5, idel5
acomb6    comb      ainL, kcsc6, idel6

acomball  =         acomb1 + acomb2 + acomb3 + acomb4 + acomb5 + acomb6

allp1     alpass    acomball, kcsc7, idel7
allp2     alpass    allp1, kcsc7, idel8
allp3     alpass    allp2, kcsc7, idel9
alow      tone      allp3, ilowpass
allp4     alpass    alow, kcsc7, idel10
allp5     alpass    allp4, kcsc7, idel12
arevout1  =         allp5 * ioutputscale

acomb1    comb      ainR, kcsc1r, idel1
acomb2    comb      ainR, kcsc2r, idel2
acomb3    comb      ainR, kcsc3r, idel3
acomb4    comb      ainR, kcsc4r, idel4
acomb5    comb      ainR, kcsc5r, idel5
acomb6    comb      ainR, kcsc6r, idel6

acomball  =         acomb1 + acomb2 + acomb3 + acomb4 + acomb5 + acomb6

allp1     alpass    acomball, kcsc7, idel7
allp2     alpass    allp1, kcsc7, idel8
allp3     alpass    allp2, kcsc7, idel9
alow      tone      allp3, ilowpass
allp4     alpass    alow, kcsc7, idel10
allp6     alpass    allp4,kcsc7, idel13
arevout2  =         allp6 * ioutputscale
	
	aoutL = (arevout1+(1-kwetL)*ainL)*igain
	aoutR = (arevout2+(1-kwetR)*ainR)*igain
         

elseif (gktype == 1) then
	kwetL = kwetL * 0.01
	kwetR = kwetR * 0.01
		aL nreverb ainL, kwetL, kcut
		aR nreverb ainR, kwetR, kcut
	aoutL = (aL+(1-kwetL)*ainL)*igain
	aoutR = (aR+(1-kwetR)*ainR)*igain
	
elseif (gktype == 2) then
	kwetL = kwetL * 0.0025
	kwetR = kwetR * 0.0025
		aL reverb ainL, kwetL
		aR reverb ainR, kwetR
	aoutL = (aL+(1-kwetL)*ainL)*igain
	aoutR = (aR+(1-kwetR)*ainR)*igain
endif

aoutL dcblock2 aoutL
aoutR dcblock2 aoutR

outs aoutL, aoutR
endin

</CsInstruments>
<CsScore>
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
  <uuid>{1b84bb07-e095-47a0-bcc6-cd7b5812d60b}</uuid>
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
