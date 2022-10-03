#import "AppDelegate.h"
#import "FlamCam.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [((FlamCam *)[[UIApplication sharedApplication] delegate]) setLaunchOptions:launchOptions];
    return YES;
}

@end
