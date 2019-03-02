;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Splice Stutter
;;	by Rory Walsh
;;		Adapted from his UDO "TrackerSplice"
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
sr = 44100
ksmps = 32
nchnls = 2	

turnon 10

opcode trackerSplice, a, akk
asig, kseglength, kmode xin

setksmps 1
kindx init 0
ksamp init 1
aout init 0

itbl ftgenonce 0, 0, 2^16, 7, 0, 2^16, 0
kseglength = kseglength*sr			
andx phasor sr/ftlen(itbl)			
tabw asig, andx*ftlen(itbl), itbl	
andx1 delay andx, 1				
						
apos samphold andx1*ftlen(itbl), ksamp		

if(kmode>=1 && kmode <2) then 		
	kpos downsamp apos
	kindx = (kindx>kseglength ? 0 : kindx+1)
	if(kindx+kpos> ftlen(itbl)) then
	kindx = -kseglength
	endif
	aout table apos+kindx, itbl, 0, 1
	ksamp = 0

elseif(kmode>=2 && kmode<3) then				
	kpos downsamp apos
	kindx = ((kindx+kpos)<=0 ? ftlen(itbl)-kpos : kindx-1)
	aout table apos+kindx, itbl, 0, 1
	ksamp = 0

else 					
	ksamp = 1
	aout = asig
endif
xout aout
endop

instr 10
ktrig	metro	100
if (ktrig == 1)	then

gksegLength 	chnget "seglength"	
gkmode 	chnget "mode"

endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr 1

asigL, asigR ins						
aoutL trackerSplice asigL, gksegLength, int(gkmode)
aoutR trackerSplice asigR, gksegLength, int(gkmode)

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
  <uuid>{aec94d8a-d595-42f0-9633-dfaff237332b}</uuid>
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
