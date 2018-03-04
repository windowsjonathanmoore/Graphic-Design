;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Buzz Lead
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

massign 1, 2

instr 1
ktrig	metro	100
if (ktrig == 1)	then

gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"
gkatt1 chnget "att1"
gkdec1 chnget "dec1"
gksus1 chnget "sus1"
gkrel1 chnget "rel1"
gkfqstart chnget "fqstart"
gkfqtime chnget "fqtime"
gkfqend chnget "fqend"
gklfotype chnget "lfotype"
gkcut chnget "kcut"
gkharm chnget "kharm"
gkspread chnget "spread"
gkdetune chnget "detune"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkvoices chnget "voices"
gkporttime chnget "glide"
endif
endin

instr	2
;;Tuning Block:
    
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
gkfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
gkfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
giamp ampmidi 1

gkenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)	
schedkwhen      1,           0,       1,       3,      0,   3600
endin

instr 3
kporttime linseg	0, (.01), 1, (1), 1
kporttime	= kporttime * gkporttime
kfrq1	portk	gkfrq1, kporttime
kfrq2	portk	gkfrq2, kporttime

;;Monophonic Part:
kreltrig	release
gkinstrcount 	active 2
if		gkinstrcount!=0||kreltrig=1	kgoto	GO
turnoff
GO:


klfo lfo gklfoamp, gklforate, i(gklfotype)
kfilt expseg i(gkfqstart), i(gkfqtime), i(gkfqend), 6000, i(gkfqend)

aout1 buzz gkenv*giamp, kfrq1+klfo, gkharm, 1
aout2 buzz gkenv*giamp, kfrq2+klfo, gkharm, 1

aout1 = aout1 * (gkharm /75 + 1) ; RMS adjust
aout2 = aout2 * (gkharm /75 + 1) ; RMS adjust

aoutA moogladder aout1, kfilt, gkq
aoutB moogladder aout2, kfilt, gkq

aout1 balance aoutA, aout1
aout2 balance aoutB, aout2


;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

igain= 2
outs aoutL*igain, aoutR*igain

endin


</CsInstruments>
<CsScore>
f1  0 4096 10   1
i1 0 60000


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
  <uuid>{312eef82-ebc4-4a90-9953-5a15501af166}</uuid>
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
