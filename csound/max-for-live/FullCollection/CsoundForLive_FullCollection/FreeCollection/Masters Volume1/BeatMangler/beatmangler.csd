;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Beat Mangler
;;	
;;	by Jacob Joaquin & Jean-Luc Cohen-Sinclair
;;		October 3, 2010
;;		jacobjoaquin@gmail.com
;;		csoundblog.com	
;;
;;	Adapted for CsoundForLive by Colman O'Reilly
;;		www.csoundforlive.com
;;		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<CsoundSynthesizer>
<CsOptions>
-old parser
</CsOptions>
<CsInstruments>
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2
0dbfs = 1.0

# define loop_left  # 100 #
# define loop_right # 101 #


gibit init 0
gichnls init 0
gilength init 0
gisr init 0
gisize init 0

seed 0

turnon 1

instr 1
ktrig	metro	100
if (ktrig == 1)	then 
        
gkdur chnget "dur"
gkstuttermin chnget "min"
gkstuttermax chnget "max"
gkodds chnget "odds"
gkwin chnget "env"
gksteps chnget "steps"
kchange chnget "change"
endif


kSwitch changed kchange
if kSwitch == 1 then
turnoff2 2, 0, 0
kskip = 1
endif

giWin1		ftgen		3, 0, 4096, 20, 1, 1		; Hamming
giWin2		ftgen		4, 0, 4096, 20, 2, 1		; von Hann
giWin3		ftgen		5, 0, 4096, 20, 3, 1		; Triangle (Bartlett)
giWin4		ftgen		6, 0, 4096, 20, 4, 1		; Blackman (3-term)
giWin5		ftgen		7, 0, 4096, 20, 5, 1		; Blackman-Harris (4-term)
giWin6		ftgen		8, 0, 4096, 20, 6, 1		; Gauss
giWin7		ftgen		9, 0, 4096, 20, 7, 1, 6	; Kaiser
giWin8		ftgen		10, 0, 4096, 20, 8, 1		; Rectangle
giWin9		ftgen		11, 0, 4096, 20, 9, 1		; Sync  

endin


instr 2
    
gSfilename chnget "filename"     
isize = 1     
ioffset = 0  
gibit filebit gSfilename   
gichnls filenchnls gSfilename         
gilength filelen gSfilename  
                                         
gisr filesr gSfilename        
gisize2 = 2 ^ ceil(logbtwo(gilength * gisr))
gilength_s = gilength * gisr             

itemp2 ftgen $loop_left, 0, gisize2, 1, gSfilename, 0, 4, 1
if gichnls == 1 then
itemp ftgen $loop_right, 0, gisize2, 1, gSfilename, 0, 4, 1
else
itemp ftgen $loop_right, 0, gisize2, 1, gSfilename, 0, 4, 2
endif

ktrig metro 1/gilength, 0.0000001
kSwitch	changed gkdur, gkstuttermin, gkstuttermax, gkodds, gkwin, ktrig
if kSwitch=1 then	
reinit START	
endif

START:
    
idur = gilength
iamp = .9
kres = gksteps
ienv_fn = i(gkwin)   
istep_odds = .25  
istutter_min = i(gkstuttermin) 
istutter_max = i(gkstuttermax) 
istutter_odds = i(gkodds)


kstep init 0
kstutter init 1
kstutter2 init 1
kstep_counter init 0

aphasor phasor 1 / idur 
astepper = (aphasor * kres) % 1

kstepper downsamp astepper
ktrigger trigger kstepper, 0.5, 1


if ktrigger == 1 then
kstep_counter = kstep_counter + 1

kstep = kstep_counter
krandom random 0, 1
if krandom < istep_odds then
    kstep random 0, kres
    kstep = floor(kstep)
endif


kstutter = 1
krandom random 0, 1
if krandom < istutter_odds then
    krandom2 random istutter_min, istutter_max
    kstutter = 1 / floor(krandom2)
endif

kstutter2 = 1
krandom random 0, 1
if krandom < istutter_odds then
    krandom2 random istutter_min, istutter_max
    kstutter2 = 1 / floor(krandom2)
endif
endif

aplay_head = (astepper % kstutter + kstep) / kres * gilength_s
aplay_head2 = (astepper % kstutter2 + kstep) / kres * gilength_s

aleft table3 aplay_head, $loop_left, 0, 0, 1
aright table3 aplay_head2, $loop_right, 0, 0, 1

a_amp table3 astepper, ienv_fn, 1, 0, 1
a_amp = a_amp * iamp
rireturn

outs aleft * a_amp, aright * a_amp
endin

instr 3
turnoff2 2, 0, 0
gSfilename chnget "filename" ;redundancy to make sure gSfilename always has a value.
endin


</CsInstruments>
<CsScore>
f 2 0 8192 7 1 4096 0 4096 0
f 1 0 8192 7 1 8192 1
f0 60000
i1 0 99999
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
  <uuid>{68faed96-f1ed-4e69-a437-dcbf6629a795}</uuid>
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
