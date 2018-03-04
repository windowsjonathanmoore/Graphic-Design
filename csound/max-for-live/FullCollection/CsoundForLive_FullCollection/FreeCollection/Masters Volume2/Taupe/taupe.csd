;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Taupe
;;	by Richard Boulanger
;;		from "Trapped in Convert - 1979"
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
kr		=	441
ksmps		=	100
nchnls	=	2
0dbfs		=	1

turnon 22

instr 10
ktrig	metro	100
if (ktrig == 1)	then
gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"

gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkdetune chnget "detune"
gkvoices chnget "voices"

gkspread chnget "spread"

gkrand chnget "randfrq"		; 20 to 400
gkrandamp chnget "randamp"		; 1 - 72

endif
endin

;============================================================================;
;==================================== TAUPE =================================;
;============================================================================;
        instr  1
;;Tuning Block:;;;;;;;;;;;;;;;;;;;;;;;;;;
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
iamp ampmidi 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
        
;krand tonek gkrand, 20        
;ifreq   =      cpspch(p5)                    ; p5 = freq
 
                                            ; p6 = amp
k2      randh  gkrandamp, gkrand, .1                    ; p7 = reverb send factor
k3      randh  gkrandamp * .98, gkrand * .91, .2        ; p8 = rand amp
k4      randh  gkrandamp * 1.2, gkrand * .96, .3        ; p9 = rand freq
k5      randh  gkrandamp * .9, gkrand * 1.3

;kenv    linenr  iamp, i(gkatt), i(gkrel), 0.001
kenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)


a1      oscil  kenv, kfrq1 + k2, 1, .2
a2      oscil  kenv * .91, (kfrq1 + .004) + k3, 2;, .3
a3      oscil  kenv * .85, (kfrq2 + .006) + k4, 3;, .5
a4      oscil  kenv * .95, (kfrq2 + .009) + k5, 4;, .8

aout1 = a1 + a2
aout2 = a3 + a4
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5

        outs   aoutL*iamp, aoutR*iamp

        endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 22
kinstr init 1
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin



</CsInstruments>
<CsScore>

f1   0  8192  10   1
f2   0  512   10   10  8   0   6   0   4   0   1
f3   0  512   10   10  0   5   5   0   4   3   0   1
f4   0  2048  10   10  0   9   0   0   8   0   7   0  4  0  2  0  1

i10 0 600000


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
  <uuid>{fcc99f56-1b97-4aa4-a5f0-682caecbeb8d}</uuid>
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
