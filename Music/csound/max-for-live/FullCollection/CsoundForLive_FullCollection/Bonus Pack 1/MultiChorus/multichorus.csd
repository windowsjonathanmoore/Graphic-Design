;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Chorus
;;
;;	Inspired by Steven Cook
;;	Adapted for CsoundForLive by Matthew Hines and Colman O'Reilly
;;	www.matthewhines.com
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
<CsoundSynthesizer>
<CsOptions>
-old parser
</CsOptions>
<CsInstruments>
sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 2

instr 1
ktrig	metro	100
if (ktrig == 1)	then
gkdelay chnget "delay"  ; 20
gkdepth chnget "depth"  ;2.5
gkmax chnget "max"

gkrandon chnget "randon"
endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 60000
endif
endin

 
instr    2
 
kmax tonek gkmax, 20
kdepth tonek gkdepth/1000, 20
kdelay tonek gkdelay/1000, 20 
 
klevl = 1*.3   ; Output level

ain1, ain2 ins

ain = (ain1 + ain2) * .5
ain      = ain*klevl


alfo01   oscili  kdepth, kmax, 3
alfo02   oscili  kdepth, kmax, 3, .08
alfo03   oscili  kdepth, kmax, 3, .17
alfo04   oscili  kdepth, kmax, 3, .25
alfo05   oscili  kdepth, kmax, 3, .33
alfo06   oscili  kdepth, kmax, 3, .42
alfo07   oscili  kdepth, kmax, 3, .50
alfo08   oscili  kdepth, kmax, 3, .58
alfo09   oscili  kdepth, kmax, 3, .67
alfo10   oscili  kdepth, kmax, 3, .75
alfo11   oscili  kdepth, kmax, 3, .83
alfo12   oscili  kdepth, kmax, 3, .92

 atemp    delayr  5;(i(kdelay) + i(kdepth) +.1)
 a01      deltapi  kdelay + alfo01
 a02      deltapi  kdelay + alfo02
 a03      deltapi  kdelay + alfo03
 a04      deltapi  kdelay + alfo04
 a05      deltapi  kdelay + alfo05
 a06      deltapi  kdelay + alfo06
 a07      deltapi  kdelay + alfo07
 a08      deltapi  kdelay + alfo08
 a09      deltapi  kdelay + alfo09
 a10      deltapi  kdelay + alfo10
 a11      deltapi  kdelay + alfo11
 a12      deltapi  kdelay + alfo12
          delayw  ain
;rireturn
          
aoutL = (a01+a02*.95+a03*.9+a04*.85+a05*.79+a06*.74+a07*.67+a08*.6+a09*.52+a10*.42+a11*.3)
aoutR = (a02*.3+a03*.42+a04*.52+a05*.6+a06*.67+a07*.74+a08*.79+a09*.85+a10*.9+a11*.95+a12)
          
 outs aoutL, aoutR
 
 endin
 
</CsInstruments>
<CsScore>
f3 0 8193 7 -1 4096 1 4096 -1      ; Triangle

i1  0.00  60000
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
  <uuid>{ede9a0e5-e014-4835-b7af-440e537452cb}</uuid>
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
