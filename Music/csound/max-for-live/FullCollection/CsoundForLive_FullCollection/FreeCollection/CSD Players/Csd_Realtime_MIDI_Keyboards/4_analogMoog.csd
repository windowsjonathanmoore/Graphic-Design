<CsoundSynthesizer>

<CsOptions>
</CsOptions>

<CsInstruments>

nchnls = 2
gisin    ftgen    1, 0, 16384, 10, 1

         ctrlinit 1, 1,64, 2,64

         instr    1
           ; Scale the amplitude to 32768.
iscale = 0dbfs
iamp     ampmidi  0dbfs
icps     cpsmidi
kfiltfrq midic7   1,100,2000
kfiltres midic7   2,.01,.75
kfrqmod  madsr    .1,.3,.5,.2
kampenv  madsr    .01, .2, .6, .5
aosc     vco      kampenv, icps, 1
afilt    moogvcf  aosc, 100+kfiltfrq*kfrqmod, kfiltres, iscale
         out      afilt*iamp, afilt*iamp
         endin
          
</CsInstruments>

<CsScore>
f0 60000
</CsScore>

</CsoundSynthesizer>
