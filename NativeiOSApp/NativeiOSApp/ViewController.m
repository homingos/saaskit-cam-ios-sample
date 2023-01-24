//
//  ViewController.m
//  NativeiOSApp
//
//  Created by Yash Shah on 01/10/22.
//

#import "ViewController.h"
#import "FlamCam.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)launchFlamcam:(id)sender {
    [((FlamCam *)[[UIApplication sharedApplication] delegate]) initFlamCam:@"EnterSaaSKeyHere" privateKey: @"EnterPrivateKeyHere" clientName: @"EnterSaaSNameHere" source:@"SAAS"];
    [((FlamCam *)[[UIApplication sharedApplication] delegate]) loadFlamCamView];
}

@end
