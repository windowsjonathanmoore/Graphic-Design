;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Wah-Wah
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
sr		=	44100
ksmps		=	32
nchnls	=	2
0dbfs		=	1

giWave1		ftgen		1,0, 16384,10, 1	

instr 1
ktrig	metro	100
if (ktrig == 1)	then
gkrate chnget "rate" 
gkdepth chnget "depth" 
gkwet chnget "wet"
gkrestune chnget "resonance"
gkdist chnget "dist"

endif
kevent init 1
if (kevent == 1) then
kevent = 7
event "i", 2, 0, 60000
endif
endin


          instr     2
krate     tonek gkrate, 10   
kdepth    tonek gkdepth, 10
kwet	    tonek gkwet, 10
krestune tonek gkrestune, 10
kdist tonek gkdist, 10

ilow      =         200           
ifmix     =         .5/1000      
     
kosc1     oscili    .5, krate, 1, .25    
kosc2     =         kosc1 + .5                 
kosc3     =         kosc2                     
     
klopass   =         kdepth*kosc2+ilow       
kform1    =         430*kosc2 + 300              
kamp1     =         ampdb(-2*kosc3 + 59)*ifmix   
kform2    =         220*kosc2 + 870              
kamp2     =         ampdb(-14*kosc3 + 55)*ifmix  
kform3    =         200*kosc2 + 2240             
kamp3     =         ampdb(-15*kosc3 + 32)*ifmix  

ainL, ainR ins

afiltL     lpf18 ainL, klopass, krestune, kdist*10  
afiltR     lpf18 ainR, klopass, krestune, kdist*10  

ares1     reson     afiltL, kform1, kform1/8   
ares2     reson     afiltL, kform2, kform1/8   
ares3     reson     afiltL, kform3, kform1/8   

ares1R     reson     afiltR, kform1, kform1/8   
ares2R     reson     afiltR, kform2, kform1/8   
ares3R     reson     afiltR, kform3, kform1/8   

aresbal1  balance   ares1, afiltL       
aresbal2  balance   ares2, afiltL
aresbal3  balance   ares3, afiltL

aresbal1R  balance   ares1R, afiltR     
aresbal2R  balance   ares2R, afiltR
aresbal3R  balance   ares3R, afiltR

aoutL = afiltL+kamp1*aresbal1+kamp2*aresbal2+kamp3*aresbal3
aoutR = afiltR+kamp1*aresbal1R+kamp2*aresbal2R+kamp3*aresbal3R

aoutL balance aoutL, ainL
aoutR balance aoutR, ainR

aoutL ntrpol ainL, aoutL, kwet
aoutR ntrpol ainR, aoutR, kwet

outs      aoutL, aoutR      
endin
          
          

</CsInstruments>
<CsScore>
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
  <uuid>{e998d89a-6c81-4554-97f3-3bb15e97fd13}</uuid>
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
