;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Delay Feedback
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
sr 		= 	44100			
ksmps 	= 	16
nchnls 	= 	2		
0dbfs		=	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then
gkporttime1 chnget "port"
gkdlt chnget	"dlt"
gkmix chnget "wet"
gkfeedamt chnget "feedback"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 99999
endif
endin

instr 1	

ainL, ainR ins
	
kporttime1 = gkporttime1
kdlt = gkdlt
kmix = gkmix
kfeedamt = gkfeedamt
		
kporttime	linseg		0, .001, 1, 1, 1					
kporttime	=	kporttime * kporttime1	
kdlt		portk		kdlt, kporttime					
adlt		interp		kdlt								 
	
;Left Delay:
abufferL	delayr	1									
adelsigL 	deltap3	adlt									
		delayw	ainL + (adelsigL * kfeedamt)		
	
;Right Delay
abufferR	delayr	1						
adelsigR 	deltap3	adlt							
		delayw	ainR + (adelsigR * kfeedamt)		
	
aoutL ntrpol ainL, adelsigL, kmix
aoutR ntrpol ainR, adelsigR, kmix

aoutL dcblock2 aoutL
aoutR dcblock2 aoutR

outs aoutL, aoutR
				
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
  <uuid>{8bc30af7-8294-4c51-b6ae-302fcee1ed95}</uuid>
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
