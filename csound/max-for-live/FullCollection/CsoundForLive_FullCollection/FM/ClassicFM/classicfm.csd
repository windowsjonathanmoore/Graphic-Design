;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	CsoundForLive FM Synthesizer
;;
;;	by Colman O'Reilly
;;	www.csoundforlive.com
;;	
;;	Inspired by the work of John Chowning	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>
sr		=	44100
ksmps	=	16
nchnls	=	2
0dbfs	=	1

turnon 3
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
gklfotype chnget "lfotype"
gkindex	chnget	"Index"
gkCarRatio	chnget  	"Carrier_Frequency"
gkModRatio	chnget  	"Modulator_Frequency"
gkspread chnget "spread"
gkdetune chnget "detune"
gklfoamp chnget "lfoamp"
gklforate chnget "lforate"
gkq chnget "resonance"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkvoices chnget "voices"
gkdelfo chnget "lfodelay"

gkfco chnget "fco"
gkfiltatt chnget "filtatt"
gkfiltdec chnget "filtdec"
gkfiltsus chnget "filtsus"
gkfiltrel chnget "filtrel"
gkfqstart chnget "fqstart"
gkfiltadsrbypass chnget "filtadsrbypass"
endif

endin




instr	2
iampfix = .5
;;Tuning Block:;;;;;;;;;;;;;;;;;;;;;;;;;;
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kbasefreq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kbasefreq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
iamp ampmidi 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Control Smoothing
klfoamp tonek gklfoamp, 10
klforate tonek gklforate, 10
kspread tonek gkspread, 10
kq tonek gkq, 10
	
kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
kenv1 madsr i(gkatt1), i(gkdec1), i(gksus1), i(gkrel1)	;mod envg
kdelfo madsr i(gkdelfo),.001,1,1  ;lfo onset delay
klfo lfo klfoamp*kdelfo, klforate, i(gklfotype)


kindex tonek gkindex, 10
kpeakdeviation = kbasefreq1 * kindex
aModulator	poscil kpeakdeviation*kenv1, kbasefreq1 * gkModRatio, 1

aout1	poscil kenv, ((kbasefreq1 * gkCarRatio) + aModulator) + klfo, 1
aout2	poscil kenv, ((kbasefreq2 * gkCarRatio) + aModulator) + klfo, 1			

if gkfiltadsrbypass == 0 then
aoutA moogladder aout1, gkfco, gkq*.99
aoutB moogladder aout2, gkfco, gkq*.99
aout1 balance aoutA, aout1
aout2 balance aoutB, aout2
else
kfilt madsr i(gkfiltatt), i(gkfiltdec), i(gkfiltsus), i(gkfiltrel)
aout1 moogladder aout1, kfilt*gkfco, gkq
aout2 moogladder aout2, kfilt*gkfco, gkq
aout1 clip aout1, 0, .99
aout2 clip aout2, 0, .99
endif

;;Spread Section:
aoutL = ((aout1 * kspread) + (aout2 * (1 - kspread))) *.5  
aoutR = ((aout1 * (1-kspread)) + (aout2 * kspread))   *.5

outs aoutL*iampfix, aoutR*iampfix										
endin


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 3
kinstr init 2
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin

</CsInstruments>
<CsScore>
f 1 0 4096 10 1
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
 <bgcolor mode="background">
  <r>241</r>
  <g>226</g>
  <b>185</b>
 </bgcolor>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>2</x>
  <y>2</y>
  <width>514</width>
  <height>557</height>
  <uuid>{aa607456-d368-4d59-8497-d16d608404c3}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>             FM Synthesis: Simple Modulator->Carrier</label>
  <alignment>center</alignment>
  <font>DejaVu Sans</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="background">
   <r>5</r>
   <g>27</g>
   <b>150</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>5</borderradius>
  <borderwidth>2</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>519</x>
  <y>2</y>
  <width>452</width>
  <height>555</height>
  <uuid>{74928ed2-b701-4668-9a11-74763d317e9b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>FM Synthesis: Simple Modulator->Carrier</label>
  <alignment>center</alignment>
  <font>Arial Black</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="background">
   <r>5</r>
   <g>27</g>
   <b>150</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>5</borderradius>
  <borderwidth>2</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>523</x>
  <y>21</y>
  <width>444</width>
  <height>522</height>
  <uuid>{d4bdb5ce-87d8-4c8c-9c64-40ec2eed6f5a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>----------------------------------------------------------------------------------------------------------------------------
This example also employs a simple modulator carrier pairing. This time, however, the FM implementation and the parameters presented to the user are more typical (and more usable). The 'Index of Modulation' is used to control the spectral intensity (brightness) of the FM timbre. This value is used in the formula: 'Peak Deviation = Index * Base Frequency' to calculate the Peak Deviation (amplitude) of the modulator within the code. A value box for peak deviation is provided to inform the user how its value changes in relation to changes made to the base frequency and the index of modulation. The value for peak deviation can not be directly modified by the user, its value box in the interface is for display purposes only. The frequencies of the carrier and modulator are calculated in relation to 'Base Frequency' using a ratio between the carrier frequency and the modulator frequency. This practice makes it easier for the user to see when the two frequencies are in a simple ratio with respect to each other. Although the code for this example makes use of two separate 'oscili' (oscillator) opcodes for the modulator and carrier an opcode exists that will allow the FM carrier modulator pair to be implemented in a single line (foscil/foscili). The advantage of emplying separate 'oscili's is that a better understanding of the innards of FM synthesis is gained and also that the algorithm can easily be expanded to create more complex multi-modulator and multi-carrier algorithms.</label>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>14</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBButton">
  <objectName/>
  <x>8</x>
  <y>6</y>
  <width>100</width>
  <height>30</height>
  <uuid>{24979132-c53f-4414-ac6b-6b4f503ecfe8}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>  ON / OFF</text>
  <image>/</image>
  <eventLine>i 2 0 -1</eventLine>
  <latch>true</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>Carrier_Amplitude</objectName>
  <x>451</x>
  <y>370</y>
  <width>60</width>
  <height>30</height>
  <uuid>{745d6bee-b951-4a03-9fe8-9e10d5ae4556}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>0.102</label>
  <alignment>right</alignment>
  <font>Arial</font>
  <fontsize>9</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBHSlider">
  <objectName>Carrier_Amplitude</objectName>
  <x>11</x>
  <y>347</y>
  <width>500</width>
  <height>27</height>
  <uuid>{06814721-6151-4baa-84e2-8f39843b07a4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.10200000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>11</x>
  <y>370</y>
  <width>180</width>
  <height>30</height>
  <uuid>{c6d7165c-6730-426f-b293-52b411bc73cf}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>Carrier Amplitude</label>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>95</x>
  <y>257</y>
  <width>234</width>
  <height>83</height>
  <uuid>{53a95371-23f7-4d54-a6c6-63bbabdb388d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>194</x>
  <y>259</y>
  <width>32</width>
  <height>46</height>
  <uuid>{81ded06c-d53f-4a6d-a597-5f1b68b18042}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>:</label>
  <alignment>center</alignment>
  <font>Arial Black</font>
  <fontsize>27</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBSpinBox">
  <objectName>Carrier_Frequency</objectName>
  <x>115</x>
  <y>269</y>
  <width>70</width>
  <height>28</height>
  <uuid>{6f8fc775-201d-40f9-931b-687c9b3ef417}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>14</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <resolution>0.00100000</resolution>
  <minimum>0.125</minimum>
  <maximum>8</maximum>
  <randomizable group="0">false</randomizable>
  <value>0.125</value>
 </bsbObject>
 <bsbObject version="2" type="BSBSpinBox">
  <objectName>Modulator_Frequency</objectName>
  <x>238</x>
  <y>269</y>
  <width>70</width>
  <height>28</height>
  <uuid>{fd4b783c-f008-4a1c-b2e6-50340aad9093}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>14</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <resolution>0.00100000</resolution>
  <minimum>0.125</minimum>
  <maximum>8</maximum>
  <randomizable group="0">false</randomizable>
  <value>0.125</value>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>238</x>
  <y>298</y>
  <width>70</width>
  <height>50</height>
  <uuid>{d7a84933-3d3a-4adf-8289-84a4413362a7}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>Modulator
Frequency</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>115</x>
  <y>298</y>
  <width>70</width>
  <height>50</height>
  <uuid>{7723878b-fcac-4444-84a2-a4ba87008431}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>Carrier
Frequency</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>X_Base_Freq</objectName>
  <x>8</x>
  <y>43</y>
  <width>420</width>
  <height>172</height>
  <uuid>{a74a02bb-cecf-45a3-8140-79b143c0e8ef}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>Y_Index</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>10.00000000</yMax>
  <xValue>0.45714286</xValue>
  <yValue>4.41860465</yValue>
  <type>crosshair</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>102</x>
  <y>215</y>
  <width>220</width>
  <height>30</height>
  <uuid>{74dfaf43-4f78-445c-95c6-23d68e551186}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>X - Base Freq     Y - Index</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>14</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>X_Base_Freq_Value</objectName>
  <x>8</x>
  <y>217</y>
  <width>70</width>
  <height>25</height>
  <uuid>{e3ed96df-99f4-4179-a473-e3ca2655f03c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>79.634</label>
  <alignment>center</alignment>
  <font>Liberation Sans</font>
  <fontsize>9</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>8</x>
  <y>243</y>
  <width>70</width>
  <height>30</height>
  <uuid>{9e4a0ffe-617b-436d-834f-18dcd2426c96}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>Pointer</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>358</x>
  <y>242</y>
  <width>70</width>
  <height>30</height>
  <uuid>{781046c2-6aa7-4a3e-98ef-754130485b16}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>Density</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>Y_Index</objectName>
  <x>358</x>
  <y>216</y>
  <width>70</width>
  <height>25</height>
  <uuid>{e5d08e1b-a630-430c-a5e0-80244c9ce336}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>4.419</label>
  <alignment>center</alignment>
  <font>Liberation Sans</font>
  <fontsize>9</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>437</x>
  <y>107</y>
  <width>70</width>
  <height>50</height>
  <uuid>{a8223fbb-098e-46e7-aaba-d43aed7a2ade}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>Peak
Deviation</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>Peak_Deviation</objectName>
  <x>437</x>
  <y>81</y>
  <width>70</width>
  <height>25</height>
  <uuid>{4b93a012-8afc-4afb-a812-04469d08245e}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>194.482</label>
  <alignment>center</alignment>
  <font>Liberation Sans</font>
  <fontsize>9</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBGraph">
  <objectName/>
  <x>7</x>
  <y>403</y>
  <width>502</width>
  <height>151</height>
  <uuid>{e2e84fd4-c33d-42db-98ab-48c805b3e4f5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <value>0</value>
  <objectName2/>
  <zoomx>3.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <modex>lin</modex>
  <modey>lin</modey>
  <all>true</all>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<MacGUI>
ioView background {61937, 58082, 47545}
ioText {2, 2} {514, 557} label 0.000000 0.00100 "" center "DejaVu Sans" 18 {65280, 65280, 65280} {1280, 6912, 38400} nobackground noborder              FM Synthesis: Simple Modulator->Carrier
ioText {519, 2} {452, 555} label 0.000000 0.00100 "" center "Arial Black" 18 {65280, 65280, 65280} {1280, 6912, 38400} nobackground noborder FM Synthesis: Simple Modulator->Carrier
ioText {523, 21} {444, 522} label 0.000000 0.00100 "" left "Arial" 14 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder ----------------------------------------------------------------------------------------------------------------------------¬This example also employs a simple modulator carrier pairing. This time, however, the FM implementation and the parameters presented to the user are more typical (and more usable). The 'Index of Modulation' is used to control the spectral intensity (brightness) of the FM timbre. This value is used in the formula: 'Peak Deviation = Index * Base Frequency' to calculate the Peak Deviation (amplitude) of the modulator within the code. A value box for peak deviation is provided to inform the user how its value changes in relation to changes made to the base frequency and the index of modulation. The value for peak deviation can not be directly modified by the user, its value box in the interface is for display purposes only. The frequencies of the carrier and modulator are calculated in relation to 'Base Frequency' using a ratio between the carrier frequency and the modulator frequency. This practice makes it easier for the user to see when the two frequencies are in a simple ratio with respect to each other. Although the code for this example makes use of two separate 'oscili' (oscillator) opcodes for the modulator and carrier an opcode exists that will allow the FM carrier modulator pair to be implemented in a single line (foscil/foscili). The advantage of emplying separate 'oscili's is that a better understanding of the innards of FM synthesis is gained and also that the algorithm can easily be expanded to create more complex multi-modulator and multi-carrier algorithms.
ioButton {8, 6} {100, 30} event 1.000000 "" "  ON / OFF" "/" i 2 0 -1
ioText {451, 370} {60, 30} display 0.102000 0.00100 "Carrier_Amplitude" right "Arial" 9 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder 0.102
ioSlider {11, 347} {500, 27} 0.000000 1.000000 0.102000 Carrier_Amplitude
ioText {11, 370} {180, 30} label 0.000000 0.00100 "" left "Arial" 10 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder Carrier Amplitude
ioText {95, 257} {234, 83} label 0.000000 0.00100 "" left "Arial" 10 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder 
ioText {194, 259} {32, 46} label 0.000000 0.00100 "" center "Arial Black" 27 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder :
ioText {115, 269} {70, 28} editnum 0.125000 0.001000 "Carrier_Frequency" left "" 0 {0, 0, 0} {61440, 61440, 61440} nobackground noborder 0.125000
ioText {238, 269} {70, 28} editnum 0.125000 0.001000 "Modulator_Frequency" left "" 0 {0, 0, 0} {61440, 61440, 61440} nobackground noborder 0.125000
ioText {238, 298} {70, 50} label 0.000000 0.00100 "" center "Arial" 10 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder Modulator¬Frequency
ioText {115, 298} {70, 50} label 0.000000 0.00100 "" center "Arial" 10 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder Carrier¬Frequency
ioMeter {8, 43} {420, 172} {0, 59904, 0} "X_Base_Freq" 0.457143 "Y_Index" 4.418605 crosshair 1 0 mouse
ioText {102, 215} {220, 30} label 0.000000 0.00100 "" center "Arial" 14 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder X - Base Freq     Y - Index
ioText {8, 217} {70, 25} display 79.634000 0.00100 "X_Base_Freq_Value" center "Liberation Sans" 9 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder 79.634
ioText {8, 243} {70, 30} label 0.000000 0.00100 "" center "Arial" 10 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder Pointer
ioText {358, 242} {70, 30} label 0.000000 0.00100 "" center "Arial" 10 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder Density
ioText {358, 216} {70, 25} display 4.419000 0.00100 "Y_Index" center "Liberation Sans" 9 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder 4.419
ioText {437, 107} {70, 50} label 0.000000 0.00100 "" center "Arial" 10 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder Peak¬Deviation
ioText {437, 81} {70, 25} display 194.482000 0.00100 "Peak_Deviation" center "Liberation Sans" 9 {65280, 65280, 65280} {61440, 61440, 61440} nobackground noborder 194.482
ioGraph {7, 403} {502, 151} table 0.000000 3.000000 
</MacGUI>
<EventPanel name="" tempo="60.00000000" loop="8.00000000" x="913" y="162" width="655" height="346" visible="false" loopStart="0" loopEnd="0">    </EventPanel>