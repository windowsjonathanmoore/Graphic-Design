;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Circular Pan
;;	From The Csound Catalog - The Cook Collection, 
;;		Instruments and Effects by Steven Cook
;;	
;;	Adapted for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
-old parser
<CsInstruments>
sr     = 44100
ksmps  = 16
nchnls = 2

turnon 10
instr 10
ktrig	metro	100
if (ktrig == 1)	then

gkrate    	chnget "krate"
gklr1    	chnget "klr"
gkfb1		chnget "kfb"
gkdir1	chnget "idir"
endif

kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 1, 0, 60000
endif
endin

instr    1
aL, aR ins

ain = aL+aR

ilevl    = 1   
krate tonek gkrate, 20
klr1 tonek gklr1, 20

klr      = klr1/2   

kfb1 tonek gkfb1, 20
kfb      = kfb1/2  
ipos     = 0/360

kdir1 tonek gkdir1, 20
kdir     = kdir1/2   
 
kSwitch	changed	kdir1
if kSwitch=1 then	
reinit START	
endif

START: 
klfo1    oscili  klr, krate, 1, ipos + i(kdir) 
klfo1    = klfo1 + .5                      
klfo2    oscili  kfb, krate, 1, ipos + .75  
klfo2    = 1 - (klfo2 + kfb)             
ain      = ain*klfo2                      
al       = ain*sqrt(klfo1)            
ar       = ain*sqrt(1 - klfo1)          
rireturn

outs     al*ilevl, ar*ilevl      
endin

 
</CsInstruments>
<CsScore>
f1 0 8193 10 1 ; Sine
f0 60000
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
  <uuid>{e1915e86-d647-4093-9942-47ee08ee00d2}</uuid>
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
