;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Clavitar
;;	by Hans Mikelson
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

sr        	=   	44100
ksmps     	=   	256
nchnls    	=   	2
0dbfs		=	1

turnon 22

zakinit   50, 50
turnon 10
turnon 16
turnon 99



turnon 11
instr 11
ktrig	metro	100
if (ktrig == 1)	then
gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkpregn     chnget "pregn" 
gkrate	chnget "rate" 
endif
endin


;;Plucked Instrument
        instr   1
kamp      	= 1 
giamp ampmidi 1
;Tuning Block:
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq = cpsmidinn(imidinn + gksemi + kcent + gkbend)     
itab1     =         0
ioutch    =         1                 

asig      pluck     kamp, kfrq, i(kfrq), itab1, 1     
          zawm      asig, ioutch          

          endin

;;Distortion:
          instr     10


idur      =         .4

kpregn tonek (gkpregn/1000), 10

kpostg    =         .5*20000  
ka1       =         (.01-.5)/8000       
ka2       =         (0-.5)/8000 
iinch     =         1  
ioutch    =         2 
ioutlvl   =         .05  
                    
kdclick   madsr    0.1, 0, 1, 0.5 

asig      zar       iinch

ax1       =         asig*(kpregn+ka1) 
ax2       =         -asig*(kpregn+ka2)
ax3       =         asig*kpregn

aout      =         (exp(ax1)-exp(ax2))/(exp(ax3)+exp(-ax3))*kpostg  

          zaw       aout*kdclick, ioutch 
          
       aoutL   clip aout*kdclick*ioutlvl*giamp, 0, .75
       aoutR   clip aout*kdclick*ioutlvl*giamp, 0, .75
          
aoutL dcblock2 aoutL
aoutR dcblock2 aoutR
          outs      aoutL*.1, aoutR*.1
          

          endin
;;WahWah:
          instr     16


krate     tonek         gkrate , 10
idepth    =         4000 
ilow      =         200 
ifmix     =         .5/1000
itab1     =         1  
izin      =         2
     
kosc1     oscil     .5, krate, itab1, .25
kosc2     =         kosc1 + .5                
kosc3     =         kosc2                   
     
klopass   =         idepth*kosc2+ilow       
kform1    =         430*kosc2 + 300  
kamp1     =         ampdb(-2*kosc3 + 59)*ifmix 
kform2    =         220*kosc2 + 870      
kamp2     =         ampdb(-14*kosc3 + 55)*ifmix 
kform3    =         200*kosc2 + 2240           
kamp3     =         ampdb(-15*kosc3 + 32)*ifmix 

asig      zar       izin                 

afilt     butterlp  asig, klopass             

ares1     reson     afilt, kform1, kform1/8   
ares2     reson     afilt, kform2, kform1/8   
ares3     reson     afilt, kform3, kform1/8  

aresbal1  balance   ares1, afilt               
aresbal2  balance   ares2, afilt
aresbal3  balance   ares3, afilt

aout      =         afilt+kamp1*aresbal1+kamp2*aresbal2+kamp3*aresbal3

aoutL clip aout*.02, 0, .75
aoutR clip aout*.02, 0, .75

aoutL dcblock2 aoutL
aoutR dcblock2 aoutR
          outs      aoutL*giamp, aoutR*giamp
          
          

          endin

          instr     99
          zacl      0, 50
          zkcl      0, 50
          endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 22
kinstr init 1
kactive active kinstr
if kactive > 24 then
turnoff2 kinstr, 1, 0
endif
endin

</CsInstruments>
<CsScore>

f1 0 8192 10 1
f2 0 8192 11 20
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
  <r>0</r>
  <g>0</g>
  <b>0</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
