;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Powershape
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
ksmps		=	16
nchnls	=	2
0dbfs 	= 	1

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then

gktype chnget "type"
gkcontrol1 chnget "kcontrol1"
gkcontrol2 chnget "kcontrol2"
gkswitch chnget "switch"	
gkgain	chnget "kgain"	


endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr	1
ainL, ainR ins	

kcontrol1 tonek gkcontrol1, 20
kcontrol2 tonek gkcontrol2, 20

if gktype == 0 then

kscaled1 = kcontrol2
											
aoutL powershape 	ainL, kscaled1, 1			   
aoutR powershape ainR, kscaled1, 1	

elseif gktype == 1 then

kscaled2 = kcontrol1 * 1.25

aoutL distort ainL, kscaled2, 1			   
aoutR distort ainR, kscaled2, 1

endif

if gkswitch == 1 then
	aoutL balance aoutL, ainL
	aoutR balance aoutR, ainR
elseif gkswitch == 0 then
	aoutL clip aoutL, 0, .95
	aoutR clip aoutR, 0, .95
endif
			
outs	aoutL*gkgain, aoutR*gkgain 
endin

</CsInstruments>
<CsScore>
f1  0 16384 10   1
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
  <uuid>{47a40f5c-fe48-4929-8d4f-f48de4a2372e}</uuid>
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
