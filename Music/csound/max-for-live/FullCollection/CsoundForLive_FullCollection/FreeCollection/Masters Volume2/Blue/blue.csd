;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Blue
;;	by Richard Boulanger
;;		from ""Trapped in Convert - 1979"
;;	
;;	Adapted for CsoundForLive by Colman O'Reilly
;;	www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr        	= 	44100
ksmps    	= 	128
nchnls   	= 	2
0dbfs  	= 	1

garvb init 0
turnon 10
turnon 22
instr 10


ktrig	metro	100
if (ktrig == 1)	then

gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkvoices chnget "voices"

gkp8 chnget "shaker"
gkp9 chnget "harmrange"  
gkp10 chnget "arpspeed"
gkp3 chnget "dur"

gkp7 chnget "reverb" 
gkpan chnget "revpan" 

gkatt chnget "att"
gkdec chnget "dec"
gksus chnget "sus"
gkrel chnget "rel"

gkspread chnget "spread"
gkdetune chnget "detune"

endif
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


               instr     1
;Tuning Block:
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
iamp ampmidi 1
iamp = iamp*.5

k1             randi     1, 30                              
k2             linseg    0, i(gkp3) * .5, 1, i(gkp3) * .5, 0     
k3             linseg    .005, i(gkp3) * .71, .015, i(gkp3) * .29, .01
k4             oscil     k2, gkp8, 1, .2               
k5             =         k4 + 2

ksweep         linseg    i(gkp9), i(gkp3) * i(gkp10), 1, i(gkp3) * (i(gkp3) - (i(gkp3) * i(gkp10))), 1
kenv 		madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)

aout1           gbuzz     kenv*iamp, kfrq + k3, k5, ksweep, k1, 15
aout2           gbuzz     kenv*iamp, kfrq2 + k3, k5, ksweep, k1, 15
    
;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout1 * (1-gkspread)) + (aout2 * gkspread))   *.5     
     
     
               outs      aoutL, aoutR
               amix = (aoutL + aoutR)* .5
garvb          =         garvb + (amix * gkp7) 
               endin

               instr     99
k1             oscil     .5, gkpan, 1
k2             =         .5 + k1
k3             =         1 - k2
asig           reverb    garvb, 2.1

asig dcblock2 asig
               outs      asig * k2*0.25, (asig * k3) * (-1) * 0.25
garvb          =         0
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
f1   0  8192  10   1
f2   0  512   10   10  8   0   6   0   4   0   1
f3   0  512   10   10  0   5   5   0   4   3   0   1
f4   0  2048  10   10  0   9   0   0   8   0   7   0  4  0  2  0  1
f5   0  2048  10   5   3   2   1   0
f6   0  2048  10   8   10  7   4   3   1
f7   0  2048  10   7   9   11  4   2   0   1   1
f8   0  2048  10   0   0   0   0   7   0   0   0   0  2  0  0  0  1  1
f9   0  2048  10   10  9   8   7   6   5   4   3   2  1
f10  0  2048  10   10  0   9   0   8   0   7   0   6  0  5
f11  0  2048  10   10  10  9   0   0   0   3   2   0  0  1
f12  0  2048  10   10  0   0   0   5   0   0   0   0  0  3
f13  0  2048  10   10  0   0   0   0   3   1
f14  0  512   9    1   3   0   3   1   0   9  .333   180
f15  0  8192  9    1   1   90 
f16  0  2048  9    1   3   0   3   1   0   6   1   0
f17  0  9     5   .1   8   1
f18  0  17    5   .1   10  1   6  .4
f19  0  16    2    1   7   10  7   6   5   4   2   1   1  1  1  1  1  1  1
f20  0  16   -2    0   30  40  45  50  40  30  20  10  5  4  3  2  1  0  0  0
f21  0  16   -2    0   20  15  10  9   8   7   6   5   4  3  2  1  0  0
f22  0  9    -2   .001 .004 .007 .003 .002 .005 .009 .006
i99  0   600000
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
