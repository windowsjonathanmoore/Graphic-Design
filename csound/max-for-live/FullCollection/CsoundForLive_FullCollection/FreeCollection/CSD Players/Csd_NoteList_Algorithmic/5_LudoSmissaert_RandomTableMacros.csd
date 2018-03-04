<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>
nchnls    =         2
/*************************************************************/
/*	Horizontal Csound Composing (HCC)                    
/*                                                           
/*	coded by:	Ludikidee  (Ludo Smissaert)          
/*	date:		4 oct 2003		             
/*	based on:	Drummach by Hans Mikelson          
/*	version 1.01    with macros                          
/*                                                           
/*************************************************************/
	instr	1

;macro defenitions, personally i would say, put them in a file 
;and use #include "macros" (they are not ment to be easy readable :-)

#define INIT(A) #$A_ind init 0#
#define TABLE(A' B') #$A table $A_ind, $B. 
$A0 table $A_ind+1, $B.#
#define NEXT(A) #$A_ind = ($A0 == 0 ? 0 : $A_ind + 1)#
#define INIT_RHYTHM(A' B') #$A_ind init 0.
$B_ind init 1.#
#define TABLE_RHYTHM(A' B' C') #$A table $A_ind, $C.
$A0 table $A_ind+2, $C.
$B table $B_ind, $C.
$B0 table $B_ind+2, $C.#
#define NEXT_RHYTHM(A' B') #$A_ind = ($A0 == -1 ? 0 : $A_ind + 2)
$B_ind = ($B0 == -1 ? 1 : $B_ind + 2)#

;end macro defenitions, below is ment to be easy readable

$INIT_RHYTHM(idur' irst')
$INIT(ipch)
$INIT(indx)
$INIT(iamp)
$INIT(ipan)

synth:

$TABLE_RHYTHM(idur' irst' p4')
$TABLE(ipch' p5')
$TABLE(indx' p6')
$TABLE(iamp' p7')
$TABLE(ipan' p8')

kenv	oscil1	0, iamp*25000, (1/idur), 3	;oscil1!!!
asig1	foscil	kenv, cpspch(ipch), .0125, .6, indx, 1
asig2	foscil	kenv, cpspch(ipch)*.99, .0125, .6, indx, 1
asig3	foscil	kenv, cpspch(ipch)*1.01, .0125, .6, indx, 1

asig	=	(asig1+asig2+asig3)/3

timout	0, (1/idur+irst), output

$NEXT_RHYTHM(idur' irst')
$NEXT(ipch)
$NEXT(indx)
$NEXT(iamp)
$NEXT(ipan)
reinit synth
output:
	outs	asig*(1-ipan), asig*ipan
endin
</CsInstruments>

<CsScore>
f1 0 4096 10 1                   ; Sine
f3 0 513 7 0 56 1 200 .8 256 0   ; env
;		note	rest	note	rest	note	rest
f101 0 32 -2	12	.02	12	.01	12	0	
		8	0	8	.1	8	.25 
		4	0	16	.02	16	0
		16	0	16	0	16	.02
		16	0	16	.05	16	0	-1	-1
f102 0 32 -2	7.01  	9.01  	6.06	7.06  	8.11	8.06	9.06	;pitches
f103 0 32 -2	10	3	11	3	4		;fm indexes
f104 0 32 -2	1.7	.5	1.7	.5	.5		;relative amps
f105 0 32 -2	.5	.2	.5	.6	-1		;pan pos
;p1	p2	p3	p4	p5	p6	p7	p8
;i	s	d	dur	pch	indx	iamp	pan
i1	0	20	101	102	103	104	105
e
</CsScore>

</CsoundSynthesizer>
