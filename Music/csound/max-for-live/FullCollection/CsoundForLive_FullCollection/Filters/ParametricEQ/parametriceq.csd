;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Pareq
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
0dbfs		=	1


turnon 10

instr	10
ktrig	metro	10
if (ktrig == 1)	then
gkc		chnget 	"cutoff"
gkv		chnget 	"paragain"
gkq		chnget 	"q"
gkamp		chnget 	"amp"
gkmode	chnget  	"mode"
	endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr	1
ainL, ainR ins
	
kc tonek gkc, 20
kv tonek gkv, 20
kamp tonek gkamp, 20
kq tonek gkq, 20	
	
	
kSwitch		changed	gkmode
if	kSwitch=1	then	
	reinit	START	
endif
START:
aoutL 		pareq 	ainL, kc, kv, kq, i(gkmode)
aoutR 		pareq 	ainR, kc, kv, kq, i(gkmode)
			rireturn
				
aoutL balance aoutL, ainL
aoutR balance aoutR, ainR				
outs	aoutL*kamp, aoutR*kamp
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
  <uuid>{c079603c-a771-4a6c-866e-18487bdaae9f}</uuid>
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
