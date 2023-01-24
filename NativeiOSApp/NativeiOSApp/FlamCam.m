#import "FlamCam.h"

int gArgc = 0;
char** gArgv = NULL;
NSDictionary* appLaunchOpts;

int main(int argc, char * argv[]) {
    gArgc = argc;
    gArgv = argv;
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([FlamCam class]));
    }
}

@implementation FlamCam

- (void) setLaunchOptions: (NSDictionary *)launchOpts
{
    appLaunchOpts = launchOpts;
}

UnityFramework* UnityFrameworkLoad()
{
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];
    
    NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
    if ([bundle isLoaded] == false) [bundle load];
    
    UnityFramework* ufw = [bundle.principalClass getInstance];
    if (![ufw appController])
    {
        // unity is not initialized
        [ufw setExecuteHeader: &_mh_execute_header];
    }
    return ufw;
}

- (bool)unityIsInitialized {
    return [self ufw] && [[self ufw] appController]; }

- (void)initFlamCam: (NSString*) clientKey privateKey: (NSString*) privateKey  clientName: (NSString*) clientName source: (NSString*) source

{
    if([self unityIsInitialized]) {
        NSLog(@"Unity already initialized, Unload Unity first");
        return;
    }
    if([self didQuit]) {
        NSLog(@"Unity cannot be initialized after quit, Use unload instead");
        return;
    }
    
    [self setUfw: UnityFrameworkLoad()];
    // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
    // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
    [[self ufw] setDataBundleId: "com.unity3d.framework"];
    [[self ufw] registerFrameworkListener: self];
    //[NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
    
    [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
    
    // set quit handler to change default behavior of exit app
    [[self ufw] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };
    
    NSMutableDictionary *contentDictionary = [[NSMutableDictionary alloc]init];
    [contentDictionary setValue:clientKey forKey:@"client_key"];
    [contentDictionary setValue:privateKey forKey:@"private_key"];
    [contentDictionary setValue: clientName forKey:@"client_name"];
    [contentDictionary setValue:source forKey:@"source"];
    [contentDictionary setValue:@"" forKey:@"user_token"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contentDictionary // Here you can pass array or dictionary
                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                        error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
//    NSLog(@"Your JSON String is %@", jsonString);
    const char * inputString = [jsonString UTF8String];
    
    [[self ufw] sendMessageToGOWithName: "FlamCamera" functionName: "InitializeFlamCamera" message: inputString];
    
}

- (void)loadFlamCamView
{
    if(![self unityIsInitialized]) {
        NSLog(@"Unity is not initialized Initialize Unity first");
    } else {
        [[self ufw] showUnityWindow];
    }
}

- (void)unloadFlamCam
{
    if(![self unityIsInitialized]) {
        NSLog(@"Unity is not initialized, Initialize Unity first");
    } else {
        [[self ufw] unloadApplication];
    }
}

- (void)unityDidUnload:(NSNotification*)notification
{
    NSLog(@"unityDidUnload called");
    
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
}

- (void)unityDidQuit:(NSNotification*)notification
{
    NSLog(@"unityDidQuit called");

    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
    [self setDidQuit:true];
}

- (void)applicationWillResignActive:(UIApplication *)application { [[[self ufw] appController] applicationWillResignActive: application]; }
- (void)applicationDidEnterBackground:(UIApplication *)application { [[[self ufw] appController] applicationDidEnterBackground: application]; }
- (void)applicationWillEnterForeground:(UIApplication *)application { [[[self ufw] appController] applicationWillEnterForeground: application]; }
- (void)applicationDidBecomeActive:(UIApplication *)application { [[[self ufw] appController] applicationDidBecomeActive: application]; }
- (void)applicationWillTerminate:(UIApplication *)application { [[[self ufw] appController] applicationWillTerminate: application]; }

@end

