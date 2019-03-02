;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	SpectralMincer
;;		based on the work of Victor Lazzarini
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
ksmps = 16
nchnls = 2
0dbfs = 1

turnon 1

instr 1
ktrig	metro	100
if (ktrig == 1)	then

gkdur	 chnget "dur"
gkpitch	chnget "pitch"
gklock	= 1 ;chnget "lock"
gktimescale chnget "timescale"
gkdecim	chnget "decim"
kchange chnget "change"
gksamples = int(gkdur*sr)
endif

kSwitch changed kchange
if kSwitch == 1 then
turnoff2 2, 0, 0
endif

;i(gksamples)
endin

instr 2
gSfilename chnget "filename"
gitab ftgen 1, 0, 0, 1, gSfilename, 0, 0, 0
ichn filenchnls gSfilename

kpitch tonek gkpitch, 20

kSwitch changed gktimescale, gkdecim
if kSwitch=1 then	
reinit START	
endif

START:
atime line 0, i(gkdur),i(gkdur)*i(gktimescale)

if ichn == 1 then

aoutL mincer atime, .9, kpitch, 1, 1, 4096, i(gkdecim)
aoutR = aoutL
else
aoutL, aoutR mincer atime, .9, gkpitch, 1, 1, 4096, i(gkdecim)
endif
rireturn

aoutL clip aoutL, 0, .99
aoutR clip aoutR, 0, .99

outs aoutL, aoutR
endin


instr 3
turnoff2 2, 0, 0
gSfilename chnget "filename" ;redundancy to make sure gSfilename always has a value.
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
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBConsole">
  <objectName/>
  <x>10</x>
  <y>10</y>
  <width>400</width>
  <height>500</height>
  <uuid>{f1a97649-0415-4d46-bf1d-cf21a15774f8}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <font>Courier</font>
  <fontsize>8</fontsize>
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
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
