#import <UIKit/UIKit.h>

#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>

@interface FlamCam : UIResponder <UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol>

@property UnityFramework* ufw;

//@property (strong, nonatomic) NSString *client_key;
//@property (strong, nonatomic) NSString *client_name;
//@property (strong, nonatomic) NSString *source;

@property bool didQuit;

- (void)setLaunchOptions: (NSDictionary *)launchOpts;

- (void)initFlamCam: (NSString*) clientKey privateKey: (NSString*) privateKey clientName: (NSString*) clientName source: (NSString*) source;


- (void)loadFlamCamView;
- (void)unloadFlamCam;

- (void)didFinishLaunching:(NSNotification*)notification;
- (void)didBecomeActive:(NSNotification*)notification;
- (void)willResignActive:(NSNotification*)notification;
- (void)didEnterBackground:(NSNotification*)notification;
- (void)willEnterForeground:(NSNotification*)notification;
- (void)willTerminate:(NSNotification*)notification;
- (void)unityDidUnloaded:(NSNotification*)notification;
- (void)showAlert: (NSString*) title msg: (NSString*) msg;

@end
