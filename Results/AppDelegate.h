//
//  ResultsAppDelegate.h
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class Reachability;

@interface AppDelegate : UIResponder<UIApplicationDelegate,ADBannerViewDelegate> {
    Reachability *internetReach;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL internetActive;
@property (retain, nonatomic) ADBannerView *iAdBannerView;
+ (AppDelegate *) sharedApplication;
+ (ADBannerView *) adBannerView;
@end
