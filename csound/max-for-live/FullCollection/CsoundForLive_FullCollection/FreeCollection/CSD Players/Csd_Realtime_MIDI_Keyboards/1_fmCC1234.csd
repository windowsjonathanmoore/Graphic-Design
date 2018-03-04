<CsoundSynthesizer>

<CsOptions>
</CsOptions>

<CsInstruments>
nchnls	=	2

massign 1, 1

ctrlinit	1, 1,100, 2,10, 3,2, 4,5

instr	1
icps	cpsmidi

kamp	midic7	1, 0, 10000
kamp  port kamp,.1
kcar	midic7	2, 1, 10
kmod	midic7	3, 1, 10
kindx	midic7	4, 1, 30
kindx	port kindx,.1

asig	foscil	kamp, icps, (kcar), (kmod), kindx, 1
kmgate	linsegr	0, .01, 1, 2, 0
outs	asig*kmgate, asig*kmgate
endin
</CsInstruments>
<CsScore>
f1	0	8192	10	1
f2 0 1024 7 	-1 1024 1
f0	60000
e
</CsScore>
</CsoundSynthesizer>

