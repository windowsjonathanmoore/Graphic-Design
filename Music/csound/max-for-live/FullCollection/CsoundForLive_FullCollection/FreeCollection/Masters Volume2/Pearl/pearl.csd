;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Pearl
;;	A real-time adaptation of "Ivory"
;;		by Richard Boulanger
;;		from "Trapped in Convert - 1979"
;;	
;;	Adapted for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr             =         44100
kr             =         441
ksmps          =         100
nchnls         =         2
0dbfs		= 1

turnon 1
turnon 2

massign 1, 3

gif1 ftgen 1, 0, 8192, 10, 1
gif2 ftgen 9, 0, 2048, 10, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
gif3 ftgen 11, 0, 2048, 10, 10, 10, 9, 0, 0, 0, 3, 2, 0, 0, 1
gif4 ftgen 12, 0, 2048, 10, 10, 0, 0, 0, 5, 0, 0, 0, 0, 0, 3
          
instr 1

ktrig	metro	100
if (ktrig == 1)	then

gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"

gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkvoices chnget "voices"
gkspread chnget "spread"
gkdetune chnget "detune"

gkp8 chnget "delay"		; 1 to 5
gkp9 chnget "glissratio"  ;.999 to .888
gkvibfrq chnget "vibfrq" ; 1 to 22
gkvibdep chnget "vibdep" ;0 to 5
gkdur chnget "dur" ; 1 to 20

endif
endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Voice "Stealing" Instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 2
kinstr init 3
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin

               instr     3
;Tuning Block:
    gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
iamp ampmidi 1

iamp = iamp*.5
                            
kfrq          =         kfrq1 + (kfrq1 * .0001)                

;iamp           midic7    7, 0, 2000          ; CONTROLLER 7 = AMP


gkdur = 10

        
kglis       expseg    1, i(gkp8), 1, i(gkp8)*2, i(gkp9), 1600, i(gkp9)      

k1       = 1;   linenr 5, i(gkdur), 1, 0;      0, i(kdur), 5                     
k2             oscil     k1*gkvibdep, gkvibfrq, 1                    
k3             linsegr 0, .7, iamp, .3, iamp, 0, 0.001;    0, i(kdur) * .7, iamp, i(kdur) * .3, 0   
a1             oscil     k3, (kfrq + k2) * kglis, 1     

k4       linsegr 0, .6, 6, .4, 0.001 ;   linseg    0, i(kdur) * .6, 6, i(kdur) * .4, 0
k5             oscil     k4*gkvibdep, gkvibfrq * .9, 1, 1.4
k6       linsegr 0, .9, iamp, .1, iamp, 0, 0.001;     linseg    0, i(kdur) * .9, iamp, i(kdur) * .1, 0
a3             oscil     k6, ((kfrq + .009) + k5) * kglis, 9, .2
     
k10      expsegr  1, .99, 3.1, 0.1, 3.1, 0, .001  ;   expseg    1, i(kdur) * .99, 3.1, i(kdur) * .01, 3.1
k11            oscil     k10*gkvibdep, gkvibfrq * .97, 1, .6
k12      expsegr .001, .8, iamp, .002, iamp, 0, 0.001 ;      expseg    .001, i(kdur) * .8, iamp, i(kdur) * .2, .001
a7             oscil     k12,((kfrq2 + .005) + k11) * kglis, 11, .5

k13        expsegr 1, .4, 3,1, 3, 0, .001;      expseg    1, i(kdur) * .4, 3, i(kdur) * .6, .02
k14            oscil     k13*gkvibdep, gkvibfrq * .99, 1, .4
k15      =1 ;      expseg    .001, i(kdur) *.5, iamp, i(kdur) *.1, iamp *.6, i(kdur) *.2, iamp *.97, i(kdur) *.2, .001
a9             oscil     k15, ((kfrq2 + .003) + k14) * kglis, 12, .8

     kmgate madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
     
     aout1 = (a1 + a3) * kmgate
     aout2 = (a7 + a9) * kmgate
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5 
     
               outs aoutL, aoutR      
               endin

</CsInstruments>
<CsScore>
;==============================================================================;
;==============================================================================;
;                            == TRAPPED IN CONVERT ==                          ;
;                                Richard Boulanger                             ;
;==============================================================================; 
;==============================================================================; 
; i1:  p6=amp,p7=vibrat,p8=glisdeltime (default < 1),p9=frqdrop                ;
; i2:  p6=amp,p7=rvbsnd,p8=lfofrq,p9=num of harmonics,p10=sweeprate            ;
; i3:  p6=amp,p7=rvbsnd,p8=rndfrq                                              ;
; i4:  p6=amp,p7=fltrswp:strtval,p8=fltrswp:endval,p9=bdwth,p10=rvbsnd         ;
; i5:  p6=amp,p7=rvbatn,p8=pan:1.0,p9=carfrq,p10=modfrq,p11=modndx,p12=rndfrq  ;
; i6:  p5=swpfrq:strt,p6=swpfrq:end,p7=bndwth,p8=rvbsnd,p9=amp                 ;
; i7:  p4=amp,p5=frq,p6=strtphse,p7=endphse,p8=ctrlamp(.1-1),p9=ctrlfnc        ;
;             p10=audfnc(f2,f3,f14,p11=rvbsnd                                  ;
; i8:  p4=amp,p5=swpstrt,p6=swpend,p7=bndwt,p8=rnd1:cps,p9=rnd2:cps,p10=rvbsnd ;
; i9:  p4=delsnd,p5=frq,p6=amp,p7=rvbsnd,p8=rndamp,p9=rndfrq                   ;
; i10: p4=0,p5=frq,p6=amp,p7=rvbsnd,p8=rndamp,p9=rndfrq                        ;
; i11: p4=delsnd,p5=frq,p6=amp,p7=rvbsnd                                       ;
; i12: p6=amp,p7=swpstrt,p8=swppeak,p9=bndwth,p10=rvbsnd                       ;
; i13: p6=amp,p7=vibrat,p8=dropfrq                                             ;
; i98: p2=strt,p3=dur                                                          ;
; i99: p4=pancps                                                               ;
;========================= FUNCTIONS ==========================================;

f0 600000
;i1 0   600000
;i22 0   600000
e
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
