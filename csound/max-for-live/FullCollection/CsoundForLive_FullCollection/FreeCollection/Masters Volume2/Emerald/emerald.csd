;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Emerald
;;	A real-time adaptation of "Green"
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
0dbfs = 1

garvb          init      0
turnon 1
turnon 2
massign 1, 3
              ; ctrlinit  1, 7,100, 3,64, 13,64, 14,90, 15,64, 16,30
instr 1


ktrig	metro	100
if (ktrig == 1)	then

gkcenttmp chnget "cents"
gksemi chnget "semitones"
gkvoices chnget "voices"

gkp11 chnget "index"  
gkp9 chnget "carrier" ;0 to 5
gkp3 chnget "rate" ; 1 to 20
gkp10 chnget "modfreq"
gkp8 chnget "pan"

gkrev chnget "reverb" ; 1 to 22
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
instr 2
kinstr init 3
kactive active kinstr
if kactive > gkvoices then
turnoff2 kinstr, 1, 0
endif
endin



               instr     3       



; p6 = AMP    
; p7 = REVERB SEND FACTOR
; p8 = PAN DIRECTION
; ... (1.0 = L -> R, 0.1 = R -> L)
; p9 = CARRIER FREQ
; p10 = MODULATOR FREQ
; p11 = MODULATION INDEX
; p12 = RAND FREQ

;ip3            = 1 ;midic7    16, 1,10

;Tuning Block:
gkbend pchbend 0, 2
imidinn notnum
kcent = gkcenttmp * 0.01
kfrq1 = cpsmidinn(imidinn + gksemi + kcent + gkbend)
kfrq2 = cpsmidinn(imidinn + gksemi + kcent + gkdetune + gkbend)
iamp ampmidi 1
iamp = iamp*.15


ip6         = 1;   midic7    7, 0, 2000
;kp7            midic7    9, 0, 1
ip8       = 1;     midic7    10, .1, 1
ip9       = 4;     midic7    11, 1, 10
ip9            =         int(ip9)
;ip10      = 2;     midic7    12, 1, 10
;ip10           =         int(ip10)
;kp11      = 1;     midic7    13, 1, 10
ip12      = 1;     midic7    14, 1, 10


;k1             line      ip9, i(gkp3), 1 
k1	linsegr i(gkp9), i(gkp3), 1, 1, 1, 0, 0.001                    

k2		    madsr i(gkp3), .1, i(gkp10), 1
;k2             line      1, i(gkp3), i(gkp10)                      

k4             expsegr     2, i(gkp3), ip12, i(gkp3), 2, 0, 0.001                    
k5             linsegr    0, i(gkp3) * .8, 8, i(gkp3) * .2, 8, 0, 0.001     
k7             randh     gkp11, k4                                         
k6             oscil     k4, k5, 1, .3    

kenv1 		madsr i(gkatt), i(gkdec), i(gksus), i(gkrel)
;                        xamp, xcps,       xcar, xmod, kndx, ifn [,iphs]
a1             foscil    kenv1, kfrq1 + k6, k1, k2, k7, 1
a2             foscil    kenv1, kfrq2 + k6, k1, k2, k7, 1


kpan           linsegr    int(i(gkp8)), i(gkp3) * .7, frac(i(gkp8)), p3 * .3, int(i(gkp8)), 0, 0.001

kmgate   = 1   ;    linsegr   0, .1, 1, 1, 0


aout1 = a1 * kpan * kmgate
aout2 = a2 * (1 - kpan) * kmgate

;;Spread Section:
aoutL = ((aout1 * gkspread) + (aout2 * (1 - gkspread))) *.5  
aoutR = ((aout2 * (1-gkspread)) + (aout2 * gkspread))   *.5 


               outs      aoutL* iamp, aoutR* iamp
garvb          =         garvb + (a1 * .5)
               endin


               instr     99                                               ; P4 = PANRATE
iamp = .5
k1             oscil     .5, gkpan, 1
k2             =         .5 + k1
k3             =         1 - k2
asig           reverb    garvb, 2.1
asig dcblock2 asig
               outs      asig * k2*gkrev*iamp, (asig * k3) * (-1)*gkrev*iamp
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

f0   60000

i99  0   60000     32
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
