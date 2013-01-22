//
//  ResultsAppDelegate.m
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "AppDelegate.h"
#import "LeaguesViewController.h"
#import "LeagueTableViewController.h"
#import "LeagueResultsViewController.h"
#import "LeagueFixturesViewController.h"
#import "ServerManager.h"
#import "Reachability.h"
#import "BannerViewController.h"

@implementation AppDelegate {
    BannerViewController *_bannerViewController;
}

@synthesize internetActive, iAdBannerView;

- (void)customizeAppearance {
    // Create resizable images
    UIImage *menubar = [[UIImage imageNamed:@"menubar.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:menubar
                                       forBarMetrics:UIBarMetricsDefault];
    UIImage *barButton = [[UIImage imageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];

    UIImage *backButton = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];

    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    DLog(@"didFinishLaunchingWithOptions %@", iAdBannerView);

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *mainNav = [storyBoard instantiateViewControllerWithIdentifier:@"UINavMainController"];

    _bannerViewController = [[BannerViewController alloc] initWithContentViewController:mainNav];

//    UITabBarController *tabBar = [storyBoard instantiateViewControllerWithIdentifier:@"TableTabBarController"];
//
//    LeagueTableViewController *viewController0 = [tabBar.viewControllers objectAtIndex:0];
//    LeagueFixturesViewController *viewController1 = [tabBar.viewControllers objectAtIndex:1];
//    LeagueResultsViewController *viewController2 = [tabBar.viewControllers objectAtIndex:2];
//
//    tabBar.viewControllers = @[
//        [[BannerViewController alloc] initWithContentViewController:viewController0],
//        [[BannerViewController alloc] initWithContentViewController:viewController1],
//        [[BannerViewController alloc] initWithContentViewController:viewController2],
//    ];

    self.window.rootViewController = _bannerViewController;

    [self.window makeKeyAndVisible];
    [self customizeAppearance];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
    
    NetworkStatus networkStatus = [internetReach currentReachabilityStatus];
    [self checkNetworkStatus:networkStatus];

}

- (void)checkNetworkStatus:(NetworkStatus)networkStatus {
    
    switch (networkStatus) {
        case ReachableViaWWAN: {
            break;
        }
        case ReachableViaWiFi: {
            break;
        }
        case NotReachable: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
        }
    }
}
//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note {
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	
    NetworkStatus networkStatus = [curReach currentReachabilityStatus];
    [self checkNetworkStatus:networkStatus];
}

+ (AppDelegate *) sharedApplication {
    id result = [[UIApplication sharedApplication] delegate];
    
    if (![result isMemberOfClass:[AppDelegate class]]) {
        result = nil;
    }
    return result;
}

+ (ADBannerView *) adBannerView {
    ADBannerView *adBannerView = [self sharedApplication].iAdBannerView;
    DLog(@"adBannerView %@", adBannerView);
    return adBannerView;
}

@end
