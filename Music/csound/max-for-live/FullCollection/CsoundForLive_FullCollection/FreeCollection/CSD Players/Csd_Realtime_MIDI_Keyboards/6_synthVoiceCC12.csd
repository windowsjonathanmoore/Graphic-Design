<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
nchnls = 2

garvb init 0

ctrlinit 1, 1,100, 2,37

maxalloc 1, 3

instr    1 ; Random vowel FOF instrument

ilevl    ampmidi	1000  	     ; Output level
ipitch   cpsmidi				 ; Pitch

ivibr    = 4		             ; Vibrato rate
ivibd    = 10		             ; Vibrato depth
irate    = .5 		        	 ; Random vowel rate
idet     = .5		        	 ; Detune
ileng    = 10

kvol	midic7	1, 0, 1
kverb	midic7	2, 0, .61

kmidienv madsr .02, .2, .9, .2
kenv     linseg  0, .1, 1, ileng, 1, .1, 0
iseed    = rnd(1)
k1       randi  .5, irate, iseed
k1       = k1 + .5
k2       linseg  0, 10, ivibd
k3       oscil  k2, ivibr, 1
k1f      table  k1, 11, 1
k2f      table  k1, 12, 1
k3f      table  k1, 13, 1
k4f      table  k1, 14, 1
k5f      table  k1, 15, 1
k1b      table  k1, 21, 1
k2b      table  k1, 22, 1
k3b      table  k1, 23, 1
k4b      table  k1, 24, 1
k5b      table  k1, 25, 1
kpitch   = ipitch + k3 + idet
a1       fof  1.0, kpitch, k1f, 0, k1b, .003, .02, .007, 1000, 1, 2, ileng
a2       fof  0.7, kpitch, k2f, 0, k2b, .003, .02, .007, 1000, 1, 2, ileng
a3       fof  0.5, kpitch, k3f, 0, k3b, .003, .02, .007, 1000, 1, 2, ileng
a4       fof  0.4, kpitch, k4f, 0, k4b, .003, .02, .007, 1000, 1, 2, ileng
a5       fof  0.3, kpitch, k5f, 0, k5b, .003, .02, .007, 1000, 1, 2, ileng
amix = (a1 + a2 + a3 + a4 + a5)*ilevl*kenv*kmidienv*kvol
outs      amix, amix

garvb		=		garvb+(amix*.5)
endin

;reverb instrument
instr 2
arev	nreverb	garvb, 2.1, .1
outs	arev, arev
garvb = 0
endin
</CsInstruments>
<CsScore>
f1 0 4096 10 1								 ; Sine
f2 0 1024 19 .5 .5 270 .5 						 ; Rising sigmoid
f11 0 1024 -7  600 256  400 256  250 256  400 256  350
f12 0 1024 -7 1040 256 1620 256 1750 256  750 256  600
f13 0 1024 -7 2250 256 2400 256 2600 256 2400 256 2400
f14 0 1024 -7 2450 256 2800 256 3050 256 2600 256 2675
f15 0 1024 -7 2750 256 3100 256 3340 256 2900 256 2950
f21 0 1024 -7   60 256   40 256   60 256   40 256   40
f22 0 1024 -7   70 256   80 256   90 256   80 256   80
f23 0 1024 -7  110 256  100 256  100 256  100 256  100
f24 0 1024 -7  120 256  120 256  120 256  120 256  120
f25 0 1024 -7  130 256  120 256  120 256  120 256  120

i2    0.00  60000
e
</CsScore>
</CsoundSynthesizer>
