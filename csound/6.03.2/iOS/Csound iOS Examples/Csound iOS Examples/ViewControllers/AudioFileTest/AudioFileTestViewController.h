/* 
 
 AudioFileTestViewController.h:
 
 Copyright (C) 2011 Thomas Hass
 
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

#import <UIKit/UIKit.h>
#import "BaseCsoundViewController.h"
#import "UIKnob.h"

@interface AudioFileTestViewController : BaseCsoundViewController <CsoundObjCompletionListener>

@property (weak, nonatomic)	IBOutlet UIButton *mPlayButton;
@property (weak, nonatomic)	IBOutlet UIKnob	  *mPitchKnob;
@property (weak, nonatomic)	IBOutlet UILabel *mPitchLabel;

- (IBAction)play:(UIButton *)sender;
- (IBAction)changePitch:(UIKnob *)sender;

@end
