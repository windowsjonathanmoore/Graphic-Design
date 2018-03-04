<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
;---------------------------------------------------------------------/
;	Nicola Moro									   /
;	NYU spring 2005											   /
;---------------------------------------------------------------------/
;GENERATES INSTANT AND RANDOM "AMBIENT" SOUNDS
nchnls=2

maxalloc 1, 8
maxalloc 3, 16

instr 1
	kfire init 1
	kdrip init 1
	gktime init 0
	kenv init 0
	ifund=159
	kread		linseg 0, p3, 1
	kmenv		table	kread, 3, 1, 0
	kmenv=kmenv*kmenv
	ktempo	table kread, 1, 1, 0	
;	ktempo	pow 2,(kread*8)
	kspeed=240*ktempo*4/60
	kphasor	phasor kspeed, 0

	kfreqread	randi 0.5,kspeed,0,0,0.5
	kfreqread=kfreqread*kfreqread
	kfreq		table kfreqread,5,1,0,1
	kpanspeed	jitter 3,0.4,2
	;ktime	line	0,p3,p3
	
	if (kphasor>0.9 && kdrip==1) then
		event "i",3, 0, 7, 1., kfreq*ifund, kpanspeed
		fprintks "my.sco", "i3\\t%2.2f\\t7\\t1\\t%2.2f\\t%2.2f\\n",gktime,kfreq*ifund,kpanspeed
		kdrip=0
	elseif (kphasor<=0.9) then	
		kdrip=1
	endif
	kpan	randi	0.5,kspeed*2,0,0.5
	anoise noise 32767, 1
	if (kread>=0.125 && kfire==1) then
		kfire=0
		event "i",1,0,20
	endif
	anoise	butterbp	anoise,400,10
	anoise	butterbp 	anoise,400,10
	anoise=anoise*10	
	outs	anoise*kenv*kmenv,anoise*kenv*kmenv
endin

instr 2
a1=0
gktime	line 0,p3,p3
outs	a1,a1
endin

instr 3
kenv	linseg 0,p3*0.3,1,p3*0.1,0.2,p3*0.6,0
kpan	randi 0.5,p6,0,0.1,0.5
kfreq	jitter	0.008*p5,0.3,4
kfreq2 jitter	kfreq,0.3,7
a1 oscil p4, p5+kfreq,2
a2 oscil p4,p5+kfreq2,2
a1=(a1+a2)*1000.*kenv
outs a1*kpan,a1*(1-kpan)
endin
</CsInstruments>
<CsScore>
;f1 0 4096 7  0.0625 1024 0.125 1024 0.25 1024 0.5 1024 1. 1024
f1 0 8192 7 0.00078125 1024 0.015625 1024 0.03125 1024 0.0625 1024 0.125 1024 0.25 1024 0.5 1024 1. 1024 2.
f2 0 4096 10 1
f3 0 2049 1  "bellfunc.aif" 0 0 0    
f4 0 4096 5 0.0001 1024 1 2048 1 1024 0.0001
f5 0 16 -2 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
;i0 0 600

i2 0 12
i1 0 10
</CsScore>

</CsoundSynthesizer>
