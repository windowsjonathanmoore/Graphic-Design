<CsoundSynthesizer>
<CsInstruments>
; ************************************************************************
; ACCCI:      40_02_1.ORC
; timbre:     clarinet-like
; synthesis:  waveshaping(40)
;             basic instrument with duration dependent envelope(02)
; source:     Risset(1969)
;             #150 Serial Excerpt with Clarinet-like Sounds by Nonlinearity
; coded:      jpg 8/93
sr = 44100
kr  =  44100
ksmps= 1
nchnls = 1
instr 1; *****************************************************************
idur  = p3
iamp  = p4
ifqc  = cpspch(p5)
idec  =  .64                             ; idec for idur > .75
if idur >.75 igoto start
idec  =  idur - .085                     ; idec for idur <= .75
start:
        aenv    linen    255, .085, idur, idec      ; envelope
        a1      oscili   aenv, ifqc, 1              ; sinus
        a1      tablei   a1  + 256, 31              ; transfer function
                out      a1 * iamp                  ; scale to amplitude
endin
</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   40_02_1.SCO
; source:  Risset (1969)
;          #150 Serial Excerpt with Clarinet-like Sounds by Nonlinearity
; coded:   jpg 8/93
; GEN functions **********************************************************
f1   0 2048 10 1                           ; sinus
f31  0  512  7 -1 200 -.5 112 .5 200 1     ; transfer function waveshaper
; score ******************************************************************
;           idur   iamp   ipch
i1  0.000   0.750  8000   7.04
i1  0.750   0.250  .      7.07
i1  1.000   1.000  .      8.00
i1  2.000   0.200  .      8.02
i1  2.200   0.200  .      8.04
i1  2.400   0.200  .      8.05
i1  2.600   0.200  .      9.00
i1  2.800   0.200  .      9.04
i1  3.000   0.250  .      9.05
i1  3.250   0.250  .      9.00
i1  3.500   0.250  .      8.05
i1  3.750   0.250  .      8.00
i1  4.000   1.000  .      7.04
i1  5.000   0.125  .      7.07
i1  5.125   0.125  .      8.00
i1  5.250   0.125  .      8.02
i1  5.375   0.125  .      8.04
i1  5.500   0.125  .      8.05
i1  5.625   0.125  .      9.00
i1  5.750   0.125  .      9.04
i1  5.875   0.125  .      9.05
e
</CsScore>
</CsoundSynthesizer>