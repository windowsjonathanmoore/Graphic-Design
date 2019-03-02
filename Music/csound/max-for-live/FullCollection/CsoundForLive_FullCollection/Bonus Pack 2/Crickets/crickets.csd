;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Crickets	
;;	by Hans Mikelson 1999
;;
;;	Adapted for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


<CsoundSynthesizer>
<CsInstruments>

sr	= 44100
kr	= 441
ksmps	= 100
nchnls = 2 
0dbfs = 1

turnon 10
turnon 22

instr 10
ktrig	metro	100
if (ktrig == 1)	then

gkloop chnget "loop"
gkrand chnget "rand"

endif
endin


instr          1
;; Added randomness to amplitude
ktrig metro gkrand
if ktrig == 1 then
kramp rand 1
;kramp = kramp + .5
endif

if gkrand == 0 then
kramp = 1
endif


iamp  ampmidi 1                 ; AMPLITUDE

ifqc cpsmidi

ifqc = ifqc*.001                  ; FREQUENCY MODIFICATION

ipuls          =              2                 ; PULSE TABLE

iftab          =              3                  ; FREQUENCY TABLE


iltab          =              4                  ; LOOP TABLE

ilpetab        =              8                 ; LOOP ENVELOPE TABLE

ifetab         =              6                 ; FREQUENCY ENVELOPE TABLE

ibasef         =              19                  ; BASE PULSE FREQUENCY


iv             =              iamp/10000          ; HIGH SHELF LEVEL
 

kaf            oscili         2, 1/gkloop, iltab        ; PULSE ENVELOPE FM
kamp1          oscili         1, 1/gkloop, ilpetab      ; LOOP ENVELOPE

kfenv          oscili         1, 1/gkloop, ifetab       ; LOOP FREQUENCY ENVELOPE

     

kamp2          oscili         1, ibasef*kaf, ipuls     ; GENERATE PULSE STREAM

kamp           =              sqrt(kamp1*kamp2)        ; MAKE IT ROUNDED
 

kfqc1          oscil          4800*kfenv*ifqc, ibasef*kaf, iftab      ; FUNDAMENTAL FQC

kfqc2          oscil          9500*kfenv*ifqc, ibasef*kaf, iftab      ; OVERTONE
 

kdclck         linsegr         0, .005, 1, 0.1, .001       ; DECLICK ENVELOPE
 

afnd           oscil          kamp, kfqc1, 1                          ; FUNDAMENTAL OSCILLATOR

ahrm           oscil          kamp, kfqc2, 1                          ; OVERTONE OSCILLATOR
 

aout           pareq          (afnd+ahrm*.04)*iamp*kdclck, 7000, iv, .707, 2    ; SET HIGH SHELF FILTER LOW FOR DISTANT CRICKETS
 

               outs           aout*kramp, aout*kramp                  ; OUTPUT THE SOUND WITH PANNING
 

               endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 22
kinstr init 1
kactive active kinstr
if kactive > 24 then
turnoff2 kinstr, 1, 0.1
endif
endin 

</CsInstruments>
<CsScore>
; SCO

f1 0 65536 10 1

f2 0 1024  7  0 306 1   306 0   412 0

f3 0 1024  7  1 153 .97 153 .92 306 .85 412 1

f4 0 1024  7  1  43 1    10  .5  961 .5 10 1

f5 0 1024  7  .5 43 .5   10  .8  240 1 10 0 721 0 10 .5     ; LOOP ENVELOPE

f8 0 1024  7  .5 43 .5   10  .8  300 1 10 0 661 0 10 .5     ; LOOP ENVELOPE

f6 0 1024  7  .9 43 .9   10  1   961 1 10  .9

f7 0 1024  7  1 1024 1
 

; CRICKET

;    Sta  Dur   Amp    Fqc  PlsTab  FqcTab  Loop  LoopFM   LoopEnv  FqcEnv Pan

f0 60000
;i14  0 30   3200   .858             

;i14 0.75 30     5300   1.05 2       3       .6    4        8        6     .8
e
i14  1.5 30    3500   .992 2       3       .6    4        5        6     .6


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
  <uuid>{94c0db92-c7dc-4984-acaa-343295594db9}</uuid>
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
