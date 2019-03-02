//
//  TrappedGeneratorViewController.m
//  Csound iOS Examples
//
//  Created by Steven Yi on 1/23/13.
//
//

#import "TrappedGeneratorViewController.h"

@interface TrappedGeneratorViewController ()

@end

@implementation TrappedGeneratorViewController

-(void)viewDidLoad {
    self.title = @"Trapped Generator";
    [super viewDidLoad];
}

-(IBAction)generateTrappedToDocumentsFolder:(id)sender {
    NSString *csdPath = [[NSBundle mainBundle] pathForResource:@"trapped" ofType:@"csd"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:@"trapped.wav"];
    NSLog(@"OUTPUT: %@", localFilePath);
    
    [self.csound stopCsound];
    
    self.csound = [[CsoundObj alloc] init];
    
    [self.csound addCompletionListener:self];
    [self.csound startCsoundToDisk:csdPath outputFile:localFilePath];
    
}

#pragma mark CsoundObjCompletionListener


-(void)csoundObjDidStart:(CsoundObj*)csoundObj {
}

-(void)csoundObjComplete:(CsoundObj*)csoundObj {
    
    NSString* title = @"Render Complete";
    NSString* message = @"File generated as trapped.wav in application Documents Folder";
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
                      
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];

}


@end
