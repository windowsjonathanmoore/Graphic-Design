/* 
 
 MidiTestViewController.m:
 
 Copyright (C) 2011 Steven Yi
 
 This file is part of Csound iOS Examples.
 
 The Csound for iOS Library is free software; you can redistribute it
 and/or modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.   
 
 Csound is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with Csound; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 02111-1307 USA
 
 */
#import "MidiTestViewController.h"

@implementation MidiTestViewController

-(void)viewDidLoad {
    self.title = @"MIDI Test";
    
    widgetsManager = [[MidiWidgetsManager alloc] init];
    
    [widgetsManager addSlider:mAttackSlider forControllerNumber:11];
    [widgetsManager addSlider:mDecaySlider forControllerNumber:12];
    [widgetsManager addSlider:mSustainSlider forControllerNumber:13];
    [widgetsManager addSlider:mReleaseSlider forControllerNumber:14];
    
    [widgetsManager addSlider:mCutoffSlider forControllerNumber:15];
    [widgetsManager addSlider:mResonanceSlider forControllerNumber:16];
    
    [widgetsManager openMidiIn];
    
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [widgetsManager closeMidiIn];
    
    [super viewWillDisappear:animated];
}

-(IBAction) toggleOnOff:(id)component {
	UISwitch* uiswitch = (UISwitch*)component;
	NSLog(@"Status: %d", [uiswitch isOn]);
    
	if(uiswitch.on) {
        
        NSString *tempFile = [[NSBundle mainBundle] pathForResource:@"midiTest" ofType:@"csd"];  
        NSLog(@"FILE PATH: %@", tempFile);
        
		[self.csound stopCsound];
        
        self.csound = [[CsoundObj alloc] init];
        [self.csound addCompletionListener:self];
                
        [self.csound addSlider:mCutoffSlider forChannelName:@"cutoff"];        
        [self.csound addSlider:mResonanceSlider forChannelName:@"resonance"];                
        
        [self.csound addSlider:mAttackSlider forChannelName:@"attack"];
        [self.csound addSlider:mDecaySlider forChannelName:@"decay"];
        [self.csound addSlider:mSustainSlider forChannelName:@"sustain"];
        [self.csound addSlider:mReleaseSlider forChannelName:@"release"];
        
        [self.csound setMidiInEnabled:YES];
        
        [self.csound startCsound:tempFile];
        
	} else {
        [self.csound stopCsound];
    }
}

-(IBAction) midiPanic:(id)component {
    [mCsound sendScore:@"i\"allNotesOff\" 0 1"];
}



#pragma mark CsoundObjCompletionListener

-(void)csoundObjDidStart:(CsoundObj *)csoundObj {
}

-(void)csoundObjComplete:(CsoundObj *)csoundObj {
	[mSwitch setOn:NO animated:YES];
}

#pragma mark CsoundVirtualKeyboardDelegate

-(void)keyUp:(CsoundVirtualKeyboard*)keybd keyNum:(int)keyNum {
	int midikey = 60 + keyNum;
	[mCsound sendScore:[NSString stringWithFormat:@"i-1.%003d 0 0", midikey]];	
}

-(void)keyDown:(CsoundVirtualKeyboard*)keybd keyNum:(int)keyNum {
	int midikey = 60 + keyNum;
	[mCsound sendScore:[NSString stringWithFormat:@"i1.%003d 0 -2 %d 0", midikey, midikey]];
}


@end
