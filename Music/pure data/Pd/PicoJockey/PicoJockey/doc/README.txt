

Pico//Jockey package for Pd or Pd-extended


- Pure Data patches
- binary executables of:	
  [bitflip~] [krunch~]
  [complexify~] [duck~] [instantamp~] [qompand~]
  [slicerec~] [sliceplay~]
  [combsL~] [combsR~] [damp~] [dcombsL~] [dcombsR~] [diffusorL~] [diffusorR~]
- binary executables of Pd-extended classes:
  [cyclone/atan~]
  [cyclone/delay~]
  [cyclone/svf~]
  [cyclone/MouseState]
  [cyclone/Scope~]
  [hcs/split_path]
  [hcs/window_name]
  [hcs/sys_gui]
  [hcs/canvas_name]
  [zexy/limiter~]
  [zexy/z~]
- source code of these classes


////////////////////////////////////////////////////////////////////////////////


INSTALL

In order to use Pico//Jockey, you must have Pd or Pd-extended installed on your computer (http://puredata.info). 

The PicoJockey.zip package contains directory PicoJockey. Copy or move directory PicoJockey with all it's contents to any location on your computer which suits you. Do not reorganize the content within directory PicoJockey and do not change directory names.


////////////////////////////////////////////////////////////////////////////////


RUN

Start Pd extended. Select file >> open and load the patch PicoJockey.pd from directory SliceJockey2. For help, click the question mark in the PicoJockey window. For settings, click the exclamation mark. Pay special attention to audio settings. To start slice-recording, activate one of the [>] buttons and feed sounds into your computer. 


////////////////////////////////////////////////////////////////////////////////


DIRECTORY CONTENTS

The directory 'PJsessions' is for session recordings which are automatically stored there. You can safely rename recorded .wav files, play them with any soundfile player, or copy them to another location.

The directory 'bin' contain subdirs with binary class files (executables). Directory 'abstractions' contains abstractions used in [PicoJockey]. Binary executable files have extensions according to platform:

.l_i386 for Linux 32 bit
.l_ia64 for Linux 64 bit
.pd_darwin for MacOSX
.dll for Windows

If you want to use [slicerec~] and [sliceplay~] in your own patches, create a path to the directory with binary files, or move the class binaries into a path known by Pd. In that case, be sure to delete any older versions of the binaries from your computer, to avoid conflicts. See http://en.flossmanuals.net/PureData/AdvancedConfig for information about setting paths for Pd.

The directory 'src' has source code for external classes.


////////////////////////////////////////////////////////////////////////////////


BUILD

If you want to build the executables on your own machine, cd to the 'src' directory in the package and type 'make'. This should work for Linux 32 / 64 bit, Linux on armv6l (Raspberry Pi) or armv7, Windows using MinGW, and OSX (creating a fat binary for ppc and Intel 32 / 64 bit).

Binaries are copied to directory 'bin' within the package. For Pd externals under Linux, the generic extension is .pd_linux. At the moment, separate extensions are available for Linux on Intel 32 and 64 bit (as used in this package), but not for ARM processors. Do not copy .pd_linux executables in a Pd searchpath on a machine of the wrong architecture.


////////////////////////////////////////////////////////////////////////////////



SUPPORT

Slice//Jockey is documented with included help files, and a webpage at: 

http://www.katjaas.nl/slicejockey/slicejockey.html 

Individual support is not offered. For questions concerning installation and configuration of Pure Data, consult:
 
http://puredata.info/docs

Also consider searching the forum and the Pd mailing list archives: 

http://puredata.hurleur.com 
http://lists.puredata.info/pipermail/pd-list 

If you find a bug in a class, in patch [PicoJockey] or any of the included abstractions, please send an email to katjavetter@gmail.com.


////////////////////////////////////////////////////////////////////////////////


sliceplay~ version history

version 0.9.12:
- addition of 'interrupt' method and fade-out of interrupted slice
- addition of method and message selector 'minspeed' for minimum playback speed
- addition of play status message outlet
- negative cuepoints are now ignored, not interpreted modulo-loopsize


version 0.9.11: 
- used garray_getfloatwords() instead of garray_getfloatarray(), for 64 bit compatibility


version 0.91:
- fixed bug with playback speed
- amplitude compensation is now variable user parameter


version 0.9: first version


////////////////////////////////////////////////////////////////////////////////


slicerec~ version history

version 0.9.11: 
- function slicerec_fadeout() renewed and called from slicerec_analysis()
- message selector 'start' added, for manual slice-recording start 


version 0.9.1: 
- used garray_getfloatwords() instead of garray_getfloatarray(), for 64 bit compatibility


version 0.9: first version

