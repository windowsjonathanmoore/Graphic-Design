;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	SnareBlock
;;	
;;	Adapted for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr      =        44100
ksmps   =        16 
nchnls  =        2
0dbfs	  = 		1

massign 1, 2
turnon 1
instr 1
ktrig	metro	1000
if (ktrig == 1)	then

gkswitch chnget "switch"

;;Snare Controls
gkspton chnget "springtone"
gkspq   chnget "springrez"
gkspdec chnget "splash"
gkphil  chnget "phil"

;;Block Controls
gkbw chnget "bw"
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"

endif

endin


       instr     2

if gkswitch == 0 then

ifqc cpsmidi

ifqc = (ifqc*.01) + abs(i(gksemi) +(i(gkcenttmp) * 0.01))

kspton = gkspton *.1
kspq   = gkspq
kspdec = gkspdec
kphil  = gkphil
idur   =         .25
iamp   =         .5
ipanl  =         sqrt(.5)
ipanr  =         sqrt(1-.5) 
irez   =         .9+1.3*.1  
ispmix =         1    

kdclk  linseg    1, idur-.002, 1, .002, 0 
aamp   linseg    1, .2/ifqc, 1, .2/ifqc, 0, idur-.002, 0 
aampr  expseg    .1, .002, 1, .2*ifqc, .005 

arnd   rand      1, .5, 1  
arnd    =        (arnd-.5)*2*aampr   

ahp1    rezzy    arnd, 2700*kspton*ifqc, 5*kspq, 1
ahp2    butterbp arnd, 2000*kspton*ifqc, 500/kspq 
ahp3    butterbp arnd, 5400*kspton*ifqc, 500/kspq 
ahp     pareq    ahp1+ahp2*.7+ahp3*.3, 15000, .1, .707, 2 

aosc1   vco      1, 400, 2, 1, 1, 1
aosc    =        -aosc1*aamp        
aosc2   butterlp aosc, 12000       

asig1   moogvcf  aosc,    ifqc, .9*irez      
asig2   moogvcf  aosc*.5, ifqc*2.1, .75*irez 

aout   =         (asig1+asig2+aosc2*.1+ahp*ispmix)*iamp*kdclk*2
aout = aout*iamp

arevL, arevR reverbsc aout, aout, kphil, 12000

aoutL = ((aout - kphil) + arevL)*kdclk
aoutR = ((aout - kphil) + arevR)*kdclk

aoutL butterhp aoutL, 500
aoutR butterhp aoutR, 500
       outs      aoutL, aoutR  
       
elseif gkswitch == 1 then

imidinn notnum
kcent = gkcenttmp * 0.01
kcf = cpsmidinn(imidinn + gksemi + kcent)

kampenv madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
asig 	rand 	kampenv
afilt 	reson 	asig, kcf, gkbw
aout 	balance 	afilt, asig
outs 	aout*.8, aout*.8  
endif               
       endin


</CsInstruments>
<CsScore>
f1 0 65536 10 1
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
  <r>0</r>
  <g>0</g>
  <b>0</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
